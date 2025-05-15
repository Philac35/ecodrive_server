

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../Abstract/FAngelModel.dart';


@orm
@serializable
abstract class AuthUser extends FAngelModel{
int? idInt;
String? identifiant;
String? password;
List<String>? role;

AuthUser({this.idInt,this.identifiant,this.password,this.role});


//Serialization
 // factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);

//To Json
  Map<String, dynamic> toJson() ;
}