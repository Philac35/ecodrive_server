import "package:angel3_serialize/angel3_serialize.dart";

import "../Address.dart";
import "../Photo.dart";
import "../../Modules/Authentication/Entities/AuthUser.dart";
import "../../BDD/Model/Abstract/FAngelModel.dart";

abstract class Person extends FAngelModel{

  int? idInt ;
  String? firstname;
  String? lastname;
  int? age;
  String? gender;
  Address? address;
  String? email;
  Photo? photo;
  AuthUser? authUser;
  DateTime? createdAt;

  Person({this.idInt,required this.firstname,required this.lastname, this.age,this.gender, this.address,this.email,this.photo,required this.authUser,this.createdAt}){}

}