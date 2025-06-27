import 'dart:io';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

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
  }


  getConfiguration() async {

    File conf = File('../Configuration/ConfigurationServer.env');
    List<String> line = await conf.readAsLines();
    for (var l in line) {
      List<String> keyvalue = l.split('=');
      configuration?.addAll({keyvalue[0]: keyvalue[1]});
    }

    /*getConfiguration() async {
    EnvironmentLoader loader= EnvironmentLoader(path:"");
    configuration=await loader.loadEnv('ServerConfiguration');

  }*/

  }
}