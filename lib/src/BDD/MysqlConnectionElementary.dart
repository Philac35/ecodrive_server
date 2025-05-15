import 'package:angel3_orm_mysql/angel3_orm_mysql.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:logging/logging.dart';


/**
 * Class MysqlConnectionElementaty
 *  exemple de connection à mysql élémentaire
 */
class MysqlConnectionElementary{

late MySQLConnection connection ;
final _log= Logger('mysql_orm');

  Future<MySQLConnection>  createConnection() async {
    var connection = await MySQLConnection.createConnection(
        host: "localhost",
        port: 3306,
        databaseName: "orm_test",
        userName: "test",
        password: "test123",
        secure: true);
    return connection ;
  }

  execute()async {
//var logger = Logger('orm_mysql');
    await connection.connect(timeoutMs: 10000);
    var executor = MySqlExecutor(connection,logger: _log);

  }

}
