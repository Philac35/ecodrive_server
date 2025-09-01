import 'package:angel3_serialize/angel3_serialize.dart';

import './AuthUserEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@generatedSerializable
@JsonSerializable()
class AuthUser extends AuthUserEntity {


  AuthUser({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.identifiant,
    this.password,
    List<String>? role = const [],
    this.personId,
  }) : role = List.unmodifiable(role ?? []);

  /// A unique identifier corresponding to this item.
  @override
  String? id;

  String? cascadeTempKey;

  /// The time at which this item was created.
  @override
  DateTime? createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime? updatedAt;

  @override
  String? identifiant;

  @override
  String? password;

  @override
  List<String>? role;

  @override
  int? personId;



  AuthUser copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? identifiant,
    String? password,
    List<String>? role,
    personId
  }) {
    return AuthUser(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        identifiant: identifiant ?? this.identifiant,
        password: password ?? this.password,
        role: role ?? this.role,
        personId: personId ?? this.personId
    );
  }



  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      identifiant,
      password,
      role,
      personId
    ]);
  }

  @override
  String toString() {
    return 'AuthUser(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, identifiant=$identifiant, password=$password, role=$role,  personId=$personId)';
  }

}