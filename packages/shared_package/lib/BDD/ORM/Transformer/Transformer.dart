import 'package:shared_package/BDD/Model/Index/Entity_Index.dart';

import '../../Interface/entityInterface.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/TransformerAbstract.dart';



class Transformer<T extends EntityInterface> extends TransformerAbstract {
  EntityInterface? entity;

  Transformer(this.entity);

  @override
  Map<String, dynamic>? extract(
      EntityInterface related,
      RelationMeta relation,
      ) {
    final json = related.toJson();

   List<String>fields= Entity_Index[entity.runtimeType.toString()]!['fields'];
    Map<String, dynamic>? res={};

     fields.forEach((value)=>  { if(json!.containsKey(value)){res.addAll({value:json![value]})}});
    return res;
  }

  @override
  void attach(
      EntityInterface entity,
      dynamic related,
      RelationMeta relation,
      ) {
    if (related !=null && entity != null ) {
      entity.setField(related.runtimeType.toString(),entity);
    }
  }
}
