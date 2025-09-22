import '../../Interface/entityInterface.dart';
import '../../Model/Abstract/PersonEntity.dart';
import '../../Model/AbstractModels/DriverEntity.dart';
import '../../Model/AbstractModels/UserEntity.dart';
import '../../Model/AbstractModels/EmployeeEntity.dart';
import '../../Model/AbstractModels/AdministratorEntity.dart';
import '../../Model/Index/Entity_Index.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/TransformerAbstract.dart';
import 'Transformer.dart';

class PersonTransformer extends TransformerAbstract<Person> {

  PersonTransformer():super();
  @override
  Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
    final json = child.toJson();
    List<String>fields= Entity_Index[child.runtimeType.toString()]!['fields'];
    Map<String, dynamic>? res={};
    print("PersonTransformer.extract: json=$json, Person.fields=$fields");
    fields.forEach((value)=>  {

        if(json!.containsKey(value)){res.addAll({value:json![value]})}});
    print('PersonTransformer L17 : $fields');
    return res;

  }

  @override
  void attach(EntityInterface entity, dynamic related , RelationMeta relation) {

    if (related is User || related is Driver || related is Employee || related is Administrator) {
      related.setField('person' , entity);
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
  bool canExtract(String parentType,EntityInterface child) {

    List<String>childFields= Entity_Index[child.runtimeType.toString()]!['fields'];
    List<String>parentFields= Entity_Index['Person']!['fields'];
    print("PersonTransformer L44; canExtract? parent=$parentType child=${child.runtimeType} childFields=$childFields parentFields=$parentFields");

    return childFields.any((f) => parentFields.contains(f));
    bool res=true;
    for (final f in childFields) {
      if (!parentFields.contains(f)) {
        return false;  // child has a field parent cannot map
      }
    }
    return res;
  }
}
