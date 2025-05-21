
import 'dart:convert';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Vehicule.dart';
import 'package:optional/optional_internal.dart';


import '../../../Services/Parser/Uint8ListJsonConverter.dart';
import '../Abstract/FAngelModel.dart';

import '../FAngelModelQuery.dart';
import 'Employee.dart';
import './User.dart';
import 'DrivingLicence.dart';


import '../../Interface/entityInterface.dart';
import 'dart:typed_data';
import './Abstract/Person.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
part 'Photo.g.dart';

@orm
@serializable
abstract class Photo extends FAngelModel  implements EntityInterface{
  int? idInt;
  String? title;
  String? uri;
  String? description;
  @Uint8ListJsonConverter()
  Uint8List? photo;

  @belongsTo
  Person? person;

 @belongsTo
 Vehicule? vehicule;

  @belongsTo
  DrivingLicence? drivingLicence;

  Photo({this.idInt,required this.title, this.uri, this.description, this.photo , this.person, this.vehicule, this.drivingLicence});
  //Serialization
  factory Photo.fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }

  //To Json
  Map<String, dynamic> toJson();
}
