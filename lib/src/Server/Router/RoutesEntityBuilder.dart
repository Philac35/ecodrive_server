import 'dart:io';
import 'dart:typed_data';

import 'package:runtime_type/runtime_type.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../../Controller/Controller.dart';
import '../../BDD/Interface/entityInterface.dart';
import '../../Controller/Controller_registry.dart';

class RouteEntityBuilder<T>{

  String? base;
  late Router router;
  late  Map<String, Object> headers;
  Map<String, dynamic> ret={};

  RouteEntityBuilder({required router}) ;

  void indexControllers() {
    List<Map<String, dynamic>> index = [];
    var directory = Directory('../../Controller');
    if (directory.existsSync()) {
      List<FileSystemEntity> files = directory.listSync(recursive: false);
      for (var file in files) {
        index.add({
          'name': file.uri.pathSegments.last, // e.g., DriverController.dart
          'uri': file.uri.toString(),         // e.g., file:///.../DriverController.dart
        });
      }
    }

  }


  buildGetRoutes(){
    Map<String,String> queryType={'s':'getEntities','id':'getEntity','last':'getLast','lastid':'getLastId','delete':'delete'};
     final classType=RuntimeType<T>().toString();  //Use the package runtime_type to get the name of class of a generic
                                                   //It is no possible to use dart fonction runtimeType on generics, only on instanciated objects
    String controllerName='${classType}Controller';
    for (var queryT in queryType.entries) {
                               //classType ~= T.className
     router.get('/${"$base/"}${classType}/${queryT.value}', (Request request,Response response) => {

        if(controllerName!= null)<T>{
           controllerRegistry[controllerName]!().queryT.value

        }
        else {
          // Controller<T as EntityInterface> ()
        } ,


         Response.ok(ret,headers:headers)
      });
    }

    buildPostRoutes() {
      List<String> queryType = ["create","update"];
    }

    buildPutRoutes() {
      List<String> queryType = ["update"];
    }



}





}