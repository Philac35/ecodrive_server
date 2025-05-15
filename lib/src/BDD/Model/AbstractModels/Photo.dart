
import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../Services/Parser/Uint8ListJsonConverter.dart';
import '../Abstract/FAngelModel.dart';


 import '../../../Entities/Interface/entityInterface.dart';
import 'dart:typed_data';


@orm
@serializable
@JsonSerializable()
abstract class Photo extends FAngelModel  implements EntityInterface{
  int? idInt;
  String? title;
  String? uri;
  String? description;
  @Uint8ListJsonConverter()
  Uint8List? photo;


  Photo({this.idInt,required this.title, this.uri, this.description, this.photo });
  //Serialization
 // factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  //To Json
  Map<String, dynamic> toJson();
}
