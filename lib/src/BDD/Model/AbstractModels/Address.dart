import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Itinerary.dart';
import 'package:optional/optional.dart';


import 'package:ecodrive_server/src/Entities/Interface/entityInterface.dart';

import './Abstract/Person.dart';
import '../Abstract/FAngelModel.dart';



@orm
@serializable
abstract class Address extends  FAngelModel implements EntityInterface {


  int? idInt;
  int? number;
  String? type;
  String address;
  String? complementAddress;
  String? postCode;
  String? city;
  String? country ;
  DateTime? createdAt;

   //Owner
    @belongsTo
   Person? person;

    @belongsTo
    Itinerary? itinerary;

  Address({this.idInt, this.type, required this.address, this.complementAddress, required this. postCode,required this.city, this.country,  this.person,  this.itinerary,required this.createdAt});


  //Serialization
  factory Address.fromJson(Map<String, dynamic> json)   {
    // TODO: implement factory
    throw UnimplementedError();
  }


  //To Json
  Map<String, dynamic> toJson();

  @override
  set intId(int value) {
    intId= value;
  }






}