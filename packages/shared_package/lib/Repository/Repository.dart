import 'dart:async';

import 'package:angel3_orm/angel3_orm.dart';

import 'package:mysql_client/mysql_client.dart' ;
//import 'package:shared_package/BDD/Executor/SQLExecutor.dart';
import 'package:shared_package/BDD/Model/AbstractModels/Entity_Index.dart';
import 'package:shared_package/Repository/Abstract/AbstractRepository.dart';
import 'package:runtime_type/runtime_type.dart';
import '../BDD/Interface/entityInterface.dart';

import 'package:angel3_orm_mysql/angel3_orm_mysql.dart' show MySqlExecutor;  


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

   QueryExecutor? executor;
  //final QueryFactory<T> queryFactory;

  //final Query<T,dynamic> Function() queryFactory;
  final dynamic Function() queryFactory ;  // /!\ use of dynamic can lead to runtime error!  To avoid it use parent class Type and cast it to child when needed. It is less practical.
  //late HTMLFetchEntityService htmlFetchEntityService ;
  final T Function(Map<String, dynamic>) fromJson;
   MySQLConnection? connexion;
  Repository({
  //  required this.htmlFetchEntityService,
    required this.entity,
    this.executor,
    required this.queryFactory,
   // required this.queryClass,
    required this.fromJson,
    required this.connexion

  })  : super(
    queryFactory: (() {
      final typeKey = entity.runtimeType.toString();
      final registryEntry = Entity_Index[typeKey];
      if (registryEntry == null) {
        throw Exception('No registry entry for $typeKey. Available: ${Entity_Index.keys}');
      }
      final queryFactory = registryEntry["queryClass"];
      if (queryFactory == null) {
        throw Exception('No queryClass for $typeKey. Entry: $registryEntry');
      }
      return queryFactory;
    })(),
    //executor:  MySqlExecutor( MysqlConnection().connexion)
  )  {

/*
    if(connexion==null){
    initMySqlConnection();}
    connexion!=null? print("Connexion exit !"):print("Connection doesn't exit !");
*/
    //Timer(Duration(seconds:240), ()=>executor=MySqlExecutor(connexion!));

  }



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
    return executor!.query(tableName, query, substitutionValues!) as Future<List<T>>;

  }


  @override
  Future<bool>persist(T? entity) async {
    bool res=false;
    entity = entity?? this.entity;



     Map<String,dynamic> values=entity.toJson();
     Map<Symbol, dynamic>  namedParams =  { for (var entry in values.entries)  Symbol(entry.key): entry.value ?? ''};    var aentity=Function.apply(fromJson,[namedParams]);
     print(" Repository L168: Entity fromJson: ${aentity.runtimeType}");
    //print(" Repository L169: Entity fromJson: ${a.}");

    print("Repository L166 ${values.toString()}");
    final query = queryFactory(); //with factory rendering a dynamic, i get the childclass on wich i can access copyFrom and get the values
    query.values?.copyFrom(entity);
    print("Repository L169,${query.values.address.toString()}");
    executor==null?print('Repository, L169 : executor is null'):print('Repository, L169: executor exist');
    if( connexion ==null){
      print('Repository, L170: Connexion in repository is null');}
    else{print('Repository, L170 : Connexion in repository exist');}

    if (connexion!.connected == false) {
      print('Repository: MySQL connection was closed, reconnecting...');
      await connexion!.connect();
      print('Repository: MySQL User reconnected ! ');
    executor= MySqlExecutor(connexion!);
    }

    print('Repository L175 : Connexion : $connexion');
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

