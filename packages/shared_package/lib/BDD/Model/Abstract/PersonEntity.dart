
import "package:angel3_serialize/angel3_serialize.dart";
import "package:shared_package/BDD/Model/AbstractModels/AdministratorEntity.dart";
import "package:optional/optional_internal.dart";


import "../../Interface/entityInterface.dart";
import "../AbstractModels/AddressEntity.dart";
import "../AbstractModels/EmployeeEntity.dart";
import "../AbstractModels/Modules/Authentication/Entities/AuthUserEntity.dart";
import "../AbstractModels/PhotoEntity.dart";
import "../AbstractModels/UserEntity.dart";




//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';




part 'PersonEntity.g.dart';


@orm
@serializable
abstract class PersonEntity extends Model implements EntityInterface{

  @Column(length: 64)
  String? get firstname;
  @Column(length: 64)
  String? get lastname;
  int? get age;
  @Column(length: 8)
  String? get gender;

  double? get credits; //render app more evolutive != only user and admin has credits

  @HasOne(foreignTable:"Addresses", foreignKey: 'address_id')
  AddressEntity? get address;
  int? get addressId;


  @Column(length: 128)
  String? get email;


  @HasOne(foreignKey: 'photo_id', foreignTable:'photos')
  PhotoEntity? get photo;
  int? photoId;

  @HasOne(foreignTable:'auth_users',foreignKey: 'auth_users_id')
  AuthUserEntity? get authUser;
  int? authUserId;


  @HasOne(foreignTable: 'users', foreignKey: 'user_id')
  UserEntity? get user;
  int? userId;

  @HasOne(foreignTable: 'administrators', foreignKey: 'administrators_id')
  AdministratorEntity? get administrator;
  int? administratorId;

  @HasOne(foreignTable: 'employees', foreignKey: 'employees_id')
  EmployeeEntity? get employee;
  int? employeeId;

  //Person <=> authUser  : User, Administrator, Employee
  //User   : User, Driver

  //PersonEntity( {required this.firstname,required this.lastname, this.age,this.gender, this.address,this.email,this.photo,this.photo_id,required this.authUser});

}
