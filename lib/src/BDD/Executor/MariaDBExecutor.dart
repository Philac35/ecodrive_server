import 'dart:async';

import 'package:angel3_orm/angel3_orm.dart';

class MariaDBExecutor extends QueryExecutor{
  @override
  // TODO: implement dialect
  Dialect get dialect => throw UnimplementedError();

  @override
  Future<List<List>> query(String tableName, String query, Map<String, dynamic> substitutionValues, {String returningQuery = '', String resultQuery = '', List<String> returningFields = const []}) {
    // TODO: implement query
    throw UnimplementedError();
  }

  @override
  Future<T> transaction<T>(FutureOr<T> Function(QueryExecutor p1) f) {
    // TODO: implement transaction
    throw UnimplementedError();
  }
  
  
}