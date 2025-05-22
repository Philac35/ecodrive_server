import 'package:angel3_migration_runner/angel3_migration_runner.dart';
import 'package:angel3_migration_runner/mysql.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Abstract/Person.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Address.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Administrator.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Assurance.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Driver.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/DrivingLicence.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Employee.dart';
import 'package:mysql_client/src/mysql_client/connection.dart';

import '../Model/AbstractModels/Itinerary.dart';
import '../Model/AbstractModels/Modules/Authentication/Entities/AuthUser.dart';
import '../Model/AbstractModels/Notice.dart';
import '../Model/AbstractModels/Photo.dart';
import '../Model/AbstractModels/Travel.dart';
import '../Model/AbstractModels/User.dart';
import '../Model/AbstractModels/Vehicule.dart';



void main() async {
  var mysqlConn;
  try {
   mysqlConn = await MySQLConnection.createConnection(
        host: '127.0.0.1',
        port: 3306,
        userName: 'partocle',
        password: '|3Baumann5|',
        databaseName: 'ecodrive_development',
        secure:false
   );

print('Connexion');
// Actually connect to the database
 var connected=   await mysqlConn.connect(); //

    //print(connected.toString());
    print('Write Instance of MysqlConnection : ');
    print(mysqlConn);
   // Optionally, test the connection
    print('');
   print("About to test connection...");
   try{
   var test = await mysqlConn.execute('SELECT 1');
   print("Query executed");
   if (test != null) {
     print("Connection is well established");
   } else {
     print("Query returned null");
     throw("Run Migration is not connected to the database!");

   }}catch(err){print ('run_migration L35, error :${err}');}



   // Initialize your migration runner
  final runner = MySqlMigrationRunner(
  mysqlConn,
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
    try{
      //await runner.up();
      await runner.reset();
      }catch(errorRunner){print("run_migration L82, Error Runner UP : ${errorRunner}");};
   print('Migrations completed successfully.');
  }catch(error, stack){
        print("Migrations failed");
        print('run_migration L35, error : ${error}');
        print('run_migration L32, Stack :${stack}');}

}
