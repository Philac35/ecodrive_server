import 'dart:io' as io;

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_orm_mysql/angel3_orm_mysql.dart';
import 'package:ecodrive_server/src/BDD/Interface/ConnectionInterface.dart';
import 'package:ecodrive_server/src/Loader/EnvironmentLoader.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:logging/logging.dart';
import 'package:universal_html/html.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:logging/logging.dart';



/*
Future<void> configureServer(Angel app) async {
  var connection = await connectToMysql(app.configuration);
  await connection.open();

  app
    ..container.registerSingleton<QueryExecutor>(MySqlExecutor(connection))
    ..shutdownHooks.add((_) => connection.close());
}*/


/**
 * Class MysqlConnection
 * cf limitation of Executor in SQLExecutor
 * 14/05/2025  Compatible Mysql 8.0+
 */
class MysqlConnection implements ConnectionInterface {
 

  late Map<String,String> configuration;
  late MySQLConnection connexion;
  late Logger _log = Logger('orm_mysql');

  MysqlConnection(){
    loadConfiguration();
  }

  loadConfiguration()async{
    EnvironmentLoader envl= EnvironmentLoader();
    configuration = await envl.loadBDD();

  }


  Future<dynamic> connect({int? timeoutMs}) async {
   configuration = await configuration;
   String password="", username="";
   try {
     String? pass, user;
    try{
        pass=io.Platform.environment['PASSWORD'];}catch(e1){throw("MysqlConnection L45 Platform env PASSWORD not set");}
    try{
        user=io.Platform.environment['USERNAME'] ;}catch(e2){throw("MysqlConnection L45 Platform env USERNAME not set");}

   if(isDesktop && pass!=null && user!=null){password=pass;username=user;} else{
             try{password=configuration['PASSWORD'] as String ;}catch(e3){throw("MysqlConnection L45 PASSWORD not set in ConfigurationBDD.env");}
             try{username=configuration['USERSNAME'] as String;}catch(e4){throw("MysqlConnection L45 PASSWORD not set in ConfigurationBDD.env");}
     }

     connexion = await MySQLConnection.createConnection(
         host: configuration['HOST'] as String ?? 'localhost',
         port: configuration['PORT'] as int ?? 3306,
         databaseName: configuration['DATABASE'] as String,
         userName: username,
         password: password,
         // timeZone: configuration['time_zone'] as String ?? 'UTC', // set in example but not suitable with this constructor
         // timeoutInSeconds: configuration['timeout_in_seconds'] as int ?? 30, // idem
         secure: configuration['USE_SSL'] as bool ?? false,
         //collation : 'utf8mb4_general_ci'  // not required
     ).timeout(Duration(milliseconds: timeoutMs ?? 30000));

   }catch(error){
     debugPrint("MysqlConnection L55, connect(), Error de connexion to Mysql : ${error}");
   }
    return connexion;
  }


  Logger get log=>_log;
  bool get isDesktop => UniversalPlatform.isWindows || UniversalPlatform.isLinux || UniversalPlatform.isMacOS;

}