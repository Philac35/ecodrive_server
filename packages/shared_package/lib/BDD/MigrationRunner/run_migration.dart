//import 'package:angel3_migration_runner/angel3_migration_runner.dart';
import 'package:angel3_migration_runner/mysql.dart';

//import 'package:mysql1/mysql1.dart';

import 'package:shared_package/BDD/Model/Abstract/PersonEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/AddressEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/AdministratorEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/AssuranceEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/DriverEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/DrivingLicenceEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/EmployeeEntity.dart';
//import 'package:mysql_client/src/mysql_client/connection.dart';
import 'package:mysql_client/mysql_client.dart';


import '../Model/AbstractModels/ItineraryEntity.dart';
import '../Model/AbstractModels/Modules/Authentication/Entities/AuthUserEntity.dart';
import '../Model/AbstractModels/NoticeEntity.dart';
import '../Model/AbstractModels/PhotoEntity.dart';
import '../Model/AbstractModels/TravelEntity.dart';
import '../Model/AbstractModels/UserEntity.dart';
import '../Model/AbstractModels/VehiculeEntity.dart';

void main() async {
  MySQLConnection mysqlConn;
  MySqlMigrationRunner runner;
  try {
    mysqlConn = await MySQLConnection.createConnection(
        host: '127.0.0.1',
        port: 3306,
        userName: 'partocle',
        password: '|3Baumann5|',
        databaseName: 'ecodrive_development',
        secure: false);

    print('Connexion');
// Actually connect to the database
    var connected = await mysqlConn.connect(); //

    //print(connected.toString());
    print('Write Instance of MysqlConnection : ');
    print(mysqlConn);
    // Optionally, test the connection
    print('');
    print("About to test connection...");
    try {
      var test = await mysqlConn.execute('SELECT 1');
      print("Query executed");
      print("Connection is well established");
        } catch (err) {
      print('run_migration L35, error :$err');
    }

    // Initialize your migration runner
    runner = MySqlMigrationRunner(
      mysqlConn,
      //Caution to the order, FK must be set after the creation of Tables
      //FK are set with alter queries. (We could do it directly in Entity migration if you want to have fun with ordered the classes.
      migrations: [
        PersonMigration(),
        AuthUserMigration(),
        AddressMigration(),
        AdministratorMigration(),
        AssuranceMigration(),
        DriverMigration(),
        DrivingLicenceMigration(),
        EmployeeMigration(),
        ItineraryMigration(),
        NoticeMigration(),
        PhotoMigration(),
        TravelMigration(),
        UserMigration(),
        VehiculeMigration(),

         ],
    );

    // Run the migrations
    try {
      await runner.up();
      // await runner.rollback();
      //await runner.reset();
    } catch (errorRunner) {
      print("run_migration L82, Error Runner UP : $errorRunner");
    }
    print('Migrations completed successfully.');
  } catch (error, stack) {
    print("Migrations failed");
    print('run_migration L35, error : $error');
    print('run_migration L32, Stack :$stack');
  } finally {
    runner.close();
  }
}
