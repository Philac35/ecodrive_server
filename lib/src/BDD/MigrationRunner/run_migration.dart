//import 'package:angel3_migration_runner/angel3_migration_runner.dart';
import 'package:angel3_migration_runner/mysql.dart';
import 'package:ecodrive_server/src/BDD/Migration/MigrationFK/AddAdministratorFKMigration.dart';
import 'package:ecodrive_server/src/BDD/Migration/MigrationFK/AddAsssuranceFKMigration.dart';
import 'package:ecodrive_server/src/BDD/Migration/MigrationFK/AddDriverFKMigration.dart';
import 'package:ecodrive_server/src/BDD/Migration/MigrationFK/AddPersonFKMigration.dart';

//import 'package:mysql_client/src/mysql_client/connection.dart';
import 'package:mysql_client/mysql_client.dart';
//import 'package:mysql1/mysql1.dart';


import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Abstract/Person.dart';

import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Address.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Administrator.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Assurance.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Driver.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/DrivingLicence.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Employee.dart';
import '../Migration/MigrationFK/AddAddressFKMigration.dart';
import '../Migration/MigrationFK/AddDrivingLicenceFKMigration.dart';
import '../Migration/MigrationFK/AddEmployeeFKMigration.dart';
import '../Migration/MigrationFK/AddItineraryFKMigration.dart';
import '../Migration/MigrationFK/AddNoticeFKMigration.dart';
import '../Migration/MigrationFK/AddPhotoFKMigration.dart';
import '../Migration/MigrationFK/AddTraveFKMigration.dart';
import '../Migration/MigrationFK/AddUserFKMigration.dart';
import '../Migration/MigrationFK/AddVehiculeFKMigration.dart';
import '../Migration/MigrationFK/Modules/Authentication/Entities/AddAuthUserFKMigration.dart';
import '../Model/AbstractModels/Itinerary.dart';
import '../Model/AbstractModels/Modules/Authentication/Entities/AuthUser.dart';
import '../Model/AbstractModels/Notice.dart';
import '../Model/AbstractModels/Photo.dart';
import '../Model/AbstractModels/Travel.dart';
import '../Model/AbstractModels/User.dart';
import '../Model/AbstractModels/Vehicule.dart';



void main() async {
  var mysqlConn;
  var    runner;
  try {
   mysqlConn = await MySQLConnection.createConnection(
        host: '127.0.0.1',
        port: 3306,
        userName: 'partocle',
        password: '|3Baumann5|',
        databaseName: 'ecodrive_development',
        secure:true
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

    AddPersonFKMigration(mysqlConn) ,  // Here we manage down(FK) that 's why i need connection. Schema doesn't manage drop of foreign Key. We need to set it with conventional mysl_client queries
    AddAuthUserFKMigration(),
    AddAddressFKMigration(),
    AddAdministratorFKMigration(),
    AddAssuranceFKMigration(),
    AddDriverFKMigration(),
    AddDrivingLicenceFKMigration(),
    AddEmployeeFKMigration(),
    AddItineraryFKMigration(),
    AddNoticeFKMigration(),
    AddPhotoFKMigration(),
    AddTravelFKMigration(),
    AddUserFKMigration(),
    AddVehiculeFKMigration(),
  ],
  );

  // Run the migrations
    try{
      await runner.up();
     // await runner.rollback();
      //await runner.reset();

      }catch(errorRunner){print("run_migration L82, Error Runner UP : ${errorRunner}");};
   print('Migrations completed successfully.');
  }catch(error, stack){
        print("Migrations failed");
        print('run_migration L35, error : ${error}');
        print('run_migration L32, Stack :${stack}');}
finally{
  runner.close();}

}
