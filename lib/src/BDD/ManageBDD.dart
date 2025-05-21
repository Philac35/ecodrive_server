import 'dart:isolate';

import 'package:angel3_orm_mysql/angel3_orm_mysql.dart';
import 'package:ecodrive_server/src/BDD/Interface/ConnectionInterface.dart';
import 'package:ecodrive_server/src/BDD/Interface/ManageBDDInterface.dart';
import 'package:ecodrive_server/src/BDD/Connection/MysqlConnection.dart';
import 'package:ecodrive_server/src/BDD/Migration/migrationsRunner.dart';
//import 'package:flutter/foundation.dart';  Return errors about Material that are unrelated
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
    }catch(error, stack){print('ManageBDD L28, Query Execution : ${error} \r\n StackTrack ${stack}');}

  }

  runMigrations(){
    var mysqlMigration=MysqlMigration(this.connexion as MySQLConnection);
    try{
    mysqlMigration.runMigrations();
    }catch(error, stack){print('ManageBDD L35, Run Migration Error : ${error} \r\n StackTrack ${stack}');}
  }

/*
  void main() async {
    // This function will be run in an isolate
    Future<void> runm() async {
      try {
        final manageBDD = ManageBDD(connexion: MysqlConnection());
        await manageBDD.connect();
        await manageBDD.runMigrations();
        // Optionally, you can run queries here
        // await manageBDD.execute(tableName: "Driver", query: "SELECT * FROM driver");
        print('Migrations completed successfully.');
      } catch (e, stackTrace) {
        print('Migration failed: $e');
        print(stackTrace);
        // Optionally, rethrow or handle the error as needed
      }
    }

    // Run the function in a new isolate
    await Isolate.run(runm);
  }

*/
}

Future<void> runInIsolate() async {
  try {
    final manageBDD = ManageBDD(connexion: MysqlConnection());
    await manageBDD.connect();
    await manageBDD.runMigrations();
    print('Migrations completed successfully.');
  } catch (e, stackTrace) {
    print('Migration failed: $e');
    print(stackTrace);
  }
}

void main() async {
  print('Starting main...');
  await Isolate.run(runInIsolate);
  print('Main finished.');
}