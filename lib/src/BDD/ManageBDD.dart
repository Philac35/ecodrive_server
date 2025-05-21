import 'package:angel3_orm_mysql/angel3_orm_mysql.dart';
import 'package:ecodrive_server/src/BDD/Interface/ConnectionInterface.dart';
import 'package:ecodrive_server/src/BDD/Interface/ManageBDDInterface.dart';
import 'package:ecodrive_server/src/BDD/Connection/MysqlConnection.dart';
import 'package:ecodrive_server/src/BDD/Migration/migrationsRunner.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysql_client/src/mysql_client/connection.dart';

import 'package:logging/logging.dart';

class ManageBDD implements ManageBDDInterface{

  ConnectionInterface? connexion;
 late  var _log = Logger('orm_mysql');


  ManageBDD({this.connexion});

  connect()async{
    await connexion?.connect(timeoutMs: 10000);
  }


  @override
  execute({required String tableName,required String query,  Map<String, dynamic>? substitutionValues} )async {
    try{
    var executor = MySqlExecutor(connexion as MySQLConnection,logger: connexion?.log);
    Future<List<List<dynamic>>> res= executor.query(tableName, query, substitutionValues! );
    executor.parseSQLResult(res as IResultSet);
    }catch(error, stack){debugPrint('ManageBDD L28, Query Execution : ${error} \r\n StackTrack ${stack}');}

  }

  runMigrations(){
    var mysqlMigration=MysqlMigration(this.connexion as MySQLConnection);
    try{
    mysqlMigration.runMigrations();
    }catch(error, stack){debugPrint('ManageBDD L35, Run Migration Error : ${error} \r\n StackTrack ${stack}');}
  }


static Future<void> main() async {
  var  manageBDD= ManageBDD(connexion: MysqlConnection());
   await manageBDD.connect();
  await manageBDD.runMigrations();
  // manageBDD.execute(tableName:"Driver",query: "Select * from driver");

}

}


