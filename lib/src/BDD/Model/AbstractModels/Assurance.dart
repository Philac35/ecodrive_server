import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/Entities/Driver.dart';
import 'package:ecodrive_server/src/Entities/Interface/DocumentInterface.dart';
import 'package:ecodrive_server/src/Entities/Photo.dart';
import 'Vehicule.dart';

@orm
@serializable
abstract class Assurance implements DocumentInterface{
  @override
  Driver? driver;

  @override
  int identificationNumber;

  @override
  Photo? photo;

  @override
  String title;

  @belongsTo
  Vehicule vehicule;

  Assurance ({required this.title, required this.identificationNumber, required this.vehicule,required this.driver, this.photo});

  //Serialization
  factory Assurance.fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }

  //To Json
  @override
  Map<String, dynamic> toJson();





}