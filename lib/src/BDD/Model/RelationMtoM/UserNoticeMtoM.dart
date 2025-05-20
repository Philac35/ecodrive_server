import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:angel3_migration/angel3_migration.dart';
import 'package:optional/optional_internal.dart';

import '../AbstractModels/Notice.dart';
import '../AbstractModels/User.dart';
import '../FAngelModelQuery.dart';

part 'UserNoticeMtoM.g.dart';

@orm
@serializable
abstract class UserNoticeMtoM{


  @belongsTo
  Notice? get notice;

  @belongsTo
  User? get user;


}