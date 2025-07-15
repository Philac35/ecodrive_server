import 'dart:async';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_orm_mysql/angel3_orm_mysql.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_package/BDD/Connection/MysqlConnection.dart';
import 'package:shared_package/Controller/Abstract/AbstractController.dart';
import 'package:shared_package/Repository/Repository.dart';
import '../BDD/Executor/MysqlPoolExecutor.dart';
import '../BDD/Interface/entityInterface.dart';
import '../BDD/Model/AbstractModels/Entity_Index.dart';

 class Controller<T extends EntityInterface> extends AbstractController{

  MySQLConnection? mySQLConnection; //Single connection, disconnected regularly
  MySQLConnectionPool? connexionPool;


  QueryExecutor? executor;
  @override
  late  Repository<EntityInterface>? repository ;
  T? entity;
  final T Function(Map<String, dynamic>)? entityFactory;
  late final Future<void> ready;
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

   initRepository() async{


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

      // print("Controller debug L93 :${repository.toString()}");



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
    Future<bool> ret;

    Map<String, dynamic> parameter =convertSymbolKeysToString(parameters);
    parameter['createdAt']=DateTime.now();
    parameter['updatedAt']=DateTime.now();
    //print("Controller L82 ${parameters.toString()}");

    T entity = entityFactory!(parameter);

    ret= save(entity);

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
  Future<bool> save(entity)async {
    bool exit=false;

    try {
      print('Controller L140 debug,Entity : $entity');

      var ent=entity.toJson() ;

      //print('Controller L144 debug RuntimeType: ${ent.runtimeType}');
      //print('Controller L145 debug : ${ent.toString()}');
      
     // print('Controller L148 debug Repository : ${repository.toString()}');
    //  if( mySQLConnection==null){print('Controller, L149 Connexion is null');}else{print('Controller, L149 Connexion exist');}
      if( repository?.connexionPool ==null){print('Controller, L150 ConnexionPool is null');}else{print('Controller, L150 ConnexionPool in repository exist');}
      var a=   await repository?.persist(entity);  //TODO Check if it works

      exit = true; // Creation successful
    } catch (e) {
      print('Controler L169, Error creating entity: $e');
    }
    exit?print("entity persisted !"):print("entity not persisted!");

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
  Map<String, dynamic> toJson(entity) {
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

  @override
  Future<EntityInterface?> getLast()async{
       return repository?.findLast() ;
  }

  @override
  Future<int?> getLastId() async { return await repository?.getLastId();}
}









