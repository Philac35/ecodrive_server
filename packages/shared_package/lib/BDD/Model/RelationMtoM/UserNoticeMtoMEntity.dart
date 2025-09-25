import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:angel3_migration/angel3_migration.dart';
import 'package:optional/optional_internal.dart';


import '../../Interface/entityInterface.dart';
import '../Abstract/PersonEntity.dart';
import '../AbstractModels/NoticeEntity.dart';
import '../AbstractModels/UserEntity.dart';
import 'package:shared_package/Library/StringLibrary/str_extension.dart';

part 'UserNoticeMtoMEntity.g.dart';


@Orm(generateMigrations:true)
@serializable
abstract class UserNoticeMtoMEntity extends Model implements EntityInterface{


  @BelongsTo()
  NoticeEntity? get notice;

  int? get noticeId;

  @BelongsTo()
  UserEntity? get user;

  int? get userId;


}
