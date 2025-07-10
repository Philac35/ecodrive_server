
import "dart:convert";
import "dart:typed_data";

import "package:angel3_orm/angel3_orm.dart";
import "package:angel3_serialize/angel3_serialize.dart";


//import "package:ecodrive_server/src/Entities/UserEntity.dart";
import "package:optional/optional_internal.dart";


import '../../Interface/entityInterface.dart';


import "AdministratorEntity.dart";
import "CommandEntity.dart";
import "EmployeeEntity.dart";
import "Modules/Authentication/Entities/AuthUserEntity.dart";
import "ORMExtension/ForeignTableSqlExpressionBuilder.dart";
import 'UserEntity.dart';
import "DrivingLicenceEntity.dart";
import "NoticeEntity.dart";
import "AddressEntity.dart" as abAdr;
import "AddressEntity.dart";
import "PhotoEntity.dart";
import "VehiculeEntity.dart";
import '../Abstract/PersonEntity.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';



part 'DriverEntity.g.dart';

@Orm(generateMigrations:true)
@serializable
abstract class DriverEntity extends UserEntity   implements EntityInterface{



  @hasMany
  List<NoticeEntity >? get notices;

  List<String>? get preferences;

  @BelongsTo()
  UserEntity get user;

  @HasOne(foreignTable: 'driving_licences', foreignKey: 'driving_licences_id' )
  DrivingLicenceEntity? get drivingLicence; //will be stocked as Blob in BDD

  @HasOne(foreignTable: 'vehicules',foreignKey: 'vehicule_id')
  VehiculeEntity ? get vehicule;


/*
  DriverEntity({
    this.notices,
    this.preferences,
    this.drivingLicence,
    required this.vehicule,
     }):super() ;
*/

  /*Serialization
  factory DriverEntity.fromJson(Map<String, dynamic> json)  {
    // TODO: implement factory
    throw UnimplementedError();
  }*/


  //To Json
  Map<String, dynamic> toJson();





}
