
import 'package:angel3_framework/angel3_framework.dart';

import 'package:shared_package/Controller/Controller.dart' as controller;

import '../BDD/Interface/entityInterface.dart';
import '../BDD/Model/Abstract/PersonEntity.dart'  ;
import '../Repository/Repository.dart';

@Expose('/person')
class PersonController extends controller.Controller<Person>{

  PersonController() : super(entityFactory: (map)=>PersonSerializer.fromMap(map));













  Map<String, Function> get functionMap => {'create': create, 'delete': delete, 'save': save, 'update': update, 'getEntities': getEntities, 'getEntity': getEntity, 'getLast': getLast, 'getLastId': getLastId, };

}