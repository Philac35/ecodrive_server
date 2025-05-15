import 'package:angel3_orm_mysql/angel3_orm_mysql.dart';
import 'package:ecodrive_server/src/BDD/Interface/ConnectionInterface.dart';
import 'package:ecodrive_server/src/BDD/Interface/ManageBDDInterface.dart';
import 'package:ecodrive_server/src/BDD/MysqlConnection.dart';
import 'package:mysql_client/src/mysql_client/connection.dart';

import 'package:logging/logging.dart';

class ManageBDD implements ManageBDDInterface{

  ConnectionInterface connexion;
 late  var _log = Logger('orm_mysql');
  ManageBDD({required this.connexion});

  connect()async{
    await connexion.connect(timeoutMs: 10000);
  }


  @override
  execute({required String tableName,required String query,  Map<String, dynamic>? substitutionValues} )async {

    var executor = MySqlExecutor(connexion as MySQLConnection,logger: connexion.log);
    Future<List<List<dynamic>>> res= executor.query(tableName, query, substitutionValues! );
    executor.parseSQLResult(res as IResultSet);

  }




main(){
  ManageBDD manageBDD= ManageBDD(connexion: MysqlConnection());
  manageBDD.execute(tableName:"Driver",query: "Select * from driver");

}

}