// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => AuthUser(
      id: (json['id'] as num?)?.toInt(),
      identifiant: json['identifiant'] as String?,
      password: json['password'] as String?,
      role: (json['role'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AuthUserToJson(AuthUser instance) => <String, dynamic>{
      'id': instance.id,
      'identifiant': instance.identifiant,
      'password': instance.password,
      'role': instance.role,
    };
