import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:optional/optional.dart';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:ecodrive_server/src/Entities/Interface/entityInterface.dart';
import 'package:json_annotation/json_annotation.dart';
 
import '../BDD/Model/Abstract/FAngelModel.dart';
import 'Interface/entityInterface.dart';
part 'Address.g.dart';



@orm
@serializable
@JsonSerializable()
class Address extends  FAngelModel implements EntityInterface {


  int? idInt;
  int? number;
  String? type;
  String address;
  String? complementAddress;
  String? postCode;
  String? city;
  String? country ;
  DateTime? createdAt;



  Address({this.idInt, this.type, required this.address, this.complementAddress, required this. postCode,required this.city, this.country, required this.createdAt});


  //Serialization
  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  //To Json
  Map<String, dynamic> toJson() => _$AddressToJson(this);

  @override
  set intId(int value) {
    intId= value;
  }






}