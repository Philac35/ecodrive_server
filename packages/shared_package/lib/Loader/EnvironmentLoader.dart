

import 'package:dotenv/dotenv.dart';



class EnvironmentLoader{

  String? environment;  //dev, prod, test etc
  String? path;
  Map<String, String>? gnlconfiguration;


  EnvironmentLoader({this.environment,this.path}){
    if(environment==null){
      gnlConfigurationf();
    }
  }


 Map<String, String>? gnlConfigurationf() {
    try {
      String path='./packages/server_package/lib/Bin';
      String file='$path/ConfigurationServer.env';
     // print("EnvironmentLoader L26 debug : ${file}");
      var env = DotEnv(includePlatformEnvironment: true)
              ..load([file]);
      environment=env["Env"];
      //print("EnvironmentLoader L28 debug : ${environment}");
      return gnlconfiguration= env.map;

    }catch(e){print ('EnvironmentLoader L23, Could not load general configuration! error:$e');}
    return null;
  }

 Map<String, String>? loadBDD()  {
    gnlConfigurationf();
    //print("EnvironmentLoader L35 debug : ${environment}");
    final file = "${path ?? ''}/ConfigurationBDD.$environment.env";
    //print("EnvironmentLoader L40, debug, ConfigurationBDD File: ${file.toString()}");
    //print("EnvironmentLoader L41, debug, Current directory : ${Directory.current.path}");

    try {
   var env= DotEnv(includePlatformEnvironment: false)
      ..load([file.toString()]);

    return env.map;
    }catch(e){print ('EnvironmentLoader L23, Could not load BDD configuration! error:$e');}
    return null;

 }

  Future<Map<String, String>> loadEnv(String fileName) async {
    final prefix = (path != null && path!.isNotEmpty && !path!.endsWith('/')) ? "${path!}/" : (path ?? '');
    final file = "$prefix$fileName.$environment.env";
    var env = DotEnv(includePlatformEnvironment: true)
      ..load([file]);
      return env.map;
  }

}