
import 'dart:core';


import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:json_annotation/json_annotation.dart';

import '../Abstract/FAngelModel.dart';
import 'Address.dart';
import '../../../Entities/Interface/entityInterface.dart';



@orm
@serializable
@JsonSerializable(explicitToJson: true)
abstract class Itinerary extends FAngelModel implements EntityInterface {

  int? idInt;
  double? price;

  @hasOne
  Address? addressDeparture;

  @hasOne
  Address? addressArrival;

  bool? eco;
  DateTime? duration;
  DateTime? createdAt;
Itinerary({this.idInt, this.price, this.addressDeparture,this.addressArrival, this.eco,this.duration,this.createdAt});
//Serialization
 // factory Itinerary.fromJson(Map<String, dynamic> json) => _$ItineraryFromJson(json);

//To Json
  Map<String, dynamic> toJson() ;
}

