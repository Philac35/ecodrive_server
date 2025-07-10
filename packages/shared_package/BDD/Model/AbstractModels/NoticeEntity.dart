import 'package:angel3_orm/angel3_orm.dart';
import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:optional/optional_internal.dart';


import '../../Interface/entityInterface.dart';

import '../Abstract/PersonEntity.dart';
import 'DriverEntity.dart';
import 'ORMExtension/ForeignTableSqlExpressionBuilder.dart';
import 'UserEntity.dart';

//Import migration system
import 'package:angel3_migration/angel3_migration.dart';


part 'NoticeEntity.g.dart';


@Orm(generateMigrations:true)
@serializable
abstract class NoticeEntity extends Model implements EntityInterface{

  @Column(length: 64)
  String get  title;
  @Column(length: 256)
  String get  description;
  int? get  note;
  DateTime? get  createdAt;

  @BelongsTo()
  DriverEntity?  get driver;


//NoticeEntity ({ required this.title,required this.description, this.note,this.driver});


/*Serialization
  factory NoticeEntity .fromJson(Map<String, dynamic> json)  {
    // TODO: implement factory
    throw UnimplementedError();
  }
*/
//To Json
  Map<String, dynamic> toJson() ;

}
