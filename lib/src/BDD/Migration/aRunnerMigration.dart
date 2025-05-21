


import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_migration_runner/angel3_migration_runner.dart';
import 'package:angel3_migration_runner/mysql.dart';
import 'package:mysql_client/mysql_client.dart';

//import 'package:mysql1/mysql1.dart';
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


Future<void> runM() async {
  List<String> args = [];
  try {
    // Establish the connection
    final mysqlConn = await MysqlConnection().connect(timeoutMs: 10000);

    // Set up the migration runner
    final migrationRunner = MySqlMigrationRunner(
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
    await runMigrations(migrationRunner, args);
    print('Migrations completed successfully.');
  } catch (e, stack) {
    print('Error running migrations: $e\n$stack');
  }
}

Future<void> main() async {
  await runM();
}