
import 'dart:core';
import 'dart:typed_data';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
//import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:optional/optional_internal.dart';

import 'AddressEntity.dart' as a;
import 'AddressEntity.dart';
import 'TravelEntity.dart';

import '../../Interface/entityInterface.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
part 'ItineraryEntity.g.dart';



@Orm(generateMigrations:true)
@serializable
abstract class ItineraryEntity extends Model implements EntityInterface {

  double? get price;

  @HasOne(foreignKey: 'address_departure_id', foreignTable: 'addresses')
  a.AddressEntity?  get addressDeparture;

  @HasOne(foreignKey: 'address_arrival_id', foreignTable: 'addresses')
  a.AddressEntity? get  addressArrival;

  @DefaultsTo(false)
  bool?  get  eco;

  DateTime?  get duration;


  List<Uint8List>?  get geoPointList;


  @BelongsTo()
  TravelEntity? get  travel;

  //ItineraryEntity ({ this.price, this.addressDeparture,this.addressArrival,this.geoPointList, this.eco,this.duration,this.travel});


/*Serialization
  factory ItineraryEntity .fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }
*/

//To Json
  @override
  Map<String, dynamic> toJson() ;
}

