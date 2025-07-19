import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';

import 'package:optional/optional.dart';

import '../../Interface/entityInterface.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';

import '../Abstract/PersonEntity.dart';
import 'ItineraryEntity.dart';
part 'AddressEntity.g.dart';


@Orm(generateMigrations:true)
@serializable
abstract class AddressEntity extends Model implements EntityInterface
{


  int? get number;
  String? get type;
  String? get address;  //was required
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
   PersonEntity? get person;


  //  @BelongsTo(foreignKey:'itineraries_id')
    @BelongsTo()
    ItineraryEntity? get itinerary;

  /*Serialization
  factory AddressEntity.fromJson(Map<String, dynamic> json)   {
    // TODO: implement factory
    throw UnimplementedError();
  }*/

  //To Json
  @override
  Map<String, dynamic>? toJson();



}
