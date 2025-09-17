import '../../Interface/entityInterface.dart';
import '../../Model/Abstract/PersonEntity.dart';
import '../../Model/AbstractModels/DriverEntity.dart';
import '../../Model/AbstractModels/UserEntity.dart';
import '../../Model/Index/Entity_Index.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/TransformerAbstract.dart';
import 'Transformer.dart';

class PersonTransformer extends TransformerAbstract<Person> {
  @override
  Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
    final json = child.toJson();
    List<String>fields= Entity_Index[child.runtimeType.toString()]!['fields'];
    Map<String, dynamic>? res={};
    fields.forEach((value)=>  { if(json!.containsKey(value)){res.addAll({value:json![value]})}});
    print('PersonTransformer L17 : $fields');
    return res;

  }

  @override
  void attach(EntityInterface child, Person parent, RelationMeta relation) {
    if (child is User) {
      child.person = parent;
    }
    /*
    * else if (child is SomeOtherEntity) {
    *  child.user = parent;
    * }
    *  fallback: if child has a `setUser` method
    */
  }


  /**
   * Function canExtract
   * Computed dynamically based on the child entity
   **/
  bool canExtract(EntityInterface parent,EntityInterface child) {

    List<String>childFields= Entity_Index[child.runtimeType.toString()]!['fields'];
    List<String>parentFields= Entity_Index['Person']!['fields'];
    bool res=true;

    for (final f in childFields) {
      if (!parentFields.contains(f)) {
        return false;  // child has a field parent cannot map
      }
    }
    return res;
  }
}
