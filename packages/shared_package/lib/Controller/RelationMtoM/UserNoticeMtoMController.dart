

import 'package:shared_package/BDD/Model/RelationMtoM/UserNoticeMtoMEntity.dart';
import 'package:shared_package/Controller/Controller.dart' as controller;
import 'package:angel3_framework/angel3_framework.dart';

@Expose('/UserNoticeMtoM')
class UserNoticeMtoMController extends controller.Controller<UserNoticeMtoM>{
  UserNoticeMtoMController(): super(entityFactory: (map)=>UserNoticeMtoMSerializer.fromMap(map));













  Map<String, Function> get functionMap => {'create': create, 'delete': delete, 'save': save, 'update': update, 'getEntities': getEntities, 'getEntity': getEntity, 'getLast': getLast, 'getLastId': getLastId,'findByFields':findByFields };

}