


import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:optional/optional_internal.dart';


import '../../Interface/entityInterface.dart';
import '../Abstract/PersonEntity.dart';



import 'Modules/Authentication/Entities/AuthUserEntity.dart';
import 'UserEntity.dart';
import 'EmployeeEntity.dart';


import 'PhotoEntity.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:optional/optional.dart';

part 'AdministratorEntity.g.dart';




@Orm(generateMigrations:true)
@serializable
abstract class AdministratorEntity extends PersonEntity  implements EntityInterface{




  @BelongsTo()
  PersonEntity? get person;

  @HasOne(foreignTable:'auth_users',foreignKey: 'auth_users_id')
  @override
  AuthUserEntity? get authUserEntity ;


  bool  delete(PersonEntity  person);
  bool   suspend(PersonEntity  person);
  pay(double price);
  create(UserEntity  user,EmployeeEntity  employee){
    // TODO: implement create user and employee
    throw UnimplementedError();
  }

 /*factory contructor for creating new Administrator instance from a map

  factory AdministratorEntity .fromJson(Map<String, dynamic> json)  {
    // TODO: implement factory
    throw UnimplementedError();
  }*/


  //To Json
  @override
  Map<String, dynamic> toJson() ;

}



