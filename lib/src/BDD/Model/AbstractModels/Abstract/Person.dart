import "package:angel3_orm/angel3_orm.dart";
import "package:angel3_serialize/angel3_serialize.dart";

import "../Address.dart";
import "../Photo.dart";

import "../../Abstract/FAngelModel.dart";
import "../Modules/Authentication/Entities/AuthUser.dart";

@orm
@serializable
abstract class Person extends FAngelModel{

  int? idInt ;
  String? firstname;
  String? lastname;
  int? age;
  String? gender;

  @hasOne
  Address? address;

  String? email;

  @hasOne
  Photo? photo;

  @hasOne
  AuthUser? authUser;

  DateTime? createdAt;

  Person({this.idInt,required this.firstname,required this.lastname, this.age,this.gender, this.address,this.email,this.photo,required this.authUser,this.createdAt}){}

}