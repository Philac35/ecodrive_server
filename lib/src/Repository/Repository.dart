


import 'dart:convert';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:ecodrive_server/src/BDD/Connection/MysqlConnection.dart';
import 'package:ecodrive_server/src/BDD/Executor/SQLExecutor.dart';
import 'package:ecodrive_server/src/BDD/Interface/ManageBDDInterface.dart';
import 'package:ecodrive_server/src/Repository/Abstract/AbstractRepository.dart';
import 'package:ecodrive_server/src/Services/HTMLService/HTMLFetchEntityService.dart';

import '../BDD/Interface/entityInterface.dart';

typedef QueryFactory<T> = dynamic Function();

//ToBe sur that the factory return the matched queryClass :
// If general function doesn't work //TOTRY 24/06/2025
/* Register factories for each entity
final Map<Type, QueryFactory> queryFactories = {
  Car: () => CarQuery(),
  Driver: () => DriverQuery(),
  // Add more as needed
};
*/


class Repository<T extends EntityInterface> extends AbstractRepository <T> {

  final QueryExecutor executor;
  final QueryFactory<T> queryFactory;

  //late HTMLFetchEntityService htmlFetchEntityService ;
  final T Function(Map<String, dynamic>) fromJson;


  Repository({
  //  required this.htmlFetchEntityService,
    required this.executor,
    required this.queryFactory,
    required this.fromJson,
    Repository<T>? repository,
  }) : super(repository: repository,
      executor: SQLExecutor(connexion: MysqlConnection()));


  Future<T?> find() {
    // TODO: implement find
    throw UnimplementedError();
  }

  @override
  Future<List<T>> findAll() {
    throw UnimplementedError();

  }

  @override
  Future<List<T>> findBy(Map<String, dynamic> parameters) async {
    throw UnimplementedError();
    /*
    print('parseResult returned: $res (${res.runtimeType})');
    if (res == null) {
      throw Exception("No data received from API");
    }
    if (res is Map && res.containsKey('error')) {
      throw Exception("API error: ${res['error']}");
    }
    if (res is! List) {
      throw Exception("Expected a List from parseResult, got ${res.runtimeType}");
    }
    // Ensure result is a List and convert each item to T
    if (res is List) {
      return res.map<T>((item) => fromJson(item)).toList();
    } else {
      throw Exception("Expected a List from parseResult");
    }
*/
  }

  @override
  Future<T?> findById(int id) {
    throw UnimplementedError();
  }

  @override
  Future<T?> findLast() {
    throw UnimplementedError();
  }

  @override
  Future<int> getLastId() {
    throw UnimplementedError();
  }

  @override
  Future queries(List<String> queries) {
    throw UnimplementedError();
  }

  @override
  Future query(String query) {
    List<String> queries=[query];
   return this.queries(queries);
  }


  @override
  Future<bool>persist(T entity) async {
    final query = queryFactory();
    query.values = entity;
    return await query.insert(executor);
  }


/* In Case of define explicitely Factories cf note 24/06/2026 l17
  Future<T> persist(T entity) async {
    final factory = queryFactories[T];
    if (factory == null) {
      throw Exception('No query factory registered for type $T');
    }
    final query = factory() as dynamic; // Must be dynamic due to Dart's type system
    query.values = entity;
    return await query.insert(executor);
  }
*/

  @override
  Future<bool> delete({int? id, EntityInterface? entity})async {
    bool exit =false;
    if(id!=null){
 //  exit= await htmlFetchEntityService.send(htmlRequest:"api/${T.runtimeType.toString()}/delete/${id}",method:"GET"); //TODO Check if type retour match
     }else if(entity!=null){
   // exit = await  htmlFetchEntityService.send(htmlRequest:"api/${T.runtimeType.toString()}/delete}",method:"POST", data:jsonEncode(entity.toJson()));//TODO check if entity is well turn as String
    }
    return exit;

  }

  @override
  Future<bool>update(EntityInterface entity) {
    throw UnimplementedError();
  }


}

extension on QueryBase {
  set values(values) {}

  insert(QueryExecutor executor) {}


}