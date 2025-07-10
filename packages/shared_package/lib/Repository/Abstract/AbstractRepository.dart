

import 'package:angel3_framework/angel3_framework.dart';
//import 'package:angel3_orm/src/query.dart' as quer;
import 'package:ecodrive_server/src/BDD/Executor/SQLExecutor.dart';

import '../../BDD/Interface/entityInterface.dart';
import '../Repository.dart';

abstract class  AbstractRepository<T extends EntityInterface>{
Repository <T>?  repository;

AbstractRepository({this.repository,
  required SQLExecutor executor,
  required dynamic Function() queryFactory});

// Fetch entities Functions

Future<T?> find();
Future<T?> findById(int id);
Future<List<T>> findAll();
Future<List<T>> findBy(Map<String, dynamic> parameters);
Future<T?> findLast();
Future<int?> getLastId();
Future<dynamic> query(String query,Map<String, dynamic>? substitutionValues);
Future<dynamic> queries(List<String> queries);
  Future<bool> persist(T entity);
  Future<bool> delete(int? id);
}
