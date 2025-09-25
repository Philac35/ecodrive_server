import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:runtime_type/runtime_type.dart';
import 'package:shared_package/BDD/Interface/entityInterface.dart';
import 'package:shared_package/BDD/ORM/Relations/ClassRelation_Index.dart';
import 'package:shared_package/BDD/ORM/Relations/RelationMeta.dart';
import 'package:shared_package/Controller/Index/Controller_index.dart';
import 'package:shared_package/Controller/Index/Controller_index_unified.dart';
import 'package:shared_package/Library/FileLibrary/file_path_extension.dart';
import 'package:shared_package/Library/FileLibrary/str_path_extension.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shared_package/Library/StringLibrary/str_extension.dart';

//typedef EntityHandler = FutureOr<Response> Function(Request request, {String? id});
class RouteEntityBuilder<T> {
  String? base;
  late Router router;
  String controllerName;
  final List<String> registeredRoutes = [];

  late Map<String, Object> headers = {
    'Content-Type': 'application/json',
    HttpHeaders.contentEncodingHeader: 'utf-8',
    //  HttpHeaders.accessControlAllowOriginHeader:'*'
  };
  dynamic ret = {};

  RouteEntityBuilder({required this.router, this.base = 'ecodrive-api'})
    : controllerName = '${T.toString()}Controller';

  Future<Function?> buildEntityHandler({
    required bool withId,
    required queryT,
    required path,
  }) async {
    var res = {};
    String req = queryT!.value;
    Iterable<MapEntry<String, String>> entries;

    if (withId) {
      return (Request request, String id) async {
        // handle with id
        try {
          var controller;

          if (ControllerIndex[controllerName] != null) {
            controller = ControllerIndex[controllerName]();
          } else {
            throw ('Controller not found for ${T.toString()}');
          }
          await controller?.ready; //Check that repository is initialized.
          ret = await Function.apply(controller?.functionMap![req]!, [
            int.parse(id!),
          ]);

          print('RoutesEntityBuilder L89 : ${ret}');

          return Response.ok(jsonEncode(ret), headers: headers);
        } catch (e) {
          return Response.internalServerError(body: 'An error occurred: $e');
        }
      };
    } else {
      //Requests without id parameters
      return (Request request) async {
        try {
          //call Entity.functionMap      //call function     //We can provide a list of parameters or a Map cf null, Map<Symbol,dynamic>

          var controller;

          if (ControllerIndex[controllerName] != null) {
            controller = ControllerIndex[controllerName]();
          } else {
            throw ('Controller not found for ${T.toString()}');
          }
          await controller?.ready; //Check that repository is initialized.
          ret =
              await Function.apply(
                controller?.functionMap![req]!,
                null,
                request.params.cast<Symbol, dynamic>(),
              ) ??
              {
                queryT.value.replaceFirst(
                      queryT.value[0],
                      queryT.value[0].toUpperCase(),
                    ):
                    'No Response',
              };

          // print('RoutesEntityBuilder L80 : ${ret}');

          return Response.ok(jsonEncode(ret), headers: headers);
        } catch (e, stack) {
          print("stack: $stack ");
          return Response.internalServerError(body: 'An error occurred: $e');
        }
      };
    }
  }

  Future<Function?> buildImageHandler({required queryT, required path}) async {
    var res = {};
    String req;
    Response response;

    try {
      return (Request request, String photoName) async {
        final String imagePath;
        List<String> splitedPath = path.split(Platform.pathSeparator);
        String entityType = splitedPath[2];

        String? title = photoName.split(".")[0];
        String typePhoto = entityType.firstToUpperCase();

        String? imageDirectory = "Person"; //Default Person

        // If typePhoto= photo check Entity type in BDD to know the repertory
        if (typePhoto == 'Photo') {
          String? entityType = await checkRelationType(title);

            imageDirectory = entityType;

        } else {
          //Check typePhoto have relation IsA with Person
          String reltype = checkRelationTypePerson(typePhoto);
          imageDirectory = reltype != "" ? reltype : typePhoto;
        }

        imagePath =
            "assets/images/Application/$imageDirectory${(photoName as String).separatorAtFirst()}";

        final file = File(imagePath);
        String format = file.fileExtension() ?? 'jpeg';
        bool a = await file.exists();
        if (file.existsSync()) {
          late Map<String, Object> headers = {'Content-Type': 'image/$format'};
          return Response.ok(file.readAsBytesSync(), headers: headers);
        } else {
          return Response.notFound("Not found");
        }
      };
    } catch (e, stack) {
      print("e \n stack: $stack ");
      //return Response.internalServerError(body: 'An error occurred: $e');
    }
  }

