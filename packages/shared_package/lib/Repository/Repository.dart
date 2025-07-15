import 'dart:async';
import 'dart:convert';

import 'package:angel3_orm/angel3_orm.dart';

import 'package:mysql_client/mysql_client.dart' ;
//import 'package:shared_package/BDD/Executor/SQLExecutor.dart';
import 'package:shared_package/BDD/Model/AbstractModels/Entity_Index.dart';
import 'package:shared_package/Repository/Abstract/AbstractRepository.dart';
import 'package:runtime_type/runtime_type.dart';
import '../BDD/Interface/entityInterface.dart';

import 'package:angel3_orm_mysql/angel3_orm_mysql.dart' show MySqlExecutor;  



class Repository<T extends EntityInterface> extends AbstractRepository <T> {

  T? entity;            

   QueryExecutor? executor;

  //final Query<T,dynamic> Function() queryFactory; //Use of parent
  final dynamic Function() queryFactory ;  // /!\ use of dynamic can lead to runtime error!  To avoid it use parent class Type and cast it to child when needed. It is less practical.
  //late HTMLFetchEntityService htmlFetchEntityService ;
  final T Function(Map<String, dynamic>) fromJson;

  MySQLConnection? connexion;
   MySQLConnectionPool? connexionPool;


  Repository({
    this.entity,
    this.executor,
    required this.queryFactory,
    required this.fromJson,
     this.connexion,
    this.connexionPool

  })  : super(
    queryFactory: (() {
      final typeKey = T.toString();
      final indexEntry = Entity_Index[typeKey];
      if (indexEntry == null) {
        throw Exception('No Index entry for $typeKey. Available: ${Entity_Index.keys}');
      }
      final queryFactory = indexEntry["queryClass"];
      if (queryFactory == null) {
        throw Exception('No queryClass for $typeKey. Entry: $indexEntry');
      }
      return queryFactory;
    })()
   ) {}


  @override
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
    String rawQuery = "Select * from $T where $whereClause ;";
    String tableName= RuntimeType<T>().toString().toLowerCase();
     return executor!.query(tableName, rawQuery, substitutionValues) as Future<List<T>>;

  }

  @override
  Future<T?> findById(int id) async{
    var query = queryFactory()
    ..where?.id!.equals(id);
    var res= (await query.get(executor)).first ;
    print("Repository L95 : Entity : ${res}");
    return res;
    //return  query.get(executor) as   Future<T?>  ;
    }

  @override
  Future<T?> findLast() async{
    var query = queryFactory()
      ..orderBy('id', descending: true)
      ..limit(1);
         var res= (await query.get(executor)).first ;
      //print("Repository L105 : Entity : ${res}");
    return res;
  }


  Future<int?> getLastId() async {
    var query = queryFactory()
      ..orderBy('id', descending: true)
      ..limit(1);
    var res = await query.getOne(executor); // This is Optional<Entity>
    return (res != null && res.isPresent) ? int.tryParse(res.value.id): null;
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
    return executor!.query(tableName, query, substitutionValues!) as Future<List<T>>;

  }

  checkConnection()async{
    if (connexion!.connected == false) {
      print('Repository: MySQL connection was closed, reconnecting...');
      await connexion!.connect();
    print('Repository: MySQL User reconnected ! ');
    executor= MySqlExecutor(connexion!);
  }
    }

  @override
  Future<bool>persist(T? entity) async {
    bool res=false;
    entity = entity?? this.entity;


    final query = queryFactory(); //with factory rendering a dynamic, i get the childclass on wich i can access copyFrom and get the values
    query.values?.copyFrom(entity);
    //print("Repository L169,${query.values.address.toString()}");
    executor==null?print('Repository, L169 : executor is null'):print('Repository, L169: executor exist');

    //checkConnection()

    print('Repository L181 : Connexion : $connexionPool');
    dynamic a= await query.insert(executor!) ;

    String resType=a.runtimeType.toString();

    if( resType.contains('_Present')) {
      res= true;
    } else if(resType.contains('_Absent')) res= false;
    else {
      print("Controller L164, resType from database contain an other case :$resType !");
      res= false;
    }
    return res;
  }


/* In Case of define explicitely Factories
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
    //checkConnection()
    final query = queryFactory();

    bool exit =false;
    if(id!=null) {
      //print("delete L199: entity id:${id}");
      query.where.id.equals(id);
      query.delete(executor);

    }else{
      //TOTEST
      query.copyFrom(entity);
      query.delete(executor);
    }
    return exit;

  }

  @override 
  Future<dynamic>update({required Map<String,dynamic> parameters,Map<String,dynamic>? whereClause}) async{
    //checkConnection()
    final query = queryFactory();

    print('Repository L216 : i am here!');
    if(parameters.containsKey('id'))
       {
         parameters['id']=parameters['id'].toString();}

    final T retEntity= Function.apply(Entity_Index[T.toString()]['fromMap'],[parameters]);
    query.values.copyFrom(retEntity); //had values to be updated

    if (whereClause!.containsKey('id')) {
      final idValue = whereClause['id'];
      if (idValue is int) {
        query.where.id.equals(idValue);
      } else if (idValue is String) {
        query.where.id.equals(int.tryParse(idValue));
      }
    }

   List<T> res= await query.update(executor) ;
    return res.length > 0;
  }  



}




/*Should be interesting to Select
extension QueryFieldSelector on Query {
  void selectFields(List<String> fields) {
    this.fields
      ..clear()
      ..addAll(fields);
  }*/

