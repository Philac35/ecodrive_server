

import 'package:json_annotation/json_annotation.dart';
part 'AuthUser.g.dart';

@JsonSerializable()
class AuthUser{
int? id;
String? identifiant;
String? password;
List<String>? role;

AuthUser({this.id,this.identifiant,this.password,this.role});


//Serialization
  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);

//To Json
  Map<String, dynamic> toJson() => _$AuthUserToJson(this);
}