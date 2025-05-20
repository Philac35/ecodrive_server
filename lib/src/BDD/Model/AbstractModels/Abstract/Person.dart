
import "package:angel3_serialize/angel3_serialize.dart";
import "package:optional/optional_internal.dart";

import "../../ConcreteModel/PersonModel.dart";
import "../../FAngelModelQuery.dart";
import "../Address.dart";
import "../Photo.dart";

import "../../Abstract/FAngelModel.dart";
import "../Modules/Authentication/Entities/AuthUser.dart";

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';


part 'Person.g.dart';


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

  @override
  DateTime? createdAt;

  @override
  String? id;

  Person({this.idInt,required this.firstname,required this.lastname, this.age,this.gender, this.address,this.email,this.photo,required this.authUser,this.createdAt, DateTime? updatedAt, this.id});

}