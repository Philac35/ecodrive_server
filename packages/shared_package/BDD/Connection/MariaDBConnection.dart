import 'package:angel3_orm_mysql/angel3_orm_mysql.dart';
import 'package:mysql1/mysql1.dart';

import '../../Loader/EnvironmentLoader.dart';
import '../Interface/ConnectionInterface.dart';
import 'package:logging/logging.dart';



/**
 * Class MariaDBConnection
 * 14/05/2025  Compatible MariaDB 10.2+
 * cf Compatibility : https://pub.dev/packages/angel3_orm_mysql
 */
class MariaDBConnection implements ConnectionInterface{
  late ConnectionInterface connexion;
  late Map<String,String > configuration;
  final _log= Logger('orm_mariadb');
  MariaDBConnection();

  Future<dynamic> connect({int? timeoutMs}) async {

var settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    db: 'orm_test',
    user: 'test',
    password: 'test123');
    connexion = (await MySqlConnection.connect(settings)) as ConnectionInterface;

  var executor = MariaDbExecutor(connexion as MySqlConnection, logger: _log);

 }


  @override
  loadConfiguration()async{
    EnvironmentLoader envl= EnvironmentLoader();
    configuration = await envl.loadBDD();

  }

  @override
  // TODO: implement log
  get log => throw UnimplementedError();

}
