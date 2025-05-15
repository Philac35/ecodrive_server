// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Vehicule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicule _$VehiculeFromJson(Map<String, dynamic> json) => Vehicule(
      idInt: (json['idInt'] as num?)?.toInt(),
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      color: json['color'] as String?,
      energy: json['energy'] as String?,
      immatriculation: json['immatriculation'] as String?,
      firstImmatriculation: json['firstImmatriculation'] == null
          ? null
          : DateTime.parse(json['firstImmatriculation'] as String),
      nbPlaces: (json['nbPlaces'] as num?)?.toInt(),
      preferences: (json['preferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      assurance: json['assurance'] as String?,
    );

Map<String, dynamic> _$VehiculeToJson(Vehicule instance) => <String, dynamic>{
      'idInt': instance.idInt,
      'brand': instance.brand,
      'model': instance.model,
      'color': instance.color,
      'energy': instance.energy,
      'immatriculation': instance.immatriculation,
      'firstImmatriculation': instance.firstImmatriculation?.toIso8601String(),
      'nbPlaces': instance.nbPlaces,
      'preferences': instance.preferences,
      'assurance': instance.assurance,
    };
