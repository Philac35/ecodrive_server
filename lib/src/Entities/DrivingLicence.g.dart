// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DrivingLicence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrivingLicence _$DrivingLicenceFromJson(Map<String, dynamic> json) =>
    DrivingLicence(
      idInt: (json['idInt'] as num?)?.toInt(),
      title: json['title'] as String,
      identificationNumber: json['identificationNumber'] as int,
      driver: json['driver'] as Driver,
      photo: json['photo'] as Photo?,

    );

Map<String, dynamic> _$DrivingLicenceToJson(DrivingLicence instance) =>
    <String, dynamic>{
      'idInt': instance.idInt,
      'title': instance.title,
      'identificationNumber': instance.identificationNumber,
      'driver': instance.driver,
      'photo': instance.photo,

    };
