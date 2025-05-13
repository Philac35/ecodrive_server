

import 'package:ecodrive_server/src/Entities/Itinerary.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Driver.dart';
import 'Interface/entityInterface.dart';
import 'Itinerary.dart';
import 'Vehicule.dart';

part 'Travel.g.dart';

@JsonSerializable(explicitToJson: true)
class Travel  implements EntityInterface{
  int? id;
  Driver driver;
  Itinerary itinerary;

  Vehicule vehicule;
  List? userList;
  List? validate;
  DateTime? departureTime;
  DateTime? arrivalTime;
  DateTime createdAt;
  DateTime? updatedAt;


  Travel({this.id, required this.driver,required this.itinerary,required this.departureTime,required this.vehicule, this.userList,this.validate,required this.createdAt, this.updatedAt, });


//Serialization
  factory Travel.fromJson(Map<String, dynamic> json) => _$TravelFromJson(json);

//To Json
  Map<String, dynamic> toJson() => _$TravelToJson(this);

}