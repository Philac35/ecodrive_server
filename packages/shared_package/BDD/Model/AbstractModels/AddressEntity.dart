import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/ORMExtension/ForeignTableSqlExpressionBuilder.dart';

import 'package:optional/optional.dart';

import 'package:angel3_orm_mysql/angel3_orm_mysql.dart';
import '../../Interface/entityInterface.dart';


import '../Abstract/PersonEntity.dart';

//Import migration system

import 'package:angel3_migration/angel3_migration.dart';

import 'ItineraryEntity.dart';
part 'AddressEntity.g.dart';




@Orm(generateMigrations:true)
@serializable
abstract class AddressEntity extends Model implements EntityInterface
{


  int? get number;
  String? get type;
  String get address;
  String? get complementAddress;

  @Column(length: 8)
  String? get postCode;
  @Column(length: 64)
  String? get city;
  @Column(length: 64)
  String? get country ;

   //Owner
    //@BelongsTo(foreignKey: 'person_id', foreignTable: 'persons')
    @BelongsTo()
   PersonEntity? person;


  //  @BelongsTo(foreignKey:'itineraries_id')
    @BelongsTo()
    ItineraryEntity? itinerary;

  /*Serialization
  factory AddressEntity.fromJson(Map<String, dynamic> json)   {
    // TODO: implement factory
    throw UnimplementedError();
  }*/

  //To Json
  Map<String, dynamic> toJson();



}
