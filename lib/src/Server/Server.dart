import 'dart:convert';
import 'dart:io';
import 'dart:math';
//import 'dart:ui_web';

import 'package:ecodrive_server/src/Loader/EnvironmentLoader.dart';
import 'package:ecodrive_server/src/Server/Router/Router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/src/request.dart';
import 'package:http/src/response.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:flutter/foundation.dart';
import 'package:ecodrive_server/src/Services/HTMLService/HTMLService.dart';
import 'package:universal_html/html.dart';
import 'package:universal_platform/universal_platform.dart';
class Server {


  late FRouter frouter;
  static final Server  _instance = Server._internal();

  late int id;
  late final List<String> args;
   HttpServer?  _server;
  late bool compress= false;  // use of gzip
  late Map<String,String> configuration ;

  int backlog =128;  //The number of simultaneous connection when the server is busy. If it is reached new connections are rejected until new sapce is available

  factory Server() {
    return _instance;
  }

  Server._internal(){

    id=this.getId();
    getConfiguration();
    frouter = FRouter();
    createServer();
    setServerHeader();
    this._server?.autoCompress=compress;
  }

  createServer() async {
    var context;
    try {

       if(configuration["USE_TLS"] ==true){
         context = SecurityContext();

         if(UniversalPlatform.isIOS==false || UniversalPlatform.isApple==false){
         context.useCertificateChain('certificate.pem'); //If the certificate is in the memory use useCertificateChainBytes
         }else
         {throw("Server L54, createServer : On iOS, you only call usePrivateKey with a PKCS12 file (.p12 or .pfx) that contains both the certificate chain and the private key cause thie function is a no-op");}


         context.usePrivateKey('key.pem');
       }
        _server = await io.serve(frouter.router, 'localhost', 8080,securityContext:context);
        print("SERVER STARTED");
        print('Server running on http://${_server?.address.host}:${_server?.port}');

    } catch (error, stack) {
      debugPrint("Router.dart Server fail to start, Error : ${error} ");
    }
  }


 Future<dynamic> stopServer() async {
   return this._server?.close();
  }


  getConfiguration() async {
    EnvironmentLoader loader= EnvironmentLoader(path:"");
    configuration=await loader.loadEnv('ServerConfiguration');

  }

  Future<void> getStatus() async {
    String schema='http';
    if(configuration["USE_TLS"]==true){schema='https';}

    Request request=Request( 'GET',Uri(scheme:schema,host:configuration['ADDRESS_SERVER'],path:'/ecodrive-api/status')) ;
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

  }

  /**
   * Function setServerHeader
   */
 setServerHeader(){
   this._server?.serverHeader= 'EcodriveServer/1.0';
 }

  timeOut({int timeout=144000}){
    this._server?.sessionTimeout=timeout;
  }


  /**
   * Function cldMenu
   * TODO watch how to use the cli
   */
  cliMenu(List<String>args){

    for(String arg in args) {
      switch(arg){
          case "-gzip" : compress=true;
          case "-help" : help();
      }
    }
  }


  help(){
       print('''Serveur v.1 d'Ecodrive
                options : -gzip : to compress datas   
                          -help : help menu           
         ''');

  }




  @override
  int getId() {
    var random = Random();
    int randomNumber = random.nextInt(10^15);
    return randomNumber;
  }
}


void main(List<String> args) async {
 final instance=Server();
  instance.cliMenu(args);

}