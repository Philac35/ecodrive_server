
import 'package:json_annotation/json_annotation.dart';

import '../Services/Parser/Uint8ListJsonConverter.dart';
import 'Interface/entityInterface.dart';
import 'dart:typed_data';
part 'Photo.g.dart';


@JsonSerializable()
class Photo  implements EntityInterface{
  int? id;
  String? title;
  String? uri;
  String? description;
  @Uint8ListJsonConverter()
  Uint8List? photo;


  Photo({this.id,required this.title, this.uri, this.description, this.photo });
  //Serialization
  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  //To Json
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
