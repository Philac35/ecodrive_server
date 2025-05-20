import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/Entities/Driver.dart';
import 'package:ecodrive_server/src/Entities/Interface/DocumentInterface.dart';
import 'package:ecodrive_server/src/Entities/Photo.dart';
import 'package:optional/optional_internal.dart';
import '../Abstract/FAngelModel.dart';
import 'Vehicule.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
part 'Assurance.g.dart';


@orm
@serializable
abstract class Assurance  extends  FAngelModel  implements DocumentInterface{


   int? idInt;

  @override
  Driver? driver;


  @override
  int identificationNumber;

  @override
  Uint8List? documentPdf;

  @override
  Photo? photo;

  @override
  String title;

  @belongsTo
  Vehicule vehicule;

  Assurance ({this. idInt ,required this.title, required this.identificationNumber, required this.vehicule,required this.driver, this.documentPdf,this.photo});

  //Serialization
  factory Assurance.fromJson(Map<String, dynamic> json) {
    // TODO: implement factory
    throw UnimplementedError();
  }

  //To Json
  @override
  Map<String, dynamic> toJson();





}