import 'package:angel3_migration_runner/angel3_migration_runner.dart';
import 'package:angel3_migration_runner/mysql.dart';
import 'package:angel3_migration/src/migration.dart';

import 'package:mysql1/mysql1.dart';
import 'package:ecodrive_server/src/BDD/Connection/MysqlConnection.dart';


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
import 'package:mysql_client/src/mysql_client/connection.dart';


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
deleteMigrations(Migration migration){
  migrations.remove(migration);
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
runMigrations() {
  migrationRunner.up();
}

/**
 * Function downMigrations
 * Undo last migration
 */
downMigrations(){
  migrationRunner.rollback();

}

deleteTables(){
  migrationRunner.reset();
}







}
