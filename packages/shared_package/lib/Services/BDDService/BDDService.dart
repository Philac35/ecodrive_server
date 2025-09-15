import 'dart:developer';
import 'dart:math';
import 'package:mysql_client/mysql_client.dart';
import '../../BDD/Connection/MysqlConnection.dart';
import '../Interface/Service.dart';
import 'package:get_it/get_it.dart';


class BDDService implements Service{

  MySQLConnection? mySQLConnection; //Single connection, disconnected regularly
  MySQLConnectionPool? pool;
  MysqlConnection? connectionMysql;

 late GetIt getIt;
  BDDService(){
    getIt= GetIt.instance;
  }

  /**
   * Function initMySqlConnection
   * init a single MySQLConnection
   */
  void initMySqlConnection() async {
     connectionMysql= MysqlConnection();
   return  mySQLConnection=await connectionMysql?.connect();
  }

  /**
   * Function initMySqlPoolConnection()
   * init a MysqlConnectionPool
   */
  initMySqlPoolConnection()  {

    connectionMysql= MysqlConnection();
    pool = connectionMysql?.connectPool(timeoutMs: 240000);
    getIt.registerSingleton<MySQLConnectionPool>(pool!);
    return pool;
  }





  @override
  int getId() {
    var random = Random();
    int randomNumber = random.nextInt(10 ^ 15);
    return randomNumber;
  }

}