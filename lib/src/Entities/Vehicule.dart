import 'dart:convert';
import 'dart:typed_data';


import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:json_annotation/json_annotation.dart';

import '../BDD/Model/Abstract/FAngelModel.dart';
import 'Interface/entityInterface.dart';

import 'Driver.dart';
part 'Vehicule.g.dart';



@JsonSerializable()
class Vehicule extends FAngelModel implements EntityInterface{


  int? idInt;
  Driver? driver;
  String? brand;
  String? modele;   //model is a used term in Angel 3, we should better use french term
  String? color;
  String? energy;
  String? immatriculation;
  DateTime? firstImmatriculation;
  int? nbPlaces;


  List<String>?  preferences;
  String? assurance;
   Vehicule({this.idInt,this.driver,this.brand,this.modele,this.color,this.energy,this.immatriculation,this.firstImmatriculation,this.nbPlaces,this.preferences,this.assurance});


//Serialization
  factory Vehicule.fromJson(Map<String, dynamic> json) => _$VehiculeFromJson(json);





//To Json
  Map<String, dynamic> toJson() => _$VehiculeToJson(this);

}