import 'package:angel3_migration_runner/angel3_migration_runner.dart';
import 'package:angel3_migration_runner/mysql.dart';
import 'package:angel3_migration/src/migration.dart';
import 'package:mysql_client/src/mysql_client/connection.dart';

import 'package:mysql1/mysql1.dart';
import 'package:ecodrive_server/src/BDD/Connection/MysqlConnection.dart';
import 'package:angel3_migration_runner/angel3_migration_runner.dart' as rm;

import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Abstract/Person.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Address.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Administrator.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Assurance.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Driver.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/DrivingLicence.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Employee.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Itinerary.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Modules/Authentication/Entities/AuthUser.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Notice.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Photo.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Travel.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/User.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Vehicule.dart';



class MysqlMigration{
late MySQLConnection mysqlConnection;
late MySqlMigrationRunner migrationRunner;
late List<Migration> migrations;


MysqlMigration(this.mysqlConnection);

MySqlMigrationRunner setMigrations(){
  migrations= [
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
  ];
   migrationRunner = MySqlMigrationRunner(
    mysqlConnection ,
    migrations:migrations
  );

  //  package:angel3_migration_runner/ src/ cli. dart Future<dynamic> runMigrations(MigrationRunner migrationRunner, List<String> args)  Type: Future<dynamic> Function(MigrationRunner, List<String>)

   return migrationRunner;
}

addMigrations(Migration migration){
  migrations.add(migration);

}

/**
 * Function deleteMigrations
 * @Param Migration migration
 * Delete a migration from List migrations
 */
bool deleteMigrations(Migration migration)  {
var res;
  try {
     res= migrations.remove(migration);
    print('Migrations remove successfully.');
  } catch (e, stackTrace) {

    print('Migration failed: $e');
    print('Stack trace: $stackTrace');
    res=false;
    // Optionally, rethrow or handle specific error types
  }
  return res;
}

/**
 * Function deleteAllMigrations
 * Delete all migration from List migration
 */
deleteAllMigrations(){
  migrations=[];

}

/**
 * Function runMigrations
*/
runMigrations() async {
  try {

    List<String> args=[];
    rm.runMigrations(migrationRunner,args);

   // await migrationRunner.up();
    print('Migrations ran successfully.');
  } catch (e, stackTrace) {

    print('Migration failed: $e');
    print('Stack trace: $stackTrace');
    // Optionally, rethrow or handle specific error types
  }

}


/**
 * Function downMigrations
 * Undo last migration
 */
downMigrations() async {

  try {
    await migrationRunner.rollback();
    print('Migrations rollback successfully.');
  } catch (e, stackTrace) {

    print('Migration failed: $e');
    print('Stack trace: $stackTrace');
    // Optionally, rethrow or handle specific error types
  }
}

deleteTables() async {

  try {
    await   migrationRunner.reset();
    print('Migrations reset successfully.');
  } catch (e, stackTrace) {

    print('Migration failed: $e');
    print('Stack trace: $stackTrace');
    // Optionally, rethrow or handle specific error types
  }
}







}
