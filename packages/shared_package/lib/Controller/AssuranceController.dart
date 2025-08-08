import 'package:angel3_framework/angel3_framework.dart';

import 'package:shared_package/Controller/Controller.dart' as controller;

import '../BDD/Interface/entityInterface.dart';
import '../BDD/Model/AbstractModels/AssuranceEntity.dart'  ;

@Expose('/Assurance')
class AssuranceController extends controller.Controller<Assurance>{
  AssuranceController(): super(entityFactory: (map)=>AssuranceSerializer.fromMap(map));





  @override
  Future<EntityInterface?> save(entity)async {
    print('AssuranceController L18 updatedEntity : ${(entity as Assurance).vehiculeId}');
    var exit;
    try {

      exit= await repository?.persist(entity);


    } catch (e) {
      print('Controler L172, Error creating entity: $e');
    }
    exit != null? print("entity persisted !"):print("entity not persisted!");

    return exit;
  }





  


  Map<String, Function> get functionMap => {'create': create, 'delete': delete, 'save': save, 'update': update, 'getEntities': getEntities, 'getEntity': getEntity, 'getLast': getLast, 'getLastId': getLastId, };

}