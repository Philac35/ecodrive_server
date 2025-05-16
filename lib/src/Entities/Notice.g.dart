// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notice _$NoticeFromJson(Map<String, dynamic> json) => Notice(
      idInt: (json['idInt'] as num?)?.toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      note: (json['note'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NoticeToJson(Notice instance) => <String, dynamic>{
      'idInt': instance.idInt,
      'title': instance.title,
      'description': instance.description,
      'note': instance.note,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
