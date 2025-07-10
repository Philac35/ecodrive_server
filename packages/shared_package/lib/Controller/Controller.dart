import 'dart:async';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_orm_mysql/angel3_orm_mysql.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_package/BDD/Connection/MysqlConnection.dart';
import 'package:shared_package/Controller/Abstract/AbstractController.dart';
import 'package:shared_package/Repository/Repository.dart';
import '../BDD/Interface/entityInterface.dart';
import '../BDD/Model/AbstractModels/Entity_Index.dart';

 class Controller<T extends EntityInterface> extends AbstractController{

  MySQLConnection? mySQLConnection;
  QueryExecutor? executor;
  @override
  late  Repository<EntityInterface>? repository ;
  T? entity;
  final T Function(Map<String, dynamic>)? entityFactory;



  Controller( {
    this.entity,
    required this.entityFactory,
    this.executor,
  })  :
   super(entityFactory: (map)=>Entity_Index['serializerClass'].fromMap(map),){
//print("Controller L23, entity : ${entity}");
    initMySqlConnection();

    Timer(Duration(milliseconds:500),(){
    mySQLConnection!=null? print("Connexion exist !"):print("Connection doesn't exist !");
      executor= MySqlExecutor(mySQLConnection!);
    executor==null?print('Controller, L39 executor is null'):print('Controller, L39 executor exist');
    });

  }

   initMySqlConnection() async {
     MysqlConnection c= MysqlConnection();
     mySQLConnection=await c.connect();
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
    bool exit=false;

    Map<String, dynamic> parameter =convertSymbolKeysToString(parameters);
    parameter['createdAt']=DateTime.now();
    parameter['updatedAt']=DateTime.now();
    print("Controller L82 ${parameters.toString()}");

    T entity = entityFactory!(parameter);



    //print("Controller L70 :${entity.runtimeType}");
   String typeEntry=entity.runtimeType.toString();
    Map<String, dynamic>  indexEntity=Entity_Index[typeEntry];
   print("Controller L96 :$indexEntity");

    final fromMap = indexEntity["fromMap"];
    if (fromMap == null) {
      throw Exception('No fromMap for $typeEntry');
    }


    final qClass=indexEntity["queryClass"];
    /*
    print('indexEntity: $indexEntity');
    print('Type of indexEntity: ${indexEntity.runtimeType}');
    print('Keys: ${indexEntity.keys}');
    print('qClass: $qClass');
    print('Type of qClass: ${qClass.runtimeType}');*/
    if(qClass==null){ throw Exception('No queryClass for $typeEntry');}
    Timer(Duration(milliseconds:800),(){
        if( executor==null){print('Controller, L112 executor is null')}
      if( mySQLConnection==null){print('Controller, L112 Connexion is null')}else{print('Controller, L112 Connexion exist')}
    repository = Repository<T>(entity: entity,
    executor: executor!,
    queryFactory: qClass as dynamic Function(),
    fromJson: fromMap,
    connexion: mySQLConnection
    );
      print("Controller L123 :$repository");
     save(entity);
    });

return true;
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


      print('Controller L129 debug : $entity');
      print('Controller L130 debug : i pass here');
      var ent=entity.toJson() ;

      print('Controller L133 debug RuntimeType: ${ent.runtimeType}');
      print('Controller L134 debug : ${ent.toString()}');
      
      
      print('Controller L154 debug Repository : ${repository.toString()}');
      if( mySQLConnection==null){print('Controller, L156 Connexion is null');}else{print('Controller, L156 Connexion exist');}
      if( repository?.connexion ==null){print('Controller, L157 Connexion is null');}else{print('Controller, L157 Connexion in repository exist');}
      var a=   await repository?.persist(entity);  //TODO Check if it works

      exit = true; // Creation successful
    } catch (e) {
      print('Controler L169, Error creating entity: $e');
    }
    exit?print("entity persisted !"):print("entity not persisted!");

    return exit;
  }


  @override
  Future<bool> update(Map<String,dynamic>parameters)async {
    bool exit=false;
    try {
      var a=   await repository?.update( parameters: parameters);  //TODO Check if it works
      exit = true; // Creation successful
    } catch (e) {
      print('Controller L146: Error creating entity: $e');
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
  Future<EntityInterface?>? getEntity(int id) async {
    return await repository?.findById(id);
  }

  @override
  Future<EntityInterface?>? getLast(){
    return  repository?.findLast();
  }

  @override
  Future<int?> getLastId() async { return await repository?.getLastId();}
}









