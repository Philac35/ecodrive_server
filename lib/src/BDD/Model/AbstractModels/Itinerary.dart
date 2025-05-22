
import 'dart:convert';
import 'dart:core';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:optional/optional_internal.dart';

import '../Abstract/FAngelModel.dart';
import '../FAngelModelQuery.dart';
import 'Address.dart' as a;
import 'Address.dart';
import 'Travel.dart';

import '../../Interface/entityInterface.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
part 'Itinerary.g.dart';

@orm
@serializable
abstract class Itinerary extends FAngelModel implements EntityInterface {

  int? idInt;
  double? price;

  @hasOne
  a.Address? addressDeparture;

  @hasOne
  a.Address? addressArrival;

  bool? eco;
  DateTime? duration;
  DateTime? createdAt;

  List<GeoPoint>? geoPointList;


  @belongsTo
  Travel? travel;
  Itinerary({this.idInt, this.price, this.addressDeparture,this.addressArrival,this.geoPointList, this.eco,this.duration,this.createdAt,this.travel});


//Serialization
  factory Itinerary.fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }


//To Json
  Map<String, dynamic> toJson() ;
}

