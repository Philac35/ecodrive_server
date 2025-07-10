import 'dart:convert';
import 'dart:io';

import 'package:runtime_type/runtime_type.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shared_package/Controller/Index_ControllerFunction.dart';

class RouteEntityBuilder<T>{

  String? base;
  late Router router;
  String controllerName ;
  final List<String> registeredRoutes = [];


  late  Map<String, Object> headers={'Content-Type':'application/json',
    HttpHeaders.contentEncodingHeader:'utf-8',
  //  HttpHeaders.accessControlAllowOriginHeader:'*'
  };
  Map<String, dynamic> ret={};

  RouteEntityBuilder({  required this.router,this.base='ecodrive-api'}):controllerName='${T.toString()}Controller';


  buildGetRoutes() {
    Map<String, String> queryType = {
      's': 'getEntities',
      'id': 'getEntity',
      'last': 'getLast',
      'lastid': 'getLastId',
      'delete': 'delete'
    };
    var res = {};


    for (var queryT in queryType.entries) {
      String req = queryT.value;
      /*
      print(controllerName);
      print(controllerRegistry[controllerName].toString());
      print(queryT.value);
      */

      //Print Get Routes
      //print('RoutesEntityBuilder l50 : /${"$base/"}${T.toString().toLowerCase()}/${queryT.value}');

      //classType ~= T.className
      Iterable<MapEntry<String, String>> entries;
      String path='/${"$base/"}${T.toString().toLowerCase()}/${queryT.value}';
      registeredRoutes.add('${queryT.value} [GET] : $path');
      router.get(path, (
          Request request) async
      {
        try {
          //call Entity.functionMap                      //call function     //We can provide a list of parameters or a Map cf null, Map<Symbol,dynamic>
          ret = await Function.apply(
              Index_ControllerFunctionMap[controllerName]![req]!, null,
              request.params.cast<Symbol, dynamic>()) ??
              {
                queryT.value.replaceFirst(queryT.value[0],
                    queryT.value[0].toUpperCase()): 'no response'
              };
                  print(jsonEncode(ret));
          return Response.ok(jsonEncode(ret), headers: headers);
        } catch (e) {
          return Response.internalServerError(body: 'An error occurred: $e');
        }
      });
    }
  }
  buildPostRoutes() {

    List<String> queryType = ["create", "update"];
    final classType = RuntimeType<T>().toString();
    final controllerName = '${T.toString()}Controller';

    for (var queryT in queryType) {
      String path = '/${"$base/"}${T.toString().toLowerCase()}/$queryT';
      registeredRoutes.add('$queryT [POST] : $path');

      router.post(path, (Request request) async {
        print('RouteEntityBuilder L92 debug : i pass through $queryT');
        dynamic ret;
        Map<String, dynamic> data = {};
        var headers = <String, String>{"content-type": "application/json"};

        final contentType = request.headers['content-type'] ?? '';
        Map<Symbol, dynamic> namedParams = {};

        if (contentType.contains('application/json')) {
          final bodyString = await request.readAsString();
          print("RouteEntityBuilder L103, Body: $bodyString");
          final Map<String, dynamic> body = jsonDecode(bodyString);
          data=body;
          namedParams = {
            //Type Symbol is used for reflection
            for (var entry in body.entries) Symbol(entry.key): entry.value
          };
        } else if (contentType.contains('application/x-www-form-urlencoded')) {
          final bodyString = await request.readAsString();
          final formData = Uri.splitQueryString(bodyString);

          namedParams = {
            for (var entry in formData.entries) Symbol(entry.key): entry.value
          };
        } else if (contentType.contains('multipart/form-data')) {
          // Use a package like shelf_multipart to parse
          return Response(415, body: 'multipart/form-data not supported yet');
        } else {
          return Response(400, body: 'Unsupported Content-Type');
        }
        print("RoutesEntityBuilder L123 $namedParams");
        //var controller=controllerIndex[controllerName];
        var controller=Index_ControllerFunctionMap[controllerName];
        //controller?.entity= Entity_Registry[classType].serializerClass.fromMap(data);
        ret = await Function.apply(
         controller![queryT]!,
            [namedParams]  // I set the Map in a List != to the third optional parameters
        ) ??
            {
              queryT.replaceFirst(queryT[0], queryT[0].toUpperCase()): 'no response'
            };
      
         print('RoutesEntityBuilder L140 :${jsonEncode(ret)}');

        return Response.ok(jsonEncode(ret), headers: headers);
      });
    }
  }


  buildPutRoutes() {
        List<String> queryType = ["update"];
      }
    }


  Future<Map<String, dynamic>> extractJson(Request request) async {
    final bodyString = await request.readAsString();
    return jsonDecode(bodyString) as Map<String, dynamic>;
  }

  //Exemple
  //Not usefull here
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





