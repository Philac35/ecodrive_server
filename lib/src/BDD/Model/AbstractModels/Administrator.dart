import 'dart:ffi';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Modules/Authentication/Entities/AuthUser.dart';


import '../../../Entities/Interface/entityInterface.dart';
import '../FAngelModelQuery.dart';
import './Abstract/Person.dart';

import './Modules/Authentication/Entities/AuthUser.dart';
import './User.dart';
import './Employee.dart';


import 'Address.dart';
import 'Photo.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
import 'package:optional/optional.dart';
part 'Administrator.g.dart';

@orm
@serializable
abstract class Administrator extends Person  implements EntityInterface{

  @hasOne
  @override
  AuthUser? authUser;

  Administrator({ super.idInt,required super.firstname,required super.lastname,super.age,super.gender, super.address,  String? email,super.photo, required super.authUser, super.createdAt, DateTime? updatedAt}):super();

  bool  delete(Person person);
  bool   suspend(Person person);
  pay(Float price);
  create(User user,Employee employee){
    // TODO: implement create user and employee
    throw UnimplementedError();
  }

 //factory contructor for creating new Administrator instance from a map

  factory Administrator.fromJson(Map<String, dynamic> json)  {
    // TODO: implement factory
    throw UnimplementedError();
  }


  //To Json
  Map<String, dynamic> toJson() ;

}



