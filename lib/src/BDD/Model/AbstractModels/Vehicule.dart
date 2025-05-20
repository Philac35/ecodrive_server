import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:optional/optional_internal.dart';


import '../../../Entities/Vehicule.dart' as concreteVehicule;
import '../Abstract/FAngelModel.dart';

import  '../../../Entities/Interface/entityInterface.dart';

import '../FAngelModelQuery.dart';
import 'Assurance.dart';
import 'Driver.dart';
import 'Photo.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
part 'Vehicule.g.dart';

@orm
@serializable
abstract class Vehicule extends FAngelModel implements EntityInterface{


  int? idInt;
  String? brand;
  String? modele;   //model is a used term in Angel 3, we should better use french term
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



   Vehicule( {this.idInt,required this.driver,this.brand,this.modele,this.color,this.energy,this.immatriculation,this.firstImmatriculation,this.nbPlaces,this.preferences,this.assurance, this.photoList, DateTime? createdAt, DateTime? updatedAt, String? id});


//Serialization
  factory Vehicule.fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }

//To Json
  Map<String, dynamic> toJson() ;


}