import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/Entities/Abstract/Person.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../Entities/Interface/entityInterface.dart';

import 'Address.dart';
import 'Photo.dart';





@orm
@serializable
abstract class User extends Person  implements EntityInterface{


  @hasOne
  @override
   Photo? photo;



  User({super.idInt,   required super.firstname,   required super.lastname,   super.age,   super.gender,   super.address,   super.email,   super.photo,   required super.authUser, super.createdAt}):super();


  static User create(Map<String, dynamic> parameters);

//Serialization
  //factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

//To Json
  Map<String, dynamic> toJson();


  @override
  get authUser {return super.authUser;}
}

