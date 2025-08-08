import 'dart:async';

import 'package:angel3_framework/angel3_framework.dart';
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
import 'package:shared_package/BDD/ORM/ORMExtension/SymbolToStringConverter.dart';
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
  late Map<String, dynamic>  indexEntity;
  Controller( {
    this.entity,
    this.executor,
    required this.entityFactory,

  })  :
   super(entityFactory: (map)=>Entity_Index[T.toString()]['fromMap']!(map)){
//print("Controller L23, entity : ${entity}");

    initMySqlPoolConnection();
    if( connexionPool!=null){
    //  print( 'Controller L41, debug, ${connexionPool}');
    }
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
    connexionPool = c.connectPool(timeoutMs: 240000);

  }

   Future<bool> initRepository() async{
  bool ret=false;


       executor= MySqlPoolExecutor( connexionPool!);
       //executor==null?print('Controller, L80 executor is null'):print('Controller, L39 executor exist');}

       String typeEntry=T.toString();
        indexEntity=Entity_Index[typeEntry];
      // print("Controller L83 :$indexEntity");

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
           connexionPool: connexionPool
       );

       if(repository != null) ret==true;
       print("Controller debug L102 :${repository.toString()}");
       return ret;
   }





  //CRUD Functions



  @override
  Future<bool> create(Map<dynamic, dynamic> parameters) async {
  bool ret= false;

    //Map<String, dynamic> parameter =SymbolToStringConverter.convertSymbolKeysToString(parameters);
    parameters['createdAt']=DateTime.now();
    parameters['updatedAt']=DateTime.now();

    if(parameters['id']!=null) {
      parameters['id'] = parameters['id'] is int ? parameters['id'].toString() : parameters['id'];
    }
   // parameters= SymbolToStringConverter.convertStringKeysToSymbol(parameter);
    // print("Controller L126, create , parameters :  ${parameters.toString()}");

  var fromMap=indexEntity['fromMap'] as Function;
  T entity= fromMap(parameters);

    //T entity = entityFactory!(parameter);

    print("Controller L148, entity ${entity.toString()}");

    ORM orm= ORM();
    ret=  await orm.persist(entity)!=null ? true:false;

    return ret;
  }

  @override
  Future<bool> delete(int? id )async {
    bool exit=false;

    try {
      ORM orm=ORM();
     // await repository;

         if((await ready) == false){await initRepository();}
      print(' Controller L151, childId Type:${id.runtimeType.toString()}, id: ${id}');

         //  print("Controller L151, id ${id}");
        exit=   await orm.deleteWithCascade(T.toString(),id);
         //  exit= await repository!.delete(id);


    } catch (e) {
      print('Error deleting entity ${T.toString()}, id ${id.toString()}: $e');
    }
    return exit;
  }


  @override
  Future<EntityInterface?> save(entity)async {

    var exit;
    try {
      //print('Controller L169 debug,Entity : $entity');
      // if( repository?.connexionPool ==null){  print('Controller, L180 ConnexionPool is null');}else{print('Controller, L180 ConnexionPool in repository exist');}

 exit= await repository?.persist(entity);

      // Creation successful
     // print('Controler L169,  creating entity: $exit');

    } catch (e) {
      print('Controler L172, Error creating entity: $e');
    }
      exit != null? print("entity persisted !"):print("entity not persisted!");

    return exit;
  }


  @override
  Future<bool> update(Map<String,dynamic>parameters)async {
    bool exit=false;

    try {
      var a=   await repository?.update( parameters: parameters,whereClause:{'id':parameters['id']});  //TODO Check if it works
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
    var ret;
    try{
     ret= (await repository?.findBy(parameters))?.first;
    print(' type of findByFields, retour type:${ret.runtimeType}');
    }catch(e){print("Controller L249, FindByFields error: ${e}");
       print("Controller L250 Parameters: ${parameters}");}

    return ret;
  }


  @override
  Future<EntityInterface?> getLast()async{
       return repository?.findLast() ;
  }

  @override
  Future<int?> getLastId() async { return await repository?.getLastId();}
}









