// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthUserEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

 AuthUser _$fromJson(Map<String, dynamic> json) => AuthUser(
      id:  json['id'] is num ?json['id'].toString():json['id'],
      identifiant: json['identifiant'] as String?,
      password: json['password'] as String?,
      role: (json['role'] as List<dynamic>) .map((e)=>e.toString()).toList() ,
      personId: json['person_id']!=null? json['person_id'] as int?: json["personId"]!=null?json["personId"]  as int?:null
    );

Map<String, dynamic> _$toJson(AuthUserEntity instance) => <String, dynamic>{
      'id': instance.id,
      'identifiant': instance.identifiant,
      'password': instance.password,
      'role': instance.role,
      'personId': instance.personId,
    };

