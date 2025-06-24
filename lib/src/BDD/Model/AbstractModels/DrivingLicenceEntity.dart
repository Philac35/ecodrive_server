

import 'dart:convert';
import 'dart:typed_data';




import 'package:optional/optional_internal.dart';

import '../Abstract/PersonEntity.dart';
import 'Interface/DocumentInterface.dart';
import 'DriverEntity.dart';
import 'ORMExtension/ForeignTableSqlExpressionBuilder.dart';
import 'PhotoEntity.dart';
import 'VehiculeEntity.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';



part 'DrivingLicenceEntity.g.dart';


@Orm(generateMigrations:true)
@serializable
abstract class DrivingLicenceEntity extends  Model  implements DocumentInterface{



 @BelongsTo()
  @override
  DriverEntity? get driver;

  @override
  int get identificationNumber;


  @override
  Uint8List? get documentPdf;

 @HasOne(foreignTable:'photos',foreignKey: 'driving_licence_id')
  @override
  PhotoEntity ? get photo;

  @override
  @Column(length: 64)
  String get title;




 //DrivingLicenceEntity({this.idInt ,required this.title, required this.identificationNumber, required this.driver, this.documentPdf,this.photo, this. id});

  /*Serialization
  factory DrivingLicenceEntity.fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }*/

  //To Json
  @override
  Map<String, dynamic> toJson();


}
