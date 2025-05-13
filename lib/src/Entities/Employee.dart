import 'package:ecodrive_server/src/Entities/Abstract/Person.dart';
import 'package:json_annotation/json_annotation.dart';

import '../Modules/Authentication/Entities/AuthUser.dart';
import 'Address.dart';
import 'Interface/entityInterface.dart';
import 'Photo.dart';

part 'Employee.g.dart';

@JsonSerializable(explicitToJson: true)
class Employee extends Person  implements EntityInterface{

   Employee({ super.id,   required super.firstname,   required super.lastname,   super.age,   super.gender,   super.address,   super.email,   super.photo,   required super.authUser,   super.createdAt}):super();

//Serialization
   factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);

//To Json
   Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
