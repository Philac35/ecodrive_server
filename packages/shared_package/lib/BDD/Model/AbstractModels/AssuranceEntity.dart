import 'dart:convert';
import 'dart:typed_data';


import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';

import 'package:optional/optional_internal.dart';
import '../../../Library/CompressionLibrary/CompressionLib.dart';
import '../../../Library/StringLibrary/string_librairy.dart';
import '../../../Services/Parser/Uint8ListJsonConverter.dart';
import '../../Interface/entityInterface.dart';
import 'DriverEntity.dart';
import 'Interface/Document.dart';
import 'package:shared_package/BDD/ORM/ORMExtension/SymbolToStringConverter.dart';
import 'PhotoEntity.dart';
import 'VehiculeEntity.dart';
//Import migration system
import 'package:angel3_migration/angel3_migration.dart';




part 'AssuranceEntity.g.dart';



@Orm(generateMigrations:true)
@serializable
abstract class AssuranceEntity  extends  Model implements Document  {


  @override
  int? get identificationNumber;

  @override
  Uint8List? get documentPdf;

  @override
  @HasOne(foreignKey: 'photo_id', foreignTable: 'photos')
  PhotoEntity? get photo;

  @override
  @Column(length: 64)
  String? get title;

  @override
  @Column(length: 256)
  String? get path;

  @BelongsTo(foreignTable:"vehicule",localKey:'vehicule_id',foreignKey: "id")
  VehiculeEntity?  get vehicule;

  int? get vehicule_id;

  /*Serialization
  factory AssuranceEntity .fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }*/

  //To Json
  @override
  Map<String, dynamic> toJson();





}
