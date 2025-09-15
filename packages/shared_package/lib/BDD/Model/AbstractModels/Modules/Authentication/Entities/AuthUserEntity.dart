

import 'dart:convert';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:optional/optional_internal.dart';

import '../../../../../../Library/StringLibrary/string_librairy.dart';
import '../../../../../../Services/Parser/ParserJson.dart';
import '../../../../Abstract/PersonEntity.dart';


//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import '../../../../../Interface/entityInterface.dart';
import '../../../../Index/Entity_Index.dart';
part 'AuthUserEntity.g.dart';



@orm
@serializable
abstract class AuthUserEntity extends Model implements EntityInterface{

String? get identifiant;
String? get password;

List<String>? get role;

@BelongsTo()
PersonEntity? get person;
int? get personId;




/*Serialization
  factory AuthUserEntity.fromJson(Map<String, dynamic> json)  {
    // TODO: implement factory
    throw UnimplementedError();
  }*/

//To Json
  Map<String, dynamic> toJson() ;



}
