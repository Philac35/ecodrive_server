

import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:optional/optional_internal.dart';

import '../../../../Abstract/PersonEntity.dart';


//Import migration system
import 'package:angel3_migration/angel3_migration.dart';

part 'AuthUserEntity.g.dart';



@orm
@serializable
abstract class AuthUserEntity extends Model{

String? get identifiant;
String? get password;

List<String>? get role;

@BelongsTo()
PersonEntity? get person;




/*Serialization
  factory AuthUserEntity.fromJson(Map<String, dynamic> json)  {
    // TODO: implement factory
    throw UnimplementedError();
  }*/

//To Json
  Map<String, dynamic> toJson() ;


}
