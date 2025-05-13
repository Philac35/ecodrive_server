// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Itinerary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Itinerary _$ItineraryFromJson(Map<String, dynamic> json) => Itinerary(
      id: (json['id'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      addressDeparture: json['addressDeparture'] == null
          ? null
          : Address.fromJson(json['addressDeparture'] as Map<String, dynamic>),
      addressArrival: json['addressArrival'] == null
          ? null
          : Address.fromJson(json['addressArrival'] as Map<String, dynamic>),
      eco: json['eco'] as bool?,
      duration: json['duration'] == null
          ? null
          : DateTime.parse(json['duration'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ItineraryToJson(Itinerary instance) => <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'addressDeparture': instance.addressDeparture?.toJson(),
      'addressArrival': instance.addressArrival?.toJson(),
      'eco': instance.eco,
      'duration': instance.duration?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
