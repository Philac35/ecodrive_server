

import 'dart:convert';
import 'dart:typed_data';




import 'package:optional/optional_internal.dart';
import 'package:shared_package/BDD/ORM/ORMExtension/SymbolToStringConverter.dart';
import 'package:shared_package/Library/StringLibrary/string_librairy.dart';

import '../../../Services/Parser/Uint8ListJsonConverter.dart';
import '../../Interface/entityInterface.dart';
import '../Abstract/PersonEntity.dart';
import 'Interface/Document.dart';
import 'DriverEntity.dart';
import 'PhotoEntity.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';



part 'DrivingLicenceEntity.g.dart';


@Orm(generateMigrations:true)
@serializable
abstract class DrivingLicenceEntity extends  Model implements  Document {

 @BelongsTo()
  @override
  DriverEntity? get driver;

  @override
  int? get identificationNumber;


  @override
  Uint8List? get documentPdf;

 @HasOne(foreignTable:'photos',foreignKey: 'driving_licence_id')
  @override
  PhotoEntity ? get photo;

  @override
  @Column(length: 64)
  String? get title;




  /*Serialization
  factory DrivingLicenceEntity.fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }*/

  //To Json
  @override
  Map<String, dynamic> toJson();


}
