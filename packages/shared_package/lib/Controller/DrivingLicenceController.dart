import 'package:angel3_framework/angel3_framework.dart';

import 'package:shared_package/Controller/Controller.dart' as controller;

import '../BDD/Model/AbstractModels/DrivingLicenceEntity.dart'  ;

@Expose('/DrivingLicence')
class DrivingLicenceController extends controller.Controller<DrivingLicence>{
  DrivingLicenceController(): super(entityFactory: (map)=>DrivingLicenceSerializer.fromMap(map));




  


  


  


  Map<String, Function> get functionMap => {'create': create, 'delete': delete, 'save': save, 'update': update, 'getEntities': getEntities, 'getEntity': getEntity, 'getLast': getLast, 'getLastId': getLastId, };

}