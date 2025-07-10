import 'package:ecodrive_server/src/Controller/Abstract/AbstractController.dart';
import 'package:ecodrive_server/src/Repository/Repository.dart';

import '../BDD/Interface/entityInterface.dart';

import 'package:flutter/foundation.dart';

 class Controller<T extends EntityInterface> extends AbstractController{
  T? entity;
  final T Function(Map<String, dynamic>)? entityFactory;

  Controller({
    this.entityFactory,
    Repository<T>? repository,
  }) : super( repository: repository);


  //CRUD Functions

  @override
  Future<bool> create(Map<String, dynamic> parameters) async {
    bool exit=false;
    T entity = entityFactory!(parameters);
    return save(entity);

  }

  @override
  Future<bool> delete(int? id )async {
    bool exit=false;
    try {
      var a= await repository?.delete(id); //TODO Check if it works
      exit = true;
    } catch (e) {
      debugPrint('Error deleting entity: $e');
    }
    return exit;
  }


  @override
  Future<bool> save(entity)async {
    bool exit=false;
    try {
      var a=   await repository?.persist(entity.toJson() as EntityInterface);  //TODO Check if it works
      exit = true; // Creation successful
    } catch (e) {
      print('Error creating entity: $e');
    }
    return exit;
  }

  @override
  Future<bool> update(Map<String,dynamic>parameters)async {
    bool exit=false;
    try {
      var a=   await repository?.update( parameters: parameters);  //TODO Check if it works
      exit = true; // Creation successful
    } catch (e) {
      print('Error creating entity: $e');
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
  Future<int?> getLastId() async { return  await repository?.getLastId();}
   }








