// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Travel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Travel _$TravelFromJson(Map<String, dynamic> json) => Travel(
      idInt: (json['idInt'] as num?)?.toInt(),
      driver: Driver.fromJson(json['driver'] as Map<String, dynamic>),
      itinerary: Itinerary.fromJson(json['itinerary'] as Map<String, dynamic>),
      departureTime: json['departureTime'] == null
          ? null
          : DateTime.parse(json['departureTime'] as String),
      vehicule: Vehicule.fromJson(json['vehicule'] as Map<String, dynamic>),
      userList: json['userList'] as List<dynamic>?,
      validate: json['validIntate'] as List<dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    )..arrivalTime = json['arrivalTime'] == null
        ? null
        : DateTime.parse(json['arrivalTime'] as String);

Map<String, dynamic> _$TravelToJson(Travel instance) => <String, dynamic>{
      'idInt': instance.idInt,
      'driver': instance.driver.toJson(),
      'itinerary': instance.itinerary.toJson(),
      'vehicule': instance.vehicule.toJson(),
      'userList': instance.userList,
      'validate': instance.validate,
      'departureTime': instance.departureTime?.toIso8601String(),
      'arrivalTime': instance.arrivalTime?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
