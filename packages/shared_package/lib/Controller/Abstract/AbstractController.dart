

import 'package:shared_package/Controller/Controller.dart';
import '../../BDD/Interface/entityInterface.dart';
import '../../Repository/Repository.dart';



  abstract class AbstractController<T extends EntityInterface> {
  late Controller<T>? controller;
  late Repository<T>? repository;

  AbstractController({ this.repository, required Function(dynamic map) entityFactory});
  // CRUD Functions

  Future<bool> save(T entity);
  Future<bool> delete(int? id);
  Future<bool> update(Map<String,dynamic>parameters);
  static T create<T extends EntityInterface>(Map<String, dynamic> parameters) {
    // TODO: implement create
    throw UnimplementedError();
  }

  //Fetch Functions
  Future<List<EntityInterface>?> getEntities();
  Future<EntityInterface?>? getEntity(int id);
  Future<EntityInterface?>? getLast();
  Future<int?> getLastId();

  // Serialize
  Map<String, dynamic> toJson(T entity);
  T fromJson(Map<String, dynamic> json);
  }






