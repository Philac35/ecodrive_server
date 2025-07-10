import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:optional/optional_internal.dart';



import '../../Interface/entityInterface.dart';


import '../Abstract/PersonEntity.dart';
import 'AssuranceEntity.dart';

import 'DriverEntity.dart';


//Import migration system
import 'package:angel3_migration/angel3_migration.dart';

import 'PhotoEntity.dart';


part 'VehiculeEntity.g.dart';

@orm
@serializable
abstract class VehiculeEntity extends Model implements EntityInterface{


  @Column(length: 64)
  String? get brand;

  @Column(length: 64)
  String? get modele;   //model is a used term in Angel 3, we should better use french term

  @Column(length: 64)
  String? get color;

  @Column(length: 64)
  String? get energy;

  @Column(length: 64)
  String? get immatriculation;

  DateTime? get firstImmatriculation;
  int? get nbPlaces;

  @HasMany()
  List<PhotoEntity>? get photoList;

  //Owner
  @BelongsTo()
  DriverEntity get  driver;

  List<String>?  get preferences;

  @HasOne(foreignTable: 'assurances', foreignKey: 'assurance_id')
  AssuranceEntity? get assurance;





}
