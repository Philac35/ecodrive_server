import '../../Interface/entityInterface.dart';
import '../../Model/Abstract/PersonEntity.dart';
import '../../Model/AbstractModels/DriverEntity.dart';
import '../../Model/AbstractModels/UserEntity.dart';
import '../../Model/Index/Entity_Index.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/TransformerAbstract.dart';
import 'Transformer.dart';

class UserTransformer extends TransformerAbstract<Person> {
  EntityInterface? entity;
   UserTransformer() : super();

  @override
  Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
    final json = child.toJson();
   // return json!["person"]?["authUser"];
    List<String>fields= Entity_Index[child.runtimeType.toString()]!['fields'];
    Map<String, dynamic>? res={};
    fields.forEach((value)=>  {
      if(json!.containsKey(value)){res.addAll({value:json![value]})}});
   return res;
  }

  @override
  /**
   * Function attach
   * @Param EntityInterface entity
   * @Param EntityInterface parent is a User
   * @Param RelationMeta
   */
  void attach(EntityInterface entity, dynamic parent , RelationMeta relation) {
    if (entity is Driver) {
      entity.user = parent as User?;
    }
   }
}
