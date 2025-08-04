import 'package:angel3_framework/angel3_framework.dart';

import 'package:shared_package/Controller/Controller.dart' as controller;

import '../BDD/Executor/MysqlPoolExecutor.dart';
import '../BDD/Model/AbstractModels/VehiculeEntity.dart'  ;
import '../BDD/Model/Index/Entity_Index.dart';
import '../Repository/VehiculeRepository.dart';

@Expose('/Vehicule')
class VehiculeController extends controller.Controller<Vehicule> {

  VehiculeController(): super(entityFactory: (map){print("VehiculeController L13, Initializor , map : ${map}");return VehiculeSerializer.fromMap(map);});


@override

  Future<bool> initRepository() async{
    bool ret=false;


    executor= MySqlPoolExecutor( connexionPool!);
    //executor==null?print('Controller, L80 executor is null'):print('Controller, L39 executor exist');}
    print("L24 , I pass in VehiculeController"); //to use specific Rep and process properties field");
    String typeEntry="Vehicule";
    indexEntity=Entity_Index[typeEntry];
    // print("Controller L27 :$indexEntity");

    final fromMap = indexEntity["fromMap"];
    if (fromMap == null) {
      throw Exception('No fromMap for $typeEntry');
    }

    final qClass=indexEntity["queryClass"];
    if(qClass==null){ throw Exception('No queryClass for $typeEntry');}

    repository= await VehiculeRepository(entity: entity,
        executor: executor!,
        queryFactory: qClass as dynamic Function(),
        fromJson: fromMap,
        connexionPool: connexionPool, connexion: null
    );

    if(repository != null) ret==true;
    print("VehiculeController debug L45 :${repository.toString()}");
    return ret;
  }










  Map<String, Function> get functionMap => {'create': create, 'delete': delete, 'save': save, 'update': update, 'getEntities': getEntities, 'getEntity': getEntity, 'getLast': getLast, 'getLastId': getLastId, };

}