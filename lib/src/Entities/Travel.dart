

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/Entities/Itinerary.dart';
import 'package:json_annotation/json_annotation.dart';

import '../BDD/Model/Abstract/FAngelModel.dart';
import 'Driver.dart';
import 'Interface/entityInterface.dart';
import 'Itinerary.dart';
import 'Vehicule.dart';

part 'Travel.g.dart';


@JsonSerializable(explicitToJson: true)
class Travel extends FAngelModel implements EntityInterface{
  int? idInt;
  Driver driver;
  Itinerary itinerary;

  Vehicule vehicule;
  List? userList;
  List? validate;
  DateTime? departureTime;
  DateTime? arrivalTime;
  DateTime? createdAt;
  DateTime? updatedAt;


  Travel({this.idInt, required this.driver,required this.itinerary,required this.departureTime,required this.vehicule, this.userList,this.validate,required this.createdAt, this.updatedAt, });


//Serialization
  factory Travel.fromJson(Map<String, dynamic> json) => _$TravelFromJson(json);

//To Json
  Map<String, dynamic> toJson() => _$TravelToJson(this);

}