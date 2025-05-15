import 'dart:ffi';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';

import '../../../Entities/Abstract/Person.dart';
import '../../../Entities/Interface/entityInterface.dart';



import './User.dart';
import './Employee.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Address.dart';
import 'Photo.dart';



@orm
@serializable
abstract class Administrator extends Person  implements EntityInterface{

  Administrator({ super.idInt,required super.firstname,required super.lastname,super.age,super.gender, super.address, super.photo, required super.authUser, super.createdAt}):super();

  bool  delete(Person person) {return false;}
  bool   suspend(Person person){return false;}
  pay(Float price){return price;}
  create(User user,Employee employee){}

 //factory contructor for creating new Administrator instance from a map

  //factory Administrator.fromJson(Map<String, dynamic> json) => _$AdministratorFromJson(json);

  //To Json
  Map<String, dynamic> toJson() ;
}



