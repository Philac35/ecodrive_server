
import "dart:typed_data";

import "package:angel3_orm/angel3_orm.dart";
import "package:angel3_serialize/angel3_serialize.dart";
import "package:ecodrive_server/src/Entities/User.dart";
import "package:json_annotation/json_annotation.dart";

import "../../../Entities/Interface/entityInterface.dart";
import "./Modules/Authentication/Entities/AuthUser.dart";
import "./Notice.dart";
import "Address.dart";

import "Photo.dart";



@orm
@serializable
abstract class Driver extends User  implements EntityInterface{

  Notice? notice;
  List? preferences;
  String? drivinglicense;  //will be stocked as Blob in BDD

  Driver(  {   super.idInt,   required super. firstname,   required super. lastname,  super.age,   super. gender,  super. address,   super.email,   super. photo,   required super.authUser,   super.createdAt,this.notice, this.preferences,this.drivinglicense }):super() ;





}

