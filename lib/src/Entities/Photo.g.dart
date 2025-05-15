// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) => Photo(
      idInt: (json['idInt'] as num?)?.toInt(),
      title: json['title'] as String?,
      uri: json['uri'] as String?,
      description: json['description'] as String?,
      photo: _$JsonConverterFromJson<String, Uint8List>(
          json['photo'], const Uint8ListJsonConverter().fromJson),
    );

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'uri': instance.uri,
      'description': instance.description,
      'photo': _$JsonConverterToJson<String, Uint8List>(
          instance.photo, const Uint8ListJsonConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
