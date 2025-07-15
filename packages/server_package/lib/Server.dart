
import 'dart:io';
import 'dart:io' as io;
import 'dart:math';


import 'package:shared_package/Loader/EnvironmentLoader.dart';

import '../Router/Router.dart';
import 'package:shelf/shelf_io.dart' as io;
//import '../Services/HTMLService/HTMLService.dart';
import 'package:universal_platform/universal_platform.dart';
class Server {

   int? _pid;

  late FRouter frouter;
  static final Server  _instance = Server._internal();

  static Server get instance {
    return _instance;
  }

  late int id;
  late final List<String> args;
   HttpServer?  _server;
  late bool compress= false;  // use of gzip
   Map<String,String>? configuration={};

  int backlog =128;  //The number of simultaneous connection when the server is busy. If it is reached new connections are rejected until new sapce is available

  factory Server() {
    return instance;
  }

  Server._internal() {

    id=getId();


     getConfiguration();
    Future.delayed(Duration(seconds: 120));
    //debugPrint("server_package L39 : ${configuration!.toString()}");

    frouter = FRouter();
    createServer();
    Future.delayed(Duration(seconds: 60));
    setServerHeader();
    _server?.autoCompress=compress;
  }

  createServer() async {
    SecurityContext? context;
    try {

       if(configuration!["USE_TLS"] ==true){
         context = SecurityContext();

         if(UniversalPlatform.isIOS==false || UniversalPlatform.isApple==false){
         context.useCertificateChain('certificate.pem'); //If the certificate is in the memory use useCertificateChainBytes
         }else
         {throw("server_package L54, createServer : On iOS, you only call usePrivateKey with a PKCS12 file (.p12 or .pfx) that contains both the certificate chain and the private key cause thie function is a no-op");}


         context.usePrivateKey('key.pem');
       }
       var route=frouter.router;
        _server = await io.serve(route.call, 'localhost', 8080,securityContext:context);
        print("SERVER STARTED");
        print('server_package running on http://${_server?.address.host}:${_server?.port}');

    } catch (error) {
        print("Router.dart server_package fail to start, Error : $error ");
    }
  }


 static Future startServer() async{
    Server();
    pidwrite() ;
 }

  static Future<dynamic> stopServer() async {
 Map<dynamic, Object>? pidNum= readPid();
    final killed = Process.killPid(pidNum!['pid'] as int);
    if (killed) {
      print('server_package process $pidNum killed.');
      (pidNum['file'] as File).deleteSync();
    } else {
      print('Failed to kill process $pidNum. It may not be running.');
    }


  }

   getConfiguration()async{
     EnvironmentLoader loader=EnvironmentLoader();
     configuration =( loader.gnlConfigurationf())!;
   }


  /*
  Future<void> getStatus() async {
    String schema='http';
    if(configuration!["USE_TLS"]==true){schema='https';}

    Request request=Request( 'GET',Uri(scheme:schema,host:configuration!['ADDRESS_SERVER'],path:'/ecodrive-api/status')) ;
    final status = {
      'status': 'running',
      'timestamp': DateTime.now().toIso8601String()
    };

    HTMLService htmlService= HTMLService(isEncrypted: false);
    bool sent= await htmlService.send(htmlRequest: request,method:'GET');
  if(sent){

    Response? res=await htmlService.response;
    if(res?.statusCode==200){print(status.toString());
        }
    else{print("The server is not Running. Status Code : ${res?.statusCode}. Cause : ${res?.reasonPhrase}");}
  }

  }*/

  /// Function setServerHeader
 setServerHeader(){
   _server?.serverHeader= 'EcodriveServer/1.0';
 }

  timeOut({int timeout=144000}){
    _server?.sessionTimeout=timeout;
  }


  /// Function cliMenu
  /// TODO watch how to use the cli
  static cliMenu(List<String>args){
  //print (args);
    for(String arg in args) {
      switch(arg){
          case "-start" : startServer() ;
          case "-stop" : Server.stopServer();
          case "-gzip" : instance.compress=true; print('Compression activated');
          case "-help" : help();
      }
    }
  }


 static help(){
       print('''Serveur v.1 d'Ecodrive
       options : -start
                 -stop
                 -gzip : to compress datas   
                 -help : help menu           
         ''');

  }




  @override
  int getId() {
    var random = Random();
    int randomNumber = random.nextInt(10^15);
    return randomNumber;
  }

   /// Function pidwrite
   /// Fetch current server_package pid and save it in file
  static pidwrite(){
    final pidFile = File('server.pid');
    pidFile.writeAsStringSync(io.pid.toString());}


static  Map<dynamic, Object>?  readPid(){
     final pidFile = File('server.pid');
     if (!pidFile.existsSync()) {
       print('PID file not found. server_package may not be running.');
       return null;
     }
     final pidStr = pidFile.readAsStringSync();
     final pidNum = int.tryParse(pidStr);
     if (pidNum == null) {
       print('Invalid PID in file.');
       return null;
     }
    return {'pid':pidNum,'file':pidFile};
   }
}


//void main(List<String> args) async {
 //final instance=server_package();
  //:instance.cliMenu(args);

//}