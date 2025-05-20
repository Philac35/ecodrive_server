import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:ecodrive_server/src/Entities/Driver.dart';
import 'package:ecodrive_server/src/Entities/Interface/DocumentInterface.dart';
import 'package:ecodrive_server/src/Entities/Photo.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Assurance.g.dart';

@JsonSerializable()
class Assurance implements DocumentInterface{

  int? idInt;

  @override
  Driver? driver;

  @override
  int identificationNumber;


  @override
  Uint8List? documentPdf;

  @override
  Photo? photo;


  @override
  String title;


  Assurance ({ this. idInt,required this.title, required this.identificationNumber, required this.driver,this.documentPdf, this.photo});

  //Serialization
  factory Assurance.fromJson(Map<String, dynamic> json) =>_$AssuranceFromJson(json);

  //To Json
  @override
  Map<String, dynamic> toJson() => _$AssuranceToJson(this);







}