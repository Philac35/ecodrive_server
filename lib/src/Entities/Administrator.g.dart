// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Administrator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Administrator _$AdministratorFromJson(Map<String, dynamic> json) =>
    Administrator(
      idInt: (json['idInt'] as num?)?.toInt(),
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      photo: json['photo'] == null
          ? null
          : Photo.fromJson(json['photo'] as Map<String, dynamic>),
      authUser: json['authUser'] == null
          ? null
          : AuthUser.fromJson(json['authUser'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    )..email = json['email'] as String?;

Map<String, dynamic> _$AdministratorToJson(Administrator instance) =>
    <String, dynamic>{
      'idInt': instance.idInt,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'age': instance.age,
      'gender': instance.gender,
      'address': instance.address?.toJson(),
      'email': instance.email,
      'photo': instance.photo?.toJson(),
      'authUser': instance.authUser?.toJson(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
