

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../Abstract/FAngelModel.dart';
import '../../../Abstract/Person.dart';


@orm
@serializable
abstract class AuthUser extends FAngelModel{
int? idInt;
String? identifiant;
String? password;
List<String>? role;


@belongsTo
Person? person;

AuthUser({this.idInt,this.identifiant,this.password,this.role, this.person});


//Serialization
  factory AuthUser.fromJson(Map<String, dynamic> json)  {
    // TODO: implement factory
    throw UnimplementedError();
  }

//To Json
  Map<String, dynamic> toJson() ;
}