import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:angel3_migration/angel3_migration.dart';
import 'package:optional/optional_internal.dart';


import '../Abstract/PersonEntity.dart';
import '../AbstractModels/NoticeEntity.dart';
import '../AbstractModels/UserEntity.dart';



part 'UserNoticeMtoMEntity.g.dart';



@Orm(generateMigrations:true)
@serializable
abstract class UserNoticeMtoMEntity{


  @BelongsTo()
  NoticeEntity? get notice;

  @BelongsTo()
  UserEntity? get user;


}
