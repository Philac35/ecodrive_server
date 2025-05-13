import "../Address.dart";
import "../Photo.dart";
import "../../Modules/Authentication/Entities/AuthUser.dart";

abstract class Person{

  int? id ;
  String? firstname;
  String? lastname;
  int? age;
  String? gender;
  Address? address;
  String? email;
  Photo? photo;
  AuthUser? authUser;
  DateTime? createdAt;

  Person({this.id,required this.firstname,required this.lastname, this.age,this.gender, this.address,this.email,this.photo,required this.authUser,this.createdAt}){}

}