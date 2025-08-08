import 'dart:convert';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:shared_package/BDD/Model/AbstractModels/DriverEntity.dart';
import 'package:optional/optional_internal.dart';

import '../../../Library/StringLibrary/string_librairy.dart';
import '../../ORM/ORMExtension/SymbolToStringConverter.dart';
import '../Abstract/PersonEntity.dart';


import '../../Interface/entityInterface.dart';

import 'AddressEntity.dart';
import 'AdministratorEntity.dart';
import 'CommandEntity.dart';
import 'EmployeeEntity.dart';
import 'Modules/Authentication/Entities/AuthUserEntity.dart';
import 'PhotoEntity.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';


part 'UserEntity.g.dart';



@Orm(tableName:'users',generateMigrations:true)
@serializable
abstract class UserEntity extends PersonEntity   implements EntityInterface{
  UserEntity() ;


//required super.firstname,   required super.lastname,   super.age,   super.gender,   super.address,   super.email,   super.photo,super.photo_id,   required super.authUser, super.createdAt




  @BelongsTo()
  PersonEntity? get person;
  int? get personId;


  @HasOne(foreignTable:'drivers',foreignKey: 'driver_id' )
  DriverEntity? get driver;
  int? get driverId;

  @HasMany(foreignKey:'command_id', foreignTable:'commands')
  List<CommandEntity>? get commandList;

  List<int>? get commandIdList; //cf if  fonctionnal

  /*
 static    UserEntity  create(Map<String, dynamic> parameters) {
   // TODO: implement create
   throw UnimplementedError();
 }
//Serialization
  factory UserEntity .fromJson(Map<String, dynamic> json)  {
        // TODO: implement factory
           throw UnimplementedError();
}

     //To Json
     Map<String, dynamic> toJson();
  */


  /*@override
  @HasOne(foreignTable: 'auth_users',foreignKey: 'auth_user_id')
  AuthUserEntity? get authUserEntity ; //-> must be fetch with person
 */
}

