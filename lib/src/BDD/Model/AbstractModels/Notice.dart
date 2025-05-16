import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';


import '../../../Entities/Interface/entityInterface.dart';
import '../Abstract/FAngelModel.dart';

import 'Driver.dart';
import 'User.dart';


@orm
@serializable
abstract class Notice extends FAngelModel implements EntityInterface{

  int? idInt;
  String title;
  String description;
  int? note;
  DateTime? createdAt;

  @belongsTo
  Driver? driver;



Notice({ this.idInt,required this.title,required this.description, this.note,this.driver, this.createdAt});


//Serialization
  factory Notice.fromJson(Map<String, dynamic> json)  {
    // TODO: implement factory
    throw UnimplementedError();
  }

//To Json
  Map<String, dynamic> toJson() ;

}