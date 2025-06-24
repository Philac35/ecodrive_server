import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/UserEntity.dart';
import 'package:angel3_migration/angel3_migration.dart';
import 'package:optional/optional_internal.dart';
import '../../Interface/entityInterface.dart';
import '../Abstract/PersonEntity.dart';
import 'UserEntity.dart';

part 'CommandEntity.g.dart';

@orm
@serializable
abstract class CommandEntity extends Model implements EntityInterface {


  @Column(length: 64)
  String get reference;

  double get credits ;

  double get unitaryPrice ;

  @Column(name: 'totalHT')
  double get totalHT ;  // Angel3 set underscore after upperCases in bdd, we need to redefine name

  @Column(name: 'totalTTC')
  double get totalTTC ;

  @Column(length: 16)
  String get status;

  @BelongsTo()
  UserEntity get user;


}