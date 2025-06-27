

import 'package:ecodrive_server/src/Controller/Controller.dart';
import '../../BDD/Interface/entityInterface.dart';
import '../../Repository/Repository.dart';



  abstract class AbstractController<T extends EntityInterface> {
  late Controller<T>? controller;
  late Repository<T>? repository;

  AbstractController({ this.repository});
  // CRUD Functions

  Future<bool> save(T entity);
  Future<bool> delete({T? entity,int? id});
  Future<bool> update(T entity);
  static T create<T extends EntityInterface>(Map<String, dynamic> parameters) {
    // TODO: implement create
    throw UnimplementedError();
  }

  //Fetch Functions
  Future<List<EntityInterface>?> getEntities();
  Future<EntityInterface?>? getEntity(int id);
  Future<EntityInterface?>? getLast();
  Future<int?>? getLastId();

  // Serialize
  Map<String, dynamic> toJson(T entity);
  T fromJson(Map<String, dynamic> json);
  }






