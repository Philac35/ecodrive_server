// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
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
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
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
