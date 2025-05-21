

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';

import 'package:optional/optional_internal.dart';



import '../Abstract/FAngelModel.dart';
import '../FAngelModelQuery.dart';
import 'Driver.dart';
import '../../../Entities/Interface/entityInterface.dart';
import './Itinerary.dart' as iti;
import 'Itinerary.dart';
import 'Vehicule.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
part 'Travel.g.dart';


@orm
@serializable
abstract class Travel extends FAngelModel implements EntityInterface{
  int? idInt;

  @belongsTo
  Driver driver;

  @hasOne
  iti.Itinerary itinerary;



  List? userList;
  List? validate;
  DateTime? departureTime;
  DateTime? arrivalTime;
  DateTime? createdAt;
  DateTime? updatedAt;


  Travel({this.idInt, required this.driver,required this.itinerary,required this.departureTime, this.userList,this.validate,required this.createdAt, this.updatedAt, });


//Serialization
  factory Travel.fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }

//To Json
  Map<String, dynamic> toJson() ;

}