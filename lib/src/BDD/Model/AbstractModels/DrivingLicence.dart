

import 'dart:typed_data';




import 'package:optional/optional_internal.dart';

import 'Interface/DocumentInterface.dart';
import 'Driver.dart' ;
import 'Photo.dart' ;
import 'Vehicule.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';

import '../Abstract/FAngelModel.dart';

part 'DrivingLicence.g.dart';


@orm
@serializable
abstract class DrivingLicence extends  FAngelModel  implements DocumentInterface{

 String? id;
  int? idInt;

  @belongsTo
  @override
  Driver? driver;

  @override
  int identificationNumber;

  @hasOne
  @override
  Uint8List? documentPdf;

  @hasOne
  @override
  Photo? photo;

  @override
  String title;




  DrivingLicence({this.idInt ,required this.title, required this.identificationNumber, required this.driver, this.documentPdf,this.photo});

  //Serialization
  factory DrivingLicence.fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }

  //To Json
  @override
  Map<String, dynamic> toJson();

//Assessors
 @override
 int? get id_Int=> idInt;

  @override
  void set id_Int(int? value)=> this.idInt=value;
}