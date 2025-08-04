import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:runtime_type/runtime_type.dart';
import 'package:shared_package/BDD/Interface/entityInterface.dart';
import 'package:shared_package/BDD/Model/AbstractModels/AddressEntity.dart';
import 'package:shared_package/Controller/AddressController.dart';

import 'package:shared_package/Controller/Index/Controller_index.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';


//typedef EntityHandler = FutureOr<Response> Function(Request request, {String? id});
class RouteEntityBuilder<T> {

  String? base;
  late Router router;
  String controllerName;
  final List<String> registeredRoutes = [];


  late Map<String, Object> headers = {'Content-Type': 'application/json',
    HttpHeaders.contentEncodingHeader: 'utf-8',
    //  HttpHeaders.accessControlAllowOriginHeader:'*'
  };
  dynamic ret = {};

  RouteEntityBuilder({ required this.router, this.base = 'ecodrive-api'})
      :controllerName='${T.toString()}Controller';






  Future<Function?> buildEntityHandler({required bool withId, required queryT, required path}) async {

    var res = {};
    String req = queryT!.value;
    Iterable<MapEntry<String, String>> entries;

      if (withId) {
        return (Request request, String id) async {
          // handle with id
          try {
            var controller=ControllerIndex[controllerName]!() ;
            await controller?.ready; //Check that repository is initialized.
            ret = await Function.apply(controller?.functionMap![req]!,
                [int.parse(id!)]);

            print('RoutesEntityBuilder L89 : ${ret}');

            return Response.ok(jsonEncode(ret), headers: headers);
          } catch (e) {
            return Response.internalServerError(body: 'An error occurred: $e');
          }
        };
      }
      else {
        //Requests without id parameters
        return (Request request) async {
          try {
            //call Entity.functionMap      //call function     //We can provide a list of parameters or a Map cf null, Map<Symbol,dynamic>

            var controller=ControllerIndex[controllerName]!() ;
            await controller?.ready; //Check that repository is initialized.
            ret = await Function.apply(
                controller?.functionMap![req]!,
                null,
                request.params.cast<Symbol, dynamic>()) ??
                {
                  queryT.value.replaceFirst(queryT.value[0],
                      queryT.value[0].toUpperCase()): 'No Response'
                };


               // print('RoutesEntityBuilder L80 : ${ret}');

            return Response.ok(jsonEncode(ret), headers: headers);
          } catch (e) {
            return Response.internalServerError(body: 'An error occurred: $e');
          }
        };
      }

  }





    buildGetRoutes() async {
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

        //Print Get Routes
        //print('RoutesEntityBuilder l50 : /${"$base/"}${T.toString().toLowerCase()}/${queryT.value}');


        Iterable<MapEntry<String, String>> entries;
        String path = "";
        if (req == 'getEntity' || req == 'delete') {
          path ='/${"$base/"}${T.toString().toLowerCase()}/${queryT.value}/<id>';
        }
        else {
          path = '/${"$base/"}${T.toString().toLowerCase()}/${queryT.value}';
        }


        //Index Routes List
        registeredRoutes.add('${req} [GET] : $path');
        //  print('Request :${req} [GET] : $path');

        //Declare Routes
        if (req == 'getEntity' || req == 'delete') {
          router.get(path , (await buildEntityHandler(withId: true, queryT: queryT, path:path))!);
        } else {
          router.get(path, (await buildEntityHandler(withId: false, queryT: queryT,path:path))!);
        }

      }
    }

      buildPostRoutes() {
        final stopwatch = Stopwatch()..start();
        List<String> queryType = ["create", "update"];
        final classType = RuntimeType<T>().toString();
        final controllerName = '${T.toString()}Controller';

        for (var queryT in queryType) {
          String path = '/${"$base/"}${T.toString().toLowerCase()}/$queryT';
          registeredRoutes.add('$queryT [POST] : $path');

          router.post(path, (Request request) async {
            //print('RouteEntityBuilder L92 debug : i pass through $queryT');
            dynamic ret;
            Map<String, dynamic> data = {};
            var headers = <String, String>{"content-type": "application/json"};

            final contentType = request.headers['content-type'] ?? '';


            if (contentType.contains('application/json')) {
              final bodyString = await request.readAsString();

            //  print("RouteEntityBuilder L103, Body: $bodyString");
              final Map<String, dynamic> body = jsonDecode(bodyString);
              data = body;

            } else
            if (contentType.contains('application/x-www-form-urlencoded')) {
              final bodyString = await request.readAsString();
              final formData = Uri.splitQueryString(bodyString);


              if(formData['id']!=null) {
                formData['id'] = formData['id'] is int ? formData['id'].toString()! : formData['id']!;
              }
            data=formData;

            } else if (contentType.contains('multipart/form-data')) {
              // Use a package like shelf_multipart to parse
              return Response(
                  415, body: 'multipart/form-data not supported yet');
            } else {
              return Response(400, body: 'Unsupported Content-Type');
            }

            // print("RoutesEntityBuilder L123, debug NamedParameter (Symbol):  $namedParams");
            //var controller=controllerIndex[controllerName];
           // print("RoutesEntityBuilder L182, debug Request:${data.toString()}");



            var controller=ControllerIndex[controllerName]!.call() ;
            await controller?.ready; //Check that repository is initialized.
             var createupdate=controller!.functionMap![queryT]! as Function;

           var res=  createupdate(data);
           if(res!=null){ret={queryT:await res};}
           else{ ret = {queryT: 'no response'};}

            print('RoutesEntityBuilder L161, Response :${ret.toString()}');
           // print('RoutesEntityBuilder L162, Response :${jsonEncode(ret)}');

            print('Router Response: ${stopwatch.elapsedMilliseconds}ms');

              return Response.ok(jsonEncode(ret), headers: headers);
          });
        }
      }


      buildPutRoutes() {
        List<String> queryType = ["update"];
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
            'name': file.uri.pathSegments.last,
            // e.g., DriverController.dart
            'uri': file.uri.toString(),
            // e.g., file:///.../DriverController.dart
          });
        }
      }
    }
  }



