import 'dart:async';
import 'dart:convert';
import 'package:angel3_orm/angel3_orm.dart';
import 'package:logging/logging.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_package/BDD/ManageBDD.dart';

import 'MySqlTransactionExecutor.dart';

class MySqlPoolExecutor extends QueryExecutor {
  /// An optional [Logger] to write to. A default logger will be used if not set
  late Logger _logger;

  final MySQLConnectionPool _pool;
  late final stopwatch;

  MySqlPoolExecutor(this._pool, {Logger? logger}) {
    _logger = logger ?? Logger('MySqlExecutor');
     stopwatch = Stopwatch()..start();
    // _connection != null ? print('orm_mysql MysqlExecutor L14, debug : connection is null'):
    //print('orm_mysql L14, debug : connection is null');
  }



  final Dialect _dialect = const MySQLDialect();

  @override
  Dialect get dialect => _dialect;

  Future<void> close() {
    return _pool.close();
  }

  MySQLConnectionPool get rawConnection => _pool;

  /*
  Future<Transaction> _startTransaction() {
    if (_connection is Transaction) {
      return Future.value(_connection as Transaction?);
    } else if (_connection is MySqlConnection) {
      return (_connection as MySqlConnection).begin();
    } else {
      throw StateError('Connection must be transaction or connection');
    }
  }

  @override
  Future<List<List>> query(
      String tableName, String query, Map<String, dynamic> substitutionValues,
      [List<String> returningFields = const []]) {
    // Change @id -> ?
    for (var name in substitutionValues.keys) {
      query = query.replaceAll('@$name', '?');
    }

    logger?.fine('Query: $query');
    logger?.fine('Values: $substitutionValues');

    if (returningFields.isNotEmpty != true) {
      return _connection!
          .prepared(query, substitutionValues.values)
          .then((results) => results.map((r) => r.toList()).toList());
    } else {
      return Future(() async {
        var tx = await _startTransaction();

        try {
          var writeResults =
              await tx.prepared(query, substitutionValues.values);
          var fieldSet = returningFields.map((s) => '`$s`').join(',');
          var fetchSql = 'select $fieldSet from $tableName where id = ?;';
          logger?.fine(fetchSql);
          var readResults =
              await tx.prepared(fetchSql, [writeResults.insertId]);
          var mapped = readResults.map((r) => r.toList()).toList();
          await tx.commit();
          return mapped;
        } catch (_) {
          await tx.rollback();
          rethrow;
        }
      });
    }
  }
 */

  @override
  Future<List<List>> query(
      String tableName,
      String query,
      Map<String,
      dynamic> substitutionValues,
      { String returningQuery = '',
        String resultQuery = '',
        List<String> returningFields = const []}) async {

     late List<List> ret;
    //manage preferences of Vehicule
    if (substitutionValues.containsKey('preferences')) {
      var prefs = substitutionValues['preferences'];
      if (prefs == null) {
        substitutionValues['preferences'] = null;
      } else if (prefs is List) {
        substitutionValues['preferences'] = jsonEncode(prefs);
      }
      // else if it's already a String, assume it's encoded JSON
    }

    //Substitution system : Change @parameter -> ?
    for (var name in substitutionValues.keys) {
      query = query.replaceAll('@$name', ':$name');
     // print("MysqlPoolExecutor L99 query:$query");
      // Convert UTC time to local time
      var value = substitutionValues[name];

     //Utilistation du system temporel local
      if (value is DateTime && value.isUtc) {
        var t = value.toLocal();
        //_logger.fine('Datetime deteted: $name');
        //_logger.fine('Datetime: UTC -> $value, Local -> $t');

        substitutionValues[name] = t;
      }
    }


    //_logger.fine('Query: $query');
    //_logger.fine('Values: $substitutionValues');
    //_logger.fine('Returning Query: $returningQuery');
    //print("MysqlPoolExecutor L130 query:$query");

    if (returningQuery.isNotEmpty) {
      // Handle insert, update and delete
      // Retrieve back the inserted record



      //INSERT
      if (query.startsWith("INSERT")) {
        // _connection != null ? print('orm_mysql L127, debug : connection is null'):
       // print("MysqlPoolExecutor L143 substitutions values:$substitutionValues");


      print("MysqlPoolExecutor L142 ${query.toString()}");
        IResultSet result;
        try {
          result = await _pool.execute(query, substitutionValues).timeout(const Duration(minutes: 2));
          print('Insert in BDD: ${stopwatch.elapsedMilliseconds}ms');

          //print("MysqlPoolExecutor L149 result:$result");
          print('Last id : ${result.lastInsertID}');

        query = returningQuery;
        //logger.fine('Result.insertId: ${result.insertId}');

        // Has primary key
        if (returningQuery.endsWith('.id=?')) {
          query = query.replaceAll("?", ":id");
          substitutionValues.clear();
          substitutionValues['id'] = result.lastInsertID;
        } else {
          query = _convertSQL(query, substitutionValues);
        }
        }catch(e){print("MysqlPoolExecutor L152, query : error :$e");}
      }

      //UPDATE
      else if (query.startsWith("UPDATE")) {
        try{
        await _pool.execute(query, substitutionValues);
      }catch(e){print("MysqlPoolExecutor L159, Update query : error :$e");}
        query = returningQuery;
      }
    }

    //DELETE
    // Select the deleted records prior to being delete
    var isDeleteQuery = query.startsWith("DELETE");
    List<List<dynamic>> deletedResults = [];
    if (isDeleteQuery) {
      var selectQuery = query.replaceFirst("DELETE", "SELECT *");
      //_logger.fine('Select query for delete: $selectQuery');

      deletedResults = await _pool
          .execute(selectQuery, substitutionValues)// it deletes nothing here, it returns selection
          .timeout(const Duration(minutes: 1))
          .then((results) {
        return results.rows.map((r) => r.typedAssoc().values.toList()).toList();
      })
       .catchError((onError){print("MysqlPoolExecutor L157, Delete query : error :$onError");});


    }

    //_logger.fine('Query 2: $query');
    //_logger.fine('Values 2: $substitutionValues');
    //query=query.replaceFirst('assurances.document_pdf,','');


    // Execute Delete or Select Query,
    // Select last entry from BDD for an Insert
    // Return parseSQLResult


    return _pool.execute(query, substitutionValues).then((results) {
      print('2nd query in BDD: ${stopwatch.elapsedMilliseconds}ms');
      if (isDeleteQuery) {
        return deletedResults;
      } else {
        //return results.rows.map((r) => r.typedAssoc().values.toList()).toList();

        var ret =parseSQLResult(results);
        print('parse 2nd result: ${stopwatch.elapsedMilliseconds}ms');
        // print('MysqlPoolExecutor L203 , FromResultSet $ret');
        return ret;
      }
    }).timeout(const Duration(minutes: 3, seconds: 30))

        .catchError((e){print("MysqlPoolExecutor L171, Select query : error :$e");});


   // return ret ;
  }






