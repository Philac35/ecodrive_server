
import 'dart:core';


import 'package:json_annotation/json_annotation.dart';

import 'Address.dart';
import 'Interface/entityInterface.dart';
part 'Itinerary.g.dart';

@JsonSerializable(explicitToJson: true)
class Itinerary  implements EntityInterface {

  int? id;
  double? price;
  Address? addressDeparture;
  Address? addressArrival;
  bool? eco;
  DateTime? duration;
  DateTime? createdAt;
Itinerary({this.id, this.price, this.addressDeparture,this.addressArrival, this.eco,this.duration,this.createdAt});
//Serialization
  factory Itinerary.fromJson(Map<String, dynamic> json) => _$ItineraryFromJson(json);

//To Json
  Map<String, dynamic> toJson() => _$ItineraryToJson(this);
}

