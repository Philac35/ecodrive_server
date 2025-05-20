import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:ecodrive_server/src/Entities/Driver.dart';
import 'package:ecodrive_server/src/Entities/Photo.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Interface/DocumentInterface.dart';
part 'DrivingLicence.g.dart';

@JsonSerializable()
class DrivingLicence implements DocumentInterface {

  int? idInt;

  @override
  int identificationNumber;

  @override
  Uint8List? documentPdf;

  @override
  Photo? photo;

  @override
  String title;  

  @override
  Driver? driver;


  DrivingLicence({this.idInt,required this.title, required this.identificationNumber, required this.driver, this.documentPdf,this.photo});


  //Serialization
  factory DrivingLicence.fromJson(Map<String, dynamic> json) =>_$DrivingLicenceFromJson(json);

  //To Json
  @override
  Map<String, dynamic> toJson() => _$DrivingLicenceToJson(this);




}