import 'dart:io';

import 'package:shared_package/BDD/Model/AbstractModels/AddressEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/AdministratorEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/AssuranceEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/CommandEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/DriverEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/DrivingLicenceEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/EmployeeEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/ItineraryEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/NoticeEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/PhotoEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/TravelEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/UserEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/VehiculeEntity.dart';
import 'package:shared_package/Loader/EnvironmentLoader.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shared_package/BDD/Model/AbstractModels/Entity_registry_saved.dart';
import 'RoutesEntityBuilder.dart';
//import '../../Loader/EnvironmentLoader.dart';

class FRouter {

  late Router router;
  late Map<String,String> configuration={} ;

  FRouter() {
    getConfiguration();
    router = Router();
    getRoutes();

  }

  void setDefaultHeaders(HttpResponse response) {
    response.headers.contentType = ContentType('application',ContentType.json.toString(), charset: 'utf-8');
    response.headers.date= DateTime.now();
    //response.headers.expires=;

  }
  getRoutes() {
    router.get('/ecodrive-api/hello-world', (Request request) {
      return Response.ok('Hello-World');
    });

    router.get('/ecodrive-api/user/<userName>', (Request request)async {

        var userName = request.params['userName'];
      return Response.ok('>Hello $userName');
    });

    Iterable<MapEntry<String, dynamic>> classList=Entity_Registry.entries ;
     for (var c in classList){
        RouteEntityBuilder<dynamic>? routeEntity ;

        //print(router);
        switch(c.value['type'].toString()){   //Les types ne peuvent pas être utilisé via des variable dans un constructeur d'ou ce switch
          case 'Address':  routeEntity=  RouteEntityBuilder<Address> (router:router);
          case 'Assurance': routeEntity=  RouteEntityBuilder<Assurance> (router:router);
          case 'Administrator': routeEntity=  RouteEntityBuilder<Administrator> (router:router);
          case 'DrivingLicence': routeEntity=  RouteEntityBuilder<DrivingLicence> (router:router);
          case 'Command':  routeEntity=  RouteEntityBuilder<Command> (router:router);
          case 'User': routeEntity=  RouteEntityBuilder<User> (router:router);
          case 'Driver': routeEntity=  RouteEntityBuilder<Driver> (router:router);
          case 'Employee': routeEntity=  RouteEntityBuilder<Employee> (router:router);
          case 'Itinerary': routeEntity=  RouteEntityBuilder<Itinerary> (router:router);
          case 'Notice': routeEntity=  RouteEntityBuilder<Notice> (router:router);
          case 'Photo':  routeEntity=  RouteEntityBuilder<Photo> (router:router);
          case 'Travel':  routeEntity=  RouteEntityBuilder<Travel> (router:router);
          case 'Vehicule':  routeEntity=  RouteEntityBuilder<Vehicule> (router:router);
        }

        routeEntity!.buildGetRoutes();
        routeEntity!.buildPostRoutes();

         //Print Route form Entity
        print('Entity : ${c.value['type']}');
         List routes=routeEntity.registeredRoutes;
         for (var route in routes) {
           print(route);
         }
         print("");
     }


  }

  getConfiguration()async{
    EnvironmentLoader loader=EnvironmentLoader();
    configuration =( loader.gnlConfigurationf())!;
  }

}