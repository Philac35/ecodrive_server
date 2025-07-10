

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:optional/optional.dart';


import 'package:optional/optional_internal.dart' ;




import '../Abstract/PersonEntity.dart';
import 'DriverEntity.dart';
import '../../Interface/entityInterface.dart';
import 'ItineraryEntity.dart' as iti;
import 'ItineraryEntity.dart';
import 'ORMExtension/ForeignTableSqlExpressionBuilder.dart';
import 'UserEntity.dart';
import 'VehiculeEntity.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';

part 'TravelEntity.g.dart';


@Orm(tableName:'travels',generateMigrations:true)
@serializable
abstract class TravelEntity extends Model implements EntityInterface{

  @BelongsTo()
  DriverEntity  get  driver;

  @HasOne(foreignTable:'itineraries', foreignKey: 'itinerary_id')
  iti.ItineraryEntity get   itinerary;


  @HasMany(foreignTable: 'users', foreignKey: 'travel_id')
  List?  get user;

  List? get  validate;
  DateTime?  get departureTime;
  DateTime?  get arrivalTime;



 // TravelEntity ({this.idInt, required this.driver,required this.itinerary,required this.departureTime, this.arrivalTime,this.userList,this.validate });
TravelEntity.empty();


//To Json
  Map<String, dynamic> toJson() ;

}
