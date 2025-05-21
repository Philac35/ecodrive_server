
import "dart:typed_data";

import "package:angel3_orm/angel3_orm.dart";
import "package:angel3_serialize/angel3_serialize.dart";

import "package:ecodrive_server/src/BDD/Model/AbstractModels/Vehicule.dart";
//import "package:ecodrive_server/src/Entities/User.dart";
import "package:optional/optional_internal.dart";


import '../../Interface/entityInterface.dart';
import "../FAngelModelQuery.dart";
import "./Modules/Authentication/Entities/AuthUser.dart";

import 'User.dart';
import "./DrivingLicence.dart";
import "./Notice.dart";
import "Address.dart" as abAdr;
import "Address.dart";
import "Photo.dart";

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
part 'Driver.g.dart';

@orm
@serializable
abstract class Driver extends User  implements EntityInterface{

  @hasMany
  List<Notice>? notices;

  List? preferences;

  @hasOne
  String? drivinglicense;  //will be stocked as Blob in BDD

  @hasOne
  Vehicule? vehicule;
  DrivingLicence? drivingLicence;



  Driver({ super.idInt,
    required super. firstname,
    required super. lastname,
    super.age,
    super. gender,
    super.address,
    super.email,
    super. photo,
    required super.authUser,
    super.createdAt,
    this.notices,
    this.preferences,
    this.drivingLicence,
    required this.vehicule,
    DateTime? updatedAt, required vehicule_id
     }):super() ;



  //Serialization
  factory Driver.fromJson(Map<String, dynamic> json)  {
    // TODO: implement factory
    throw UnimplementedError();
  }


  //To Json
  Map<String, dynamic> toJson();





}