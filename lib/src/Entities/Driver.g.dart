// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Driver _$DriverFromJson(Map<String, dynamic> json) => Driver(
      idInt: (json['idInt'] as num?)?.toInt(),
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      email: json['email'] as String?,
      photo: json['photo'] == null
          ? null
          : Photo.fromJson(json['photo'] as Map<String, dynamic>),
      authUser: json['authUser'] == null
          ? null
          : AuthUser.fromJson(json['authUser'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      notice: json['notice'] == null
          ? null
          : Notice.fromJson(json['notice'] as Map<String, dynamic>),
      preferences: json['preferences'] as List<dynamic>?,
      drivinglicense: json['drivinglicense'] as DrivingLicence?,
    );

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
      'idInt': instance.idInt,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'age': instance.age,
      'gender': instance.gender,
      'address': instance.address?.toJson(),
      'email': instance.email,
      'photo': instance.photo?.toJson(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'authUser': instance.authUser?.toJson(),
      'notice': instance.notice?.toJson(),
      'preferences': instance.preferences,
      'drivinglicense': instance.drivinglicense,
    };
