import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import './Modules/Authentication/Entities/AuthUser.dart';

 import '../../../Entities/Interface/entityInterface.dart';
import './Abstract/Person.dart';
import 'Address.dart';
import 'Photo.dart';




@orm
@serializable
abstract class Employee extends Person  implements EntityInterface{


   Employee({ super.idInt,   required super.firstname,   required super.lastname,   super.age,   super.gender,   super.address,   super.email,   super.photo,   required super.authUser,   super.createdAt}):super();

//Serialization
 factory Employee.fromJson(Map<String, dynamic> json){
   // TODO: implement factory
   throw UnimplementedError();
 }

//To Json
   Map<String, dynamic> toJson() ;
}
