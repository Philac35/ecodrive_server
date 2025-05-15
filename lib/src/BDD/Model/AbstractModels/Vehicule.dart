import 'dart:convert';
import 'dart:typed_data';


import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:json_annotation/json_annotation.dart';

import '../Abstract/FAngelModel.dart';

import  '../../../Entities/Interface/entityInterface.dart';



@orm
@serializable
@JsonSerializable()
abstract class Vehicule extends FAngelModel implements EntityInterface{


  int? idInt;
  String? brand;
  String? model;
  String? color;
  String? energy;
  String? immatriculation;
  DateTime? firstImmatriculation;
  int? nbPlaces;


  List<String>?  preferences;
  String? assurance;
   Vehicule({this.idInt,this.brand,this.model,this.color,this.energy,this.immatriculation,this.firstImmatriculation,this.nbPlaces,this.preferences,this.assurance});


//Serialization
  //factory Vehicule.fromJson(Map<String, dynamic> json) => _$VehiculeFromJson(json);





//To Json
  Map<String, dynamic> toJson() ;

}