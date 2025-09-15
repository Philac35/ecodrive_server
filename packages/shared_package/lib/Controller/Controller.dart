import 'dart:async';

import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_orm_mysql/angel3_orm_mysql.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_package/BDD/Connection/MysqlConnection.dart';
import 'package:shared_package/BDD/ORM/ORM.dart';
import 'package:shared_package/BDD/ORM/PersistenceService/CTIPersistenceService.dart';
import 'package:shared_package/BDD/ORM/PersistenceService/PersistenceServiceInterface.dart';
import 'package:shared_package/Controller/Abstract/AbstractController.dart';
import 'package:shared_package/Repository/Repository.dart';
import '../BDD/Executor/MysqlPoolExecutor.dart';
import '../BDD/Interface/entityInterface.dart';
import '../BDD/Model/Index/Entity_Index.dart';
import 'package:shared_package/BDD/ORM/ORMExtension/SymbolToStringConverter.dart';
import '../BDD/ORM/EntityMapper.dart';
import '../Services/BDDService/BDDService.dart';
import 'Index/Controller_index.dart';
import 'package:get_it/get_it.dart';
 class Controller<T extends EntityInterface> extends AbstractController{
  late GetIt getIt ;
   late ORM orm;
   final BDDService bddService = BDDService();
  MySQLConnectionPool? connectionPool;
  PersistenceServiceInterface? persistenceService;
  EntityMapper? mapper;
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
    this.entityFactory,
    this.persistenceService,

  }) :super(entityFactory: (map)=>Entity_Index[T.toString()]['fromMap']!(map)){
    getIt = GetIt.instance;
    orm = getIt<ORM>();
    mapper= getIt<EntityMapper>();
      //print("Controller L23, entity : ${entity}");
    connectionPool= getIt<MySQLConnectionPool>();
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




   Future<bool> initRepository() async{
  bool ret=false;


       executor= MySqlPoolExecutor(connectionPool!);
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
           connexionPool: connectionPool!// bddService.pool
       );

       if(repository != null) ret==true;
       print("Controller debug L102 :${repository.toString()}");


       return ret;
   }





  //CRUD Functions



  @override
  Future<EntityInterface?> create({required Map<String, dynamic> parameters}) async {
    EntityInterface? ret;

    //Map<String, dynamic> parameter =SymbolToStringConverter.convertSymbolKeysToString(parameters);
    parameters['createdAt']=DateTime.now();
    parameters['updatedAt']=DateTime.now();

    if(parameters['id']!=null) {
      parameters['id'] = parameters['id'] is int ? parameters['id'].toString() : parameters['id'];
    }
     print("Controller L126, create , parameters :  ${parameters.toString()}");

  var fromMap=indexEntity['fromMap'] as Function;
  T entity= fromMap(parameters);

    //T entity = entityFactory!(parameter);

    print("Controller L133, entity ${entity.toString()}");
       ret=  await orm.persist(entity);
        // save(entity);
    return ret;
  }


  @override
  Future<bool> delete(int? id )async {
    bool exit=false;

    try {


         if((await ready) == false){await initRepository();}
      print(' Controller L151, childId Type:${id.runtimeType.toString()}, id: ${id}');

         //  print("Controller L151, id ${id}");
       // exit=   await orm.deleteWithCascade(T.toString(),id);
    //   exit=   await orm.delete(T,cascade: true);

        exit= await repository!.delete(id:id);


    } catch (e) {
      print('Error deleting entity ${T.toString()}, id ${id.toString()}: $e');
    }
    return exit;
  }



  @override
  Future<EntityInterface?>? save(EntityInterface  entity)async {

    var exit;
    try {
      //print('Controller L169 debug,Entity : $entity');
      // if( repository?.connexionPool ==null){  print('Controller, L180 ConnexionPool is null');}else{print('Controller, L180 ConnexionPool in repository exist');}


 exit= await repository?.persist(entity);
      // Creation successful
      print('Controler L180,  creating entity: $exit');

    } catch (e,stack) {
      print('Controler L183, Error creating entity: $e');
      print("Stack: $stack");
    }
      exit != null? print("entity persisted !"):print("entity not persisted!");

    return exit;
  }


  @override
  Future<EntityInterface?> update({EntityInterface? entity,Map<String,dynamic>? parameters})async {
    EntityInterface? exit;
 if(entity!=null){parameters= entity.toJson();}
  var initready=await ready;
 if(initready==false){initRepository();}
    try {
      exit=  ( await repository?.update( parameters: parameters!,whereClause:{'id':parameters['id']}));  //TODO Check if it works

    } catch (e,stack) {
      print('Controller L200: Error creating entity: $e');
      print('Controller L201, stack: $stack');
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
  Future<List<EntityInterface?>?> getEntities() async {
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



  Future<List<EntityInterface?>?> findBy(Map<String,dynamic> parameters) async {
       return await repository?.findBy(parameters);
  }



  Future<EntityInterface?> findByFields(Map<String,dynamic> parameters) async {
    var ret;


    try{
      bool repReady=await this.ready;
      if (repReady==false){ await initRepository();}

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
  Future<int?> getLastId() async {
    try {
      return await repository?.getLastId();
    }catch(e,stack){
      print("Controller, getLastId error:$e");
      print("Controller, getLastId stack:$stack");

    }}
}









