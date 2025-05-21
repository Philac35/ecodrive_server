import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Modules/Authentication/Entities/AuthUser.dart';
import 'package:optional/optional_internal.dart';
import '../FAngelModelQuery.dart';
import './Abstract/Person.dart';


import '../../Interface/entityInterface.dart';

import 'Address.dart';
import 'Photo.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
part 'User.g.dart';


@orm
@serializable
abstract class User extends Person  implements EntityInterface{


  User({super.idInt,   required super.firstname,   required super.lastname,   super.age,   super.gender,   super.address,   super.email,   super.photo,   required super.authUser, super.createdAt}):super();



 static    User create(Map<String, dynamic> parameters) {
   // TODO: implement create
   throw UnimplementedError();
 }
//Serialization
  factory User.fromJson(Map<String, dynamic> json)  {
        // TODO: implement factory
           throw UnimplementedError();
}

//To Json
  Map<String, dynamic> toJson();


  @override
  get authUser {return super.authUser;}
}

