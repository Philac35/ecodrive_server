


import 'package:angel3_migration_runner/angel3_migration_runner.dart';
import 'package:angel3_migration_runner/mysql.dart';

//import 'package:mysql1/mysql1.dart';
import 'package:shared_package/BDD/Connection/MysqlConnection.dart';
import 'package:shared_package/BDD/Model/Abstract/PersonEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/AddressEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/AdministratorEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/AssuranceEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/DriverEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/DrivingLicenceEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/EmployeeEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/ItineraryEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/Modules/Authentication/Entities/AuthUserEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/NoticeEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/PhotoEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/TravelEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/UserEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/VehiculeEntity.dart';


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