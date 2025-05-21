import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:optional/optional_internal.dart';


import '../../Interface/entityInterface.dart';
import '../Abstract/FAngelModel.dart';

import '../FAngelModelQuery.dart';
import 'Driver.dart';
import 'User.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
part 'Notice.g.dart';

@orm
@serializable
abstract class Notice extends FAngelModel implements EntityInterface{

  int? idInt;
  String title;
  String description;
  int? note;
  DateTime? createdAt;

  @belongsTo
  Driver? driver;



Notice({ this.idInt,required this.title,required this.description, this.note,this.driver, this.createdAt});


//Serialization
  factory Notice.fromJson(Map<String, dynamic> json)  {
    // TODO: implement factory
    throw UnimplementedError();
  }

//To Json
  Map<String, dynamic> toJson() ;

}