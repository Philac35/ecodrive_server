import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/Entities/Driver.dart';
import 'package:ecodrive_server/src/Entities/Photo.dart';
import '../../../Entities/Interface/DocumentInterface.dart';



@orm
@serializable
abstract class DrivingLicence implements DocumentInterface {


  @override
  int identificationNumber;

  @override
  Photo? photo;

  @override
  String title;  

  @belongsTo
  @override
  Driver? driver;


  DrivingLicence({required this.title, required this.identificationNumber, required this.driver, this.photo});


  //Serialization
  factory DrivingLicence.fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }

  //To Json
  @override
  Map<String, dynamic> toJson();




}