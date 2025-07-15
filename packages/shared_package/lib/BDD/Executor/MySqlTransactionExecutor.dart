import 'dart:async';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:logging/src/logger.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:universal_html/js_util.dart';

class MySqlTransactionExecutor implements QueryExecutor {
  final MySQLConnection conn;

  MySqlTransactionExecutor(this.conn, {required Logger logger});

  @override
  Future<IResultSet> execute(String sql, [Map<String, dynamic>? params]) {
    return conn.execute(sql, params ?? {});
  }

  @override
  Dialect get dialect => MySQLDialect(); // Or your actual dialect

  @override
  Future<List<List>> query(
      String tableName,
      String query,
      Map<String, dynamic> substitutionValues, {
        String returningQuery = '',
        String resultQuery = '',
        List<String> returningFields = const [],
      }) async {
    final result = await conn.execute(query, substitutionValues);


    return result.rows.map((row) => row.typedAssoc().values.toList()).toList();

  }

  @override
  Future<T> transaction<T>(FutureOr<T> Function(QueryExecutor p1) f) async {
    throw UnsupportedError("Nested transactions are not supported.");
    // Or: return await f(this);
  }
}


