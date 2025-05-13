import 'package:json_annotation/json_annotation.dart';

import 'Interface/entityInterface.dart';

part 'Notice.g.dart';

@JsonSerializable()
class Notice  implements EntityInterface{

  int? id;
  String title;
  String description;
  int? note;
  DateTime? createdAt;


Notice({ this.id,required this.title,required this.description, this.note, this.createdAt});

//Serialization
  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);

//To Json
  Map<String, dynamic> toJson() => _$NoticeToJson(this);

}