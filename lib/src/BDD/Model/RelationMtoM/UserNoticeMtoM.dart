import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';

import '../Notice.dart';
import '../User.dart';

@orm
@serializable
abstract class UserNoticeMtoM{


  @belongsTo
  Notice get notice;

  @belongsTo
  User get user;


}