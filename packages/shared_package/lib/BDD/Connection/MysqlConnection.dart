import 'dart:async';

import 'package:shared_package/BDD/Interface/ConnectionInterface.dart';
import 'package:shared_package/Loader/EnvironmentLoader.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:logging/logging.dart';

import 'package:universal_platform/universal_platform.dart';



/*
Future<void> configureServer(Angel app) async {
  var connection = await connectToMysql(app.configuration);
  await connection.open();

  app
    ..container.registerSingleton<QueryExecutor>(MySqlExecutor(connection))
    ..shutdownHooks.add((_) => connection.close());
}*/


/// Class MysqlConnection
/// cf limitation of Executor in SQLExecutor
/// 14/05/2025  Compatible Mysql 8.0+
class MysqlConnection implements ConnectionInterface {

  late Map<String,String> configuration={};
  @override
   MySQLConnection? connexion;
   MySQLConnectionPool? connexionPool;

  late final Logger _log = Logger('orm_mysql');
  late String path;
  EnvironmentLoader? envloader;

  MysqlConnection(){
    loadConfiguration();
  }

  @override
  loadConfiguration(){
      envloader= EnvironmentLoader(
              path:'./packages/shared_package/lib/Configuration/Bdd'
    );
    Map<String, String>? gnlConf=envloader?.gnlConfigurationf();
      envloader?.environment=gnlConf?["env"];
  try {

    configuration =envloader!.loadBDD()!;

  }catch(e){print("MysqlConnection L47, error $e");}
 }

  @override
  Future<dynamic> connect({int? timeoutMs}) async {
  // configuration = await configuration;
   try {

     connexion = await MySQLConnection.createConnection(
         host: configuration['HOST'] as String ?? 'localhost',
         port: int.parse(configuration['PORT']!) ?? 3306,
         databaseName: configuration['DATABASE'] as String,
         userName: configuration['USERNAME'] as String,
         password: configuration['PASSWORD'] as String,
         // timeZone: configuration['time_zone'] as String ?? 'UTC', // set in example but not suitable with this constructor
         // timeoutInSeconds: configuration['timeout_in_seconds'] as int ?? 30, // idem
         secure: bool.parse(configuration['USE_SSL']!)  ?? false,
         //collation : 'utf8mb4_general_ci'  // not required
     ).timeout(Duration(milliseconds: timeoutMs ?? 60000));

    // print('MysqlConnection L85 ${connexion}');
     return connexion;
   }catch(error){
     print("MysqlConnection L86, connect(), Error de connexion to Mysql : $error");
   }

  }

  Future<dynamic> connectraw({int? timeoutMs}) async {
  try {

      connexion = (await MySQLConnection.createConnection(
          host: '127.0.0.1',
          port: 3306,
          userName: '',
          password: '',
          databaseName: '',
          secure: false).timeout(Duration(milliseconds: timeoutMs ?? 30000)));


// Actually connect to the database
   await connexion?.connect(); //return void

  }catch(error){
    print("MysqlConnection L55, connect(), Error de connexion to Mysql : $error");
  }
  return connexion;
  }


  @override
  MySQLConnectionPool? connectPool({int? timeoutMs}) {

    try {

      connexionPool =  MySQLConnectionPool(
        host: configuration['HOST'] as String ?? 'localhost',
        port: int.parse(configuration['PORT']!) ?? 3306,
        databaseName: configuration['DATABASE'] as String,
        userName: configuration['USERNAME'] as String,
        password: configuration['PASSWORD'] as String,
        // timeZone: configuration['time_zone'] as String ?? 'UTC', // set in example but not suitable with this constructor
        // timeoutInSeconds: configuration['timeout_in_seconds'] as int ?? 30, // idem
        secure: bool.parse(configuration['USE_SSL']!)  ?? false,
        maxConnections: 10,
        timeoutMs : timeoutMs?? 10000,

        //collation : 'utf8mb4_general_ci'  // not required
      );

      // print('MysqlConnection L85 ${connexion}');
      return connexionPool;
    }catch(error){
      print("MysqlConnection L86, connect(), Error de connexion to Mysql : $error");
    }

  }

  @override
  Logger get log=>_log;
  bool get isDesktop => UniversalPlatform.isWindows || UniversalPlatform.isLinux || UniversalPlatform.isMacOS;

}