  buildGetRoutes() async {
    Map<String, String> queryType = {
      's': 'getEntities',
      'id': 'getEntity',
      'last': 'getLast',
      'lastid': 'getLastId',
      'delete': 'delete',
      'images': 'images',
    };
    var res = {};

    for (var queryT in queryType.entries) {
      String req = queryT.value;

      //Print Get Routes
      //print('RoutesEntityBuilder l50 : /${"$base/"}${T.toString().toLowerCase()}/${queryT.value}');

      Iterable<MapEntry<String, String>> entries;
      String path = "";

      //Index Routes List
      queryType.forEach((key, value) {
        var path2 = getPath(value);
        registeredRoutes.add('${value} [GET] : $path2');
      });

      //  print('Request :${req} [GET] : $path');

      //Declare Routes
      path = getPath(queryT.value);
      if (req == 'getEntity' || req == 'delete') {
        router.get(
          path,
          (await buildEntityHandler(withId: true, queryT: queryT, path: path))!,
        );
      } else if (req == 'images') {
        router.get(
          path,
          (await buildImageHandler(queryT: queryT, path: path))!,
        );
      } else {
        router.get(
          path,
          (await buildEntityHandler(
            withId: false,
            queryT: queryT,
            path: path,
          ))!,
        );
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
        } else if (contentType.contains('application/x-www-form-urlencoded')) {
          final bodyString = await request.readAsString();
          final formData = Uri.splitQueryString(bodyString);

          if (formData['id'] != null) {
            formData['id'] =
                formData['id'] is int
                    ? formData['id'].toString()!
                    : formData['id']!;
          }
          data = formData;
        } else if (contentType.contains('multipart/form-data')) {
          // Use a package like shelf_multipart to parse
          return Response(415, body: 'multipart/form-data not supported yet');
        } else {
          return Response(400, body: 'Unsupported Content-Type');
        }

        // print("RoutesEntityBuilder L123, debug NamedParameter (Symbol):  $namedParams");
        //var controller=controllerIndex[controllerName];
        print("RoutesEntityBuilder L182, debug Request:${data.toString()}");

        var controller = ControllerIndex[controllerName]!.call();
        await controller?.ready; //Check that repository is initialized.
        var createupdate = controller!.functionMap![queryT]! as Function;

        var res = createupdate(parameters: data);
        if (res != null) {
          ret = {queryT: await res};
        } else {
          ret = {queryT: 'no response'};
        }

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

  String getPath(String entry) {
    String path;
    if (entry == 'getEntity' || entry == 'delete') {
      path = '/${"$base/"}${T.toString().toLowerCase()}/${entry}/<id>';
    } else if (entry == 'images') {
      path = '/${"$base/"}${T.toString().toLowerCase()}/${entry}/<photoName>';
    } else {
      path = '/${"$base/"}${T.toString().toLowerCase()}/${entry}';
    }
    return path;
  }

  Future<Map<String, dynamic>> extractJson(Request request) async {
    final bodyString = await request.readAsString();
    return jsonDecode(bodyString) as Map<String, dynamic>;
  }

  /**
   * Function checkRelationType
   * @Return String? relationType
   * Serve to determine photo stockage directory
   */
  Future<String?> checkRelationType(String title) async {
    String? relationType = null;

    var functionMap = ControllerIndexUnified['PhotoController']!['functionMap'];
    EntityInterface? entity = await functionMap['findByFields']({
      'title': title,
    });
    List<RelationMeta>? rMeta = ClassRelationsIndex['Photo'];

    for (var r in rMeta!) {
      if (entity?.getField(r.foreignKey.snakeToCamel()) != null ||
          entity?.getField(r.fieldName) != null) {
        return relationType = r.relatedType;
      }
    }

    return relationType;
  }

  String checkRelationTypePerson(String photoType) {
    String res = "";
    List<RelationMeta>? rMeta = ClassRelationsIndex[photoType];
    rMeta?.forEach(
      (r) => {
        if (r.relatedType == 'Person' && r.type == RelationType.isA)
          {res = "Person"},
      },
    );
    return res;
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
