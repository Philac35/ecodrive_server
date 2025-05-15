import 'dart:io';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:flutter/foundation.dart';

import '../../Loader/EnvironmentLoader.dart';

class FRouter {

  dynamic router;
  late Map<String,String> configuration ;

  Router() {
    router = Router();
    getConfiguration();
  }

  void setDefaultHeaders(HttpResponse response) {
    response.headers.contentType = ContentType('application',ContentType.json.toString(), charset: 'utf-8');
    response.headers.date= DateTime.now();
    //response.headers.expires=;

  }
  getRoutes() {
    router.get('/ecodrive-api/driver', (Request request) {
      return Response.ok('hello-world');
    });

    router.get('/ecodrive-api/<user>', (Request request, String user) {
      return Response.ok('hello $user');
    });
  }




  getConfiguration() async {
    EnvironmentLoader loader= EnvironmentLoader(path:"");
    configuration=await loader.loadEnv('ServerConfiguration');

  }

}