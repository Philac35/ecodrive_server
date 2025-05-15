
import "dart:typed_data";

import "package:angel3_orm/angel3_orm.dart";
import "package:angel3_serialize/angel3_serialize.dart";
import "package:ecodrive_server/src/Entities/User.dart";
import "package:json_annotation/json_annotation.dart";

import "../Modules/Authentication/Entities/AuthUser.dart";
import "./Notice.dart";
import "Address.dart";
import "Interface/entityInterface.dart";
import "Photo.dart";
part 'Driver.g.dart';


@orm
@serializable
@JsonSerializable(explicitToJson: true)
class Driver extends User  implements EntityInterface{

  Notice? notice;
  List? preferences;
  String? drivinglicense;  //will be stocked as Blob in BDD

  Driver(  {   super.idInt,   required super. firstname,   required super. lastname,  super.age,   super. gender,  super. address,   super.email,   super. photo,   required super.authUser,   super.createdAt,this.notice, this.preferences,this.drivinglicense }):super() ;

  static Driver create(Map<String, dynamic> parameters) {
    return Driver(firstname: parameters['firstname'], lastname:parameters['lastname'],  age: parameters['age'], gender: parameters['gender'],address: parameters['address'],email: parameters['email'],photo:parameters['photo'],authUser: parameters['authUser'],createdAt: parameters['createdAt'],preferences: parameters['preferences'],drivinglicense: parameters['drivinglicense'] );
  }


  //Serialization
  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);

  //To Json
  Map<String, dynamic> toJson() => _$DriverToJson(this);



}

