import 'package:ecodrive_server/src/Entities/Interface/entityInterface.dart';
import 'package:json_annotation/json_annotation.dart';
 
import 'Interface/entityInterface.dart';
part 'Address.g.dart';

@JsonSerializable()
class Address implements EntityInterface{

  int? id;
  int? number;
  String? type;
  String address;
  String? complementAddress;
  String? postCode;
  String? city;
  String? country ;
  DateTime? createdAt;

  Address({this.id, this.type, required this.address, this.complementAddress, required this. postCode,required this.city, this.country, required this.createdAt});


  //Serialization
  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  //To Json
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}