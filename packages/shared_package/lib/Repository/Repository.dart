


import 'dart:convert';

import 'package:angel3_framework/angel3_framework.dart' ;
import 'package:angel3_framework/angel3_framework.dart' as angf;
import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_orm/angel3_orm.dart' as angorm;
import 'package:ecodrive_server/src/BDD/Connection/MysqlConnection.dart';
import 'package:ecodrive_server/src/BDD/Executor/SQLExecutor.dart';
import 'package:ecodrive_server/src/BDD/Interface/ManageBDDInterface.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/DriverEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/TravelEntity.dart';
import 'package:ecodrive_server/src/Repository/Abstract/AbstractRepository.dart';
import 'package:ecodrive_server/src/Services/HTMLService/HTMLFetchEntityService.dart';
import 'package:runtime_type/runtime_type.dart';
import '../BDD/Interface/entityInterface.dart';
import '../BDD/Model/AbstractModels/Entity_registry.dart';



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

  T entity;

  final QueryExecutor executor;
  //final QueryFactory<T> queryFactory;


  //final Query<T,dynamic> Function() queryFactory;
  final dynamic Function() queryFactory ;  // /!\ use of dynamic can lead to runtime error!  To avoid it use parent class Type and cast it to child when needed. It is less practical.
  //late HTMLFetchEntityService htmlFetchEntityService ;
  final T Function(Map<String, dynamic>) fromJson;

  Repository({
  //  required this.htmlFetchEntityService,
    required this.entity,
    required this.executor,
    required this.queryFactory,
   // required this.queryClass,
    required this.fromJson,
    Repository<T>? repository,
  }) : super(repository: repository,
      queryFactory:Entity_Registry[RuntimeType<T>()!.toString()!]! ,
      executor: SQLExecutor(connexion: MysqlConnection()));


  Future<T?> find() {
    // TODO: implement find
    throw UnimplementedError();
  }

  @override
  Future<List<T>> findAll() async {
    return await queryFactory().get(executor) as List<T>;

  }

  @override
  Future<List<T>> findBy(Map<String, dynamic> parameters) async {
    //Angel ORM doesn't take care of multiple parameters
    final whereClauses = <String>[];
    final substitutionValues = <String, dynamic>{};
    int i = 0;
    parameters.forEach((key, value) {
      final paramName = 'param$i';
      whereClauses.add('$key = @$paramName');
      substitutionValues[paramName] = value;
      i++;
    });
    final whereClause = whereClauses.isNotEmpty ? 'WHERE ${whereClauses.join(' AND ')}' : '';
    String rawQuery = "Select * from ${T} where ${whereClause} ;";
    String tableName= RuntimeType<T>().toString().toLowerCase();
     return executor.query(tableName, rawQuery, substitutionValues) as Future<List<T>>;

  }

  @override
  Future<T?> findById(int id) {

    var query = queryFactory()
    ..where?.id!.equals(id);
    return  query.get(executor) as   Future<T?>  ;
    }

  @override
  Future<T?> findLast() {
    var query = queryFactory()
      ..orderBy('id', descending: true)
      ..limit(1);
    return  query .get(executor) as   Future<T?>  ;
  }

  @override
  Future<int?> getLastId() {
    var query = queryFactory();
        query.fields.clear(); //suppress all fields and ad id
        query.fields.add('id');
        query..orderBy('id', descending: true)
        ..limit(1);
    return query .getOne(executor) as Future<int?> ;
  }

  @override
  Future queries(List<String> queries) {


    throw UnimplementedError();
    //String tableName= RuntimeType<T>().toString().toLowerCase();
   // return executor.query(tableName, rawQuery, substitutionValues) as Future<List<T>>;

  }

  @override
  Future query(String query,Map<String, dynamic>? substitutionValues) {


     String tableName= RuntimeType<T>().toString().toLowerCase();
    return executor.query(tableName, query, substitutionValues!) as Future<List<T>>;

  }


  @override
  Future<bool>persist(T? entity) async {
    entity = entity?? this.entity;
     Map<String,dynamic> values=entity.toJson();
    final query = queryFactory(); //with factory rendering a dynamic, i get the childclass on wich i can access copyFrom and get the values
    query.values?.copyFrom(entity);

    T entityPersisted=(await query.insert(executor)) as T;
    return entityPersisted!=null;
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
  Future<bool> delete(int? id)async {  // Could be EntityInterface but it doesn't have id field.

    final query = queryFactory();

    bool exit =false;
    if(id!=null) {
      query.id.delete();
      // exit = await htmlFetchEntityService.send(htmlRequest:"api/${T.runtimeType.toString()}/delete/${id}",method:"GET"); //TODO Check if type retour match
    }else{

      query.copyFrom(entity);
      query.delete();
    }
    return exit;

  }

  @override
  Future<dynamic>update({required Map<String,dynamic> parameters,Map<String,dynamic>? whereClause}) async{

    final query = queryFactory();
    query.values?.copyFrom(parameters);

    //Apply WHERE clause if provided
    if (whereClause != null) {
      whereClause.forEach((field, value) {
            query.where[field].equals(value);
      });
    }
    T entityPersisted=(await query.update(executor)) as T;
    return entityPersisted!=null;
  }  


}




/*Should be interesting to Select
extension QueryFieldSelector on Query {
  void selectFields(List<String> fields) {
    this.fields
      ..clear()
      ..addAll(fields);
  }*/