  String _convertSQL(String query, Map<String, dynamic> substitutionValues) {
    var newQuery = query;
    for (var k in substitutionValues.keys) {
      var fromPattern = '.$k = ?';
      var toPattern = '.$k = :$k';
      newQuery = newQuery.replaceFirst(fromPattern, toPattern);
    }

    return newQuery;
  }

  List<List<dynamic>> parseSQLResult(IResultSet res) {
    //var colTypes = res.cols.map((col) => col.type).toList();

    var mappedResult = <List>[];
    for (var row in res.rows) {
      List<dynamic> retResult = [];
      for (var i = 0; i < row.numOfColumns; i++) {
        var val = row.typedColAt(i);

        retResult.add(val);
      }

      mappedResult.add(retResult);
    }

    return mappedResult;
  }

  /*
  Map<String, dynamic> parseSQLNamedResult(IResultSet res) {
    var colNames = [];
    var columns = [];
    var prefix = "1__";
    for (var c in res.cols) {
      if (colNames.contains(c.name)) {
        // If collumn name is duplicated, add "1_" as prefix
        var tmpColName = "$prefix${c.name}";
        while (colNames.contains(tmpColName)) {
          tmpColName = "$prefix$tmpColName";
        }
        columns.add((name: tmpColName, type: c.type));
        colNames.add(tmpColName);
      } else {
        columns.add((name: c.name, type: c.type));
        colNames.add(c.name);
      }
    }

    var row = res.rows.first;

    Map<String, dynamic> retResult = {};
    for (var i = 0; i < row.numOfColumns; i++) {
      var val = row.typedColAt(i);
      var colName = columns[i].name;

      retResult[colName] = val;
    }

    return retResult;
  }
  */

  @override
  Future<T> transaction<T>(FutureOr<T> Function(QueryExecutor) f) async {
    //logger.warning("Transaction");

    T? returnValue = await _pool.transactional((ctx) async {
      try {
        //logger.fine('Entering transaction');

        var tx = MySqlTransactionExecutor(ctx, logger: _logger);
        return await f(tx);
      } catch (e) {
        _logger.severe('Failed to run transaction', e);
        rethrow;
      }
    });

    return returnValue!;
  }
/*
  @override
  Future<T> transaction<T>(FutureOr<T> Function(QueryExecutor) f) async {
    if (_connection is Transaction) {
      return await f(this);
    }

    Transaction? tx;
    try {
      tx = await _startTransaction();
      var executor = MySqlExecutor(tx, logger: logger);
      var result = await f(executor);
      await tx.commit();
      return result;
    } catch (_) {
      await tx?.rollback();
      rethrow;
    }
  }
  */
}
