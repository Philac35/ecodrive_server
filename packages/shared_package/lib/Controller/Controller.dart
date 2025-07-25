import 'dart:async';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_orm_mysql/angel3_orm_mysql.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_package/BDD/Connection/MysqlConnection.dart';
import 'package:shared_package/BDD/ORM/ORM.dart';
import 'package:shared_package/Controller/Abstract/AbstractController.dart';
import 'package:shared_package/Repository/Repository.dart';
import '../BDD/Executor/MysqlPoolExecutor.dart';
import '../BDD/Interface/entityInterface.dart';
import '../BDD/Model/Index/Entity_Index.dart';


import 'Index/Controller_index.dart';

 class Controller<T extends EntityInterface> extends AbstractController{

  MySQLConnection? mySQLConnection; //Single connection, disconnected regularly
  MySQLConnectionPool? connexionPool;


  QueryExecutor? executor;
  @override
  late  Repository<EntityInterface>? repository ;
  T? entity;
  final T Function(Map<String, dynamic>)? entityFactory;
  late final Future<bool> ready;
  //bool firstTime= true;

  Controller( {
    this.entity,
    this.executor,
    required this.entityFactory,

  })  :
   super(entityFactory: (map)=>Entity_Index['serializerClass'].fromMap(map),){
//print("Controller L23, entity : ${entity}");

    initMySqlPoolConnection();
    ready = initRepository();

  }  

   Future<Controller<T>> getInstance<T extends EntityInterface>({
    T? entity,
    required T Function(Map<String, dynamic>) entityFactory,
    QueryExecutor? executor,
  }) async {
    final controller = Controller<T>(
      entity: entity,
      executor: executor,
      entityFactory: entityFactory,
    );
    await controller.initRepository();
    return controller;
  }


   initMySqlConnection() async {
     MysqlConnection c= MysqlConnection();
     mySQLConnection=await c.connect();
   }

  initMySqlPoolConnection()  {

    MysqlConnection c= MysqlConnection();
    connexionPool = c.connectPool();

  }

   Future<bool> initRepository() async{
  bool ret=false;

       executor= MySqlPoolExecutor( connexionPool!);
       //executor==null?print('Controller, L39 executor is null'):print('Controller, L39 executor exist');}

       String typeEntry=T.toString();
       Map<String, dynamic>  indexEntity=Entity_Index[typeEntry];
      // print("Controller L49 :$indexEntity");

       final fromMap = indexEntity["fromMap"];
       if (fromMap == null) {
         throw Exception('No fromMap for $typeEntry');
       }

       final qClass=indexEntity["queryClass"];
       if(qClass==null){ throw Exception('No queryClass for $typeEntry');}

       repository= await Repository<T>(entity: entity,
           executor: executor!,
           queryFactory: qClass as dynamic Function(),
           fromJson: fromMap,
           connexion: mySQLConnection
       );

       if(repository != null) ret==true;
      // print("Controller debug L93 :${repository.toString()}");
return ret;
   }



  //Conversion Symbole to String
  static String symbolToString(Symbol symbol) {
    final s = symbol.toString(); // e.g. 'Symbol("foo")'
    final match = RegExp(r'^Symbol\("(.+)"\)$').firstMatch(s);
    if (match != null) {
      return match.group(1)!;
    }
    return s; // fallback, maybe 'Symbol("foo")'
  }



  static Map<String, dynamic> convertSymbolKeysToString(Map<dynamic, dynamic> map) {
    return {
      for (var entry in map.entries)
        entry.key is Symbol
            ? symbolToString(entry.key as Symbol)
            : entry.key.toString(): entry.value
    };
  }



  //CRUD Functions



  @override
  Future<bool> create(Map<Symbol, dynamic> parameters) async {
  bool ret= false;

    Map<String, dynamic> parameter =convertSymbolKeysToString(parameters);
    parameter['createdAt']=DateTime.now();
    parameter['updatedAt']=DateTime.now();

   // print("Controller L139 ${parameters.toString()}");

    T entity = entityFactory!(parameter);
        ORM orm= ORM();
    ret=  await orm.persist(entity)!=null ? true:false;

    return ret;
  }

  @override
  Future<bool> delete(int? id )async {
    bool exit=false;
    try {
      var a= await repository?.delete(id); //TODO Check if it works
      exit = true;
    } catch (e) {
      print('Error deleting entity: $e');
    }
    return exit;
  }


  @override
  Future<EntityInterface?> save(entity)async {
    Future<EntityInterface?>? exit;
    try {
      //print('Controller L169 debug,Entity : $entity');

      // if( repository?.connexionPool ==null){  print('Controller, L180 ConnexionPool is null');}else{print('Controller, L180 ConnexionPool in repository exist');}
     exit= repository?.persist(entity);  //TODO Check if it works
     print('Controler L168,  creating entity: ${await exit}');
       // Creation successful
    } catch (e) {
      print('Controler L175, Error creating entity: $e');
    }
      exit != null? print("entity persisted !"):print("entity not persisted!");

    return exit;
  }


  @override
  Future<bool> update(Map<Symbol,dynamic>parameters)async {
    bool exit=false;
    Map<String, dynamic> parameter =convertSymbolKeysToString(parameters);

    try {
      var a=   await repository?.update( parameters: parameter,whereClause:{'id':parameter['id']});  //TODO Check if it works
      exit = true; // Creation successful
    } catch (e) {
      print('Controller L193: Error creating entity: $e');
    }
    return exit;
  }







  //JSON Functions
  @override
  fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(entity) {
    return entity.toJson();
  }




  //FETCH Function
  @override
  Future<List<EntityInterface>?> getEntities() async {
    return await repository?.findAll();
  }


  @override
  //Future<Map<String, dynamic>>
  Future<EntityInterface?> getEntity(int id) async {
    /*var entity= (await repository?.findById(id)) as T;
    return {"entity": entity};
     */
    return repository?.findById(id);
  }



  Future<List<EntityInterface>?> findBy(Map<String,dynamic> parameters) async {
       return await repository?.findBy(parameters);
  }

  Future<EntityInterface?> findByFields(Map<String,dynamic> parameters) async {
    var ret= (await repository?.findBy(parameters))?.first;
    print(' type of findByFields ${ret.runtimeType}');
    return ret;
  }


  @override
  Future<EntityInterface?> getLast()async{
       return repository?.findLast() ;
  }

  @override
  Future<int?> getLastId() async { return await repository?.getLastId();}
}









