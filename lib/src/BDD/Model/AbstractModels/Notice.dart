import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../Entities/Interface/entityInterface.dart';
import '../Abstract/FAngelModel.dart';


import 'User.dart';


@orm
@serializable
abstract class Notice extends FAngelModel implements EntityInterface{

  int? idInt;
  String title;
  String description;
  int? note;
  DateTime? createdAt;



Notice({ this.idInt,required this.title,required this.description, this.note, this.createdAt});


}