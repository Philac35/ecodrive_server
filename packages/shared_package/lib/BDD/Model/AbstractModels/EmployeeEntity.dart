import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:optional/optional_internal.dart';

import 'AdministratorEntity.dart';
import 'Modules/Authentication/Entities/AuthUserEntity.dart';

import '../../Interface/entityInterface.dart';
import '../Abstract/PersonEntity.dart';
import 'PhotoEntity.dart';


//Import migration system
import 'package:angel3_migration/angel3_migration.dart';

import 'UserEntity.dart';


part 'EmployeeEntity.g.dart';



@Orm(generateMigrations:true)
@serializable
abstract class EmployeeEntity extends PersonEntity   implements EntityInterface{

   @BelongsTo()
   PersonEntity get person;
   //EmployeeEntity ({ super.idInt,   required super.firstname,   required super.lastname,   super.age,   super.gender,   super.address,   super.email,   super.photo,   required super.authUser,   super.createdAt, super. updatedAt}):super();

/*Serialization
 factory EmployeeEntity .fromJson(Map<String, dynamic> json){
   // TODO: implement factory
   throw UnimplementedError();
 }*/

//To Json
   @override
  Map<String, dynamic> toJson() ;




}
