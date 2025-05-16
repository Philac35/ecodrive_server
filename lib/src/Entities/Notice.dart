import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:json_annotation/json_annotation.dart';

import '../BDD/Model/Abstract/FAngelModel.dart';
import 'Interface/entityInterface.dart';
import 'User.dart';

part 'Notice.g.dart';

@JsonSerializable()
class Notice extends FAngelModel implements EntityInterface{

  int? idInt;
  String title;
  String description;
  int? note;
  DateTime? createdAt;



Notice({ this.idInt,required this.title,required this.description, this.note, this.createdAt});

//Serialization
  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);

//To Json
  Map<String, dynamic> toJson() => _$NoticeToJson(this);

}