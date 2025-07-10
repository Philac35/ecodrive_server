

import 'dart:convert';
import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:optional/optional_internal.dart';

import 'package:shared_package/Services/Parser/Uint8ListJsonConverter.dart';

import 'DrivingLicenceEntity.dart';
import '../../Interface/entityInterface.dart';
import 'dart:typed_data';
import '../Abstract/PersonEntity.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';


import 'VehiculeEntity.dart';


part 'PhotoEntity.g.dart';



@Orm(tableName:'photos',generateMigrations:true)
@serializable
abstract class PhotoEntity extends Model  implements EntityInterface{
  @Column(length: 64)
  String? get  title;
  @Column(length: 128)
  String? get  uri;
  @Column(length: 256)
  String? get  description;

  @Uint8ListJsonConverter()
  Uint8List? get  photo;



  @BelongsTo()
  PersonEntity?  get person;


  @BelongsTo()
  VehiculeEntity ? get vehicule;


  @BelongsTo()
  DrivingLicenceEntity ? get drivingLicence;

 //PhotoEntity ({this.title,this.uri,this.description,this.photo, this.person_id, this.person,this.vehicule_id, this.vehicule, this.driving_licence_id,this.drivingLicence, String? id});

  /*Serialization
  factory PhotoEntity .fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }*/

  //To Json
  @override
  Map<String, dynamic> toJson();
}
