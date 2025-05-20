
import 'dart:core';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:optional/optional_internal.dart';

import '../Abstract/FAngelModel.dart';
import '../FAngelModelQuery.dart';
import 'Address.dart';
import '../../../Entities/Interface/entityInterface.dart';

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
  Address? addressDeparture;

  @hasOne
  Address? addressArrival;

  bool? eco;
  DateTime? duration;
  DateTime? createdAt;

  Itinerary({this.idInt, this.price, this.addressDeparture,this.addressArrival, this.eco,this.duration,this.createdAt});


//Serialization
  factory Itinerary.fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }


//To Json
  Map<String, dynamic> toJson() ;
}

