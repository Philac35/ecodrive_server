import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/Entities/Abstract/Person.dart';
import 'package:json_annotation/json_annotation.dart';

import './Modules/Authentication/Entities/AuthUser.dart';
import 'Address.dart';
 import '../../../Entities/Interface/entityInterface.dart';
import 'Photo.dart';




@orm
@serializable
@JsonSerializable(explicitToJson: true)
abstract class Employee extends Person  implements EntityInterface{
 
   Employee({ super.idInt,   required super.firstname,   required super.lastname,   super.age,   super.gender,   super.address,   super.email,   super.photo,   required super.authUser,   super.createdAt}):super();

//Serialization
 // factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);

//To Json
   Map<String, dynamic> toJson() ;
}
