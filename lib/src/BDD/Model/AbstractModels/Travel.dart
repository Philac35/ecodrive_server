

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/Entities/Itinerary.dart';



import '../Abstract/FAngelModel.dart';
import 'Driver.dart';
import '../../../Entities/Interface/entityInterface.dart';
import './Itinerary.dart' as iti;
import 'Vehicule.dart';



@orm
@serializable
abstract class Travel extends FAngelModel implements EntityInterface{
  int? idInt;

  @belongsTo
  Driver driver;
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