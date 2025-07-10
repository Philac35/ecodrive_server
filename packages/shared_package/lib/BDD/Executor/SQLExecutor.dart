import 'dart:async';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_package/BDD/Interface/ConnectionInterface.dart';



/// Class SQLExcutor
///  
///  Used when i didn't know there was orm_mysql intern MysqlExecutor class
///
/// /!\ Blob and timestamp not supported. We must use datetime
///     UTC datetime not supported
class SQLExecutor extends QueryExecutor {
  ConnectionInterface connexion;
  SQLExecutor({required this.connexion});
  final Dialect _dialect =MySQLDialect() ;


  @override
  Future<List<List>> query(
      String tableName,
      String query,
      Map<String, dynamic> substitutionValues, {
        String returningQuery = '',
        String resultQuery = '',
        List<String> returningFields = const [],
      }
      ) async {
    print('SQLExecutor received query: $query and values: $substitutionValues');
    List<List> result = [];
    var res = await connexion.connexion.execute(query, substitutionValues);

    if (res is EmptyResultSet) {
      //Insert Case
      var lastInsertId = res.lastInsertID;
      print("SQLExecutor L42, debug LastID inserted : ${lastInsertId.toString()}");
      var selectRes = await connexion.connexion.execute(
          'SELECT * FROM $tableName WHERE id = @id', {'id': lastInsertId}
      );
      if (selectRes is ResultSet) {
        //Return last inserted row
        final numCols = selectRes.numOfColumns;
        for (final row in selectRes.rows) {
          result.add(List.generate(numCols, (i) => row.colAt(i)));
        }
        print("SQLExecutor L52, debug ${result.toString()}");
      }
          // If no lastInsertId, result remains empty
    } else if (res is ResultSet) {
      final numCols = res.numOfColumns;
      for (final row in res.rows) {
        result.add(List.generate(numCols, (i) => row.colAt(i)));
      }
    } else {
      throw Exception('SQLExecutor l62 :Unexpected result type: ${res.runtimeType}');
    }
    return result;
  }



  /*
   * Function transaction
   * transaction are usual sql query,
   * You can send a set of queries as if it was 1.
   * they enforce ACID properties (atomicity, consistency, isolation, durability)
   */
  @override
    Future<T> transaction<T>(FutureOr<T> Function(QueryExecutor) f) {
    throw UnsupportedError('Transactions are not supported.');
  }



  @override
  Dialect get dialect => _dialect;
}