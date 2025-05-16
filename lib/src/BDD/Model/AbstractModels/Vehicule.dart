import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';


import '../Abstract/FAngelModel.dart';

import  '../../../Entities/Interface/entityInterface.dart';

import 'Assurance.dart';
import 'Driver.dart';
import 'Photo.dart';


@orm
@serializable
abstract class Vehicule extends FAngelModel implements EntityInterface{


  int? idInt;
  String? brand;
  String? model;
  String? color;
  String? energy;
  String? immatriculation;
  DateTime? firstImmatriculation;
  int? nbPlaces;

  @hasMany
  List<Photo>? photoList;

  //Owner
  @belongsTo
  Driver driver;

  List<String>?  preferences;

  @hasOne
  Assurance? assurance;



   Vehicule({this.idInt,required this.driver,this.brand,this.model,this.color,this.energy,this.immatriculation,this.firstImmatriculation,this.nbPlaces,this.preferences,this.assurance, this.photoList});


//Serialization
  factory Vehicule.fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }

//To Json
  Map<String, dynamic> toJson() ;

}