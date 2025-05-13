import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;


class EcoDriveRouter {

  dynamic app;

  Router() {
    app = Router();
  }


  getRoutes() {
    app.get('/ecodrive-api/driver', (Request request) {
      return Response.ok('hello-world');
    });

    app.get('/ecodrivef-api/<user>', (Request request, String user) {
      return Response.ok('hello $user');
    });
  }

  createServer() async {
    var server = await io.serve(app, 'localhost', 8080);
  }

}