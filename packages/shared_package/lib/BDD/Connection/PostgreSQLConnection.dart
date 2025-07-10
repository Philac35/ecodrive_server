import 'dart:io' as io;

import 'package:postgres/postgres.dart';

import 'package:shared_package/Loader/EnvironmentLoader.dart';
import '../Interface/ConnectionInterface.dart';
//import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:logging/logging.dart';


/*
If you use Angel 3 server_package
Future<void> configureServer(Angel app) async {
  var connection = await connectToPostgres(app.configuration);
  await connection.open();

  app
    ..container.registerSingleton<QueryExecutor>(PostgreSQLExecutor(connection))
    ..shutdownHooks.add((_) => connection.close());
}
*/

class PostgreSQLConnection implements ConnectionInterface{

  @override
  late Future<Connection> connexion;
  late Map<String,String> configuration;
  late final Logger _log = Logger('orm_postgresql');
  MysqlConnection(){
    loadConfiguration();
  }

  @override
  loadConfiguration(){
    EnvironmentLoader envl= EnvironmentLoader();
    configuration =  envl.loadBDD()!;
  }

  /// Function connect
  /// @Param int timeoutMs : temps de connexion maximal
  /// Version > 3.X

@override
  Future<Connection> connect({int? timeoutMs}) async {
  var postgresConfig = configuration['postgres'] as Map ?? {};
  String password="", username="";
  try {
    String? pass, user;
    try{
      pass=io.Platform.environment['PASSWORD'];}catch(e1){throw("MysqlConnection L45 Platform env PASSWORD not set");}
    try{
      user=io.Platform.environment['USERNAME'] ;}catch(e2){throw("MysqlConnection L45 Platform env USERNAME not set");}

    if(isDesktop && pass!=null && user!=null){password=pass;username=user;} else{
      try{password=configuration['PASSWORD'] as String ;}catch(e3){throw("PostgreSQLConnection L57 PASSWORD not set in ConfigurationBDD.env");}
      try{username=configuration['USERSNAME'] as String;}catch(e4){throw("PostgresSQLConnection L58 PASSWORD not set in ConfigurationBDD.env");}
    }

     connexion = Connection.open(
      Endpoint(host:postgresConfig['host'] as String ?? 'localhost',
          port :postgresConfig['port'] as int ?? 5432,
          database:postgresConfig['database_name'] as String,
          username: postgresConfig['username'] as String,
          password: postgresConfig['password'] as String,
          isUnixSocket: false,
      )).timeout(Duration(milliseconds: timeoutMs ?? 30000));

  }catch(error){
    print("MysqlConnection L55, connect(), Error de connexion to Mysql : $error");
  }
  // Previous method < postgre3.x
  /*var connection = PostgreSQLConnection(
      postgresConfig['host'] as String ?? 'localhost',
      postgresConfig['port'] as int ?? 5432,
      postgresConfig['database_name'] as String ??
          Platform.environment['USER'] ??
          Platform.environment['USERNAME'],
      username: postgresConfig['username'] as String,
      password: postgresConfig['password'] as String,
      timeZone: postgresConfig['time_zone'] as String ?? 'UTC',
      timeoutInSeconds: postgresConfig['timeout_in_seconds'] as int ?? 30,
      useSSL: postgresConfig['use_ssl'] as bool ?? false);*/
  return connexion;

}


  @override
  Logger get log=>_log;
  bool get isDesktop => UniversalPlatform.isWindows || UniversalPlatform.isLinux || UniversalPlatform.isMacOS;

}
