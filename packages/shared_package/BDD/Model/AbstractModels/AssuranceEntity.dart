import 'dart:convert';
import 'dart:typed_data';


import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';

import 'package:optional/optional_internal.dart';
 
import 'DriverEntity.dart';
import 'Interface/DocumentInterface.dart';
import 'ORMExtension/ForeignTableSqlExpressionBuilder.dart';
import 'PhotoEntity.dart';
import 'VehiculeEntity.dart';
import '../Abstract/PersonEntity.dart';
//Import migration system
import 'package:angel3_migration/angel3_migration.dart';




part 'AssuranceEntity.g.dart';



@Orm(generateMigrations:true)
@serializable
abstract class AssuranceEntity  extends  Model  implements DocumentInterface{


  @override
  int get identificationNumber;

  @override
  Uint8List? get  documentPdf;

  @override
  @HasOne(foreignKey: 'photo_id', foreignTable: 'photos')
  PhotoEntity? get photo;

  @override
  @Column(length: 64)
  String get title;

  @BelongsTo()
  VehiculeEntity  get vehicule;

   //AssuranceEntity ({required this.title, required this.identificationNumber, required this.vehicule, this.documentPdf,this.photo});

  /*Serialization
  factory AssuranceEntity .fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }*/

  //To Json
  @override
  Map<String, dynamic> toJson();





}
