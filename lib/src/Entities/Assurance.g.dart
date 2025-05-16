// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Assurance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Assurance _$AssuranceFromJson(Map<String, dynamic> json) =>
    Assurance(
      idInt: (json['idInt'] as num?)?.toInt(),
      title: json['title'] as String,
      identificationNumber: json['identificationNumber'] as int,
      driver: json['driver'] as Driver,
      photo: json['photo'] as Photo?,

    );

Map<String, dynamic> _$AssuranceToJson(Assurance instance) =>
    <String, dynamic>{
      'idInt': instance.idInt,
      'title': instance.title,
      'identificationNumber': instance.identificationNumber,
      'driver': instance.driver,
      'photo': instance.photo,

    };
