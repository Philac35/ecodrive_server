import 'package:angel3_migration_runner/angel3_migration_runner.dart';
import 'package:angel3_migration_runner/mysql.dart';
import 'package:angel3_migration/src/migration.dart';
import 'package:mysql_client/src/mysql_client/connection.dart';

import 'package:mysql1/mysql1.dart';
import 'package:ecodrive_server/src/BDD/Connection/MysqlConnection.dart';
import 'package:angel3_migration_runner/angel3_migration_runner.dart' as rm;

import 'package:ecodrive_server/src/BDD/Model/Abstract/PersonEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/AddressEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/AdministratorEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/AssuranceEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/DriverEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/DrivingLicenceEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/EmployeeEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/ItineraryEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Modules/Authentication/Entities/AuthUserEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/NoticeEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/PhotoEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/TravelEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/UserEntity.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/VehiculeEntity.dart';



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
