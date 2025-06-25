import 'dart:async';

import 'package:angel3_orm/angel3_orm.dart';

abstract interface class ExecutorInterface{


  late Future<List<List>> query;
  Future<T> transaction<T>(FutureOr<T> Function(QueryExecutor) f);
  Dialect get dialect;

}