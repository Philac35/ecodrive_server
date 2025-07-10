import '../BDD/Model/AbstractModels/UserEntity.dart';
import 'package:shared_package/Controller/Controller.dart' as controller;

class UserController extends controller.Controller<User>{
  UserController(): super(entityFactory: (map)=>UserSerializer.fromMap(map));




  


  


  


  Map<String, Function> get functionMap => {'create': create, 'delete': delete, 'save': save, 'update': update, 'getEntities': getEntities, 'getEntity': getEntity, 'getLast': getLast, 'getLastId': getLastId, };

}