import 'dart:convert';


import 'dart:typed_data';


import 'package:json_annotation/json_annotation.dart';

import 'Interface/entityInterface.dart';
part 'Vehicule.g.dart';

@JsonSerializable()

class Vehicule  implements EntityInterface{


  int? id;
  String? brand;
  String? model;
  String? color;
  String? energy;
  String? immatriculation;
  DateTime? firstImmatriculation;
  int? nbPlaces;


  List<String>?  preferences;
  String? assurance;
   Vehicule({this.id,this.brand,this.model,this.color,this.energy,this.immatriculation,this.firstImmatriculation,this.nbPlaces,this.preferences,this.assurance});


//Serialization
  factory Vehicule.fromJson(Map<String, dynamic> json) => _$VehiculeFromJson(json);





//To Json
  Map<String, dynamic> toJson() => _$VehiculeToJson(this);

}