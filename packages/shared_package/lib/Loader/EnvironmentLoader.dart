

import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';



class EnvironmentLoader{

  String? environment;  //dev, prod, test etc
  String? path;
  Map<String, String>? gnlconfiguration;
EnvironmentLoader({this.environment,this.path}){
  if(this.environment==null){
      gnlConfiguration();
  }
}


  Future<Map<String, String>?> gnlConfiguration() async{
  try {
    await dotenv.load(fileName: '${path}/ConfigurationServer.env');
    return gnlconfiguration= Map<String, String>.from(dotenv.env);

  }catch(e){print ('EnvironmentLoader L23, Could not load general configuration! error:${e}');}
}

 Future<Map<String, String>> loadBDD() async {
   final file = "${path ?? ''}ConfigurationBDD.$environment.env";
   await dotenv.load(fileName: file);
   return Map<String, String>.from(dotenv.env);
 }

  Future<Map<String, String>> loadEnv(String fileName) async {
   final prefix = (path != null && path!.isNotEmpty && !path!.endsWith('/')) ? "${path!}/" : (path ?? '');
   final file = "$prefix$fileName.$environment.env";
   await dotenv.load(fileName: fileName);
   return Map<String, String>.from(dotenv.env);
 }

}