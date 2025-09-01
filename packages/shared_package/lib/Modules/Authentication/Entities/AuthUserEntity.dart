

import 'dart:convert';

import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_package/BDD/Interface/entityInterface.dart';

import '../../../BDD/Model/Abstract/PersonEntity.dart';
import './AuthUser.dart';
part 'AuthUserEntity.g.dart';

@JsonSerializable()
abstract class AuthUserEntity implements EntityInterface{
/*
String? get id;
String? get identifiant;
String? get password;
List<String>? get role;
int? get personId;
*/

String?  id;
DateTime? createdAt;
DateTime? updatedAt;
String?  identifiant;
String?  password;
List<String>? role;
int?  personId;

AuthUserEntity({
  this.id,
  this.createdAt,
  this.updatedAt,
  this.identifiant,
  this.password,
  List<String>? role = const [],

  this.personId,
}) : role = List.unmodifiable(role ?? []);

//Serialization
  factory AuthUserEntity.fromJson(Map<String, dynamic> json) => _$fromJson(json);


//To Json
  Map<String, dynamic> toJson() => _$toJson(this);

  @override
  // TODO: implement idAsInt
  int get idAsInt => throw UnimplementedError();

  @override
  // TODO: implement idAsString
  String get idAsString => throw UnimplementedError();


}