// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String?,
      address: json['address'] as String,
      complementAddress: json['complementAddress'] as String?,
      postCode: json['postCode'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    )..number = (json['number'] as num?)?.toInt();

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'type': instance.type,
      'address': instance.address,
      'complementAddress': instance.complementAddress,
      'postCode': instance.postCode,
      'city': instance.city,
      'country': instance.country,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
