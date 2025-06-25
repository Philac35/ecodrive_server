

import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';



class EnvironmentLoader{

  String? environment;
  String? path;

EnvironmentLoader({this.environment,this.path}){
  if(this.environment==null){
  environment= Platform.environment['Env']!;}
}

 Future<Map<String, String>> loadBDD() async {
   final file = "${path ?? ''}ConfigurationBDD.$environment.env";
   await dotenv.load(fileName: file);
   return Map<String, String>.from(dotenv.env);
 }

  Future<Map<String, String>> loadEnv(String fileName) async {
   final prefix = (path != null && path!.isNotEmpty && !path!.endsWith('/')) ? "${path!}/" : (path ?? '');
   final file = "$prefix$fileName.$environment.env";
   await dotenv.load(fileName: file);
   return Map<String, String>.from(dotenv.env);
 }

}