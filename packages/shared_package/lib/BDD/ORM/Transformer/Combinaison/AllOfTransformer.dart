import '../../../Interface/entityInterface.dart';
import '../../Relations/RelationMeta.dart';
import '../Interface/TransformerCombinator.dart';
import 'package:shared_package/BDD/Model/Index/Entity_Index.dart';

/**
 * Class AllOfTransformer
 * apply all transformers and merge results
 */
class AllOfTransformer<T extends EntityInterface>
    extends TransformerCombinator<T> {


  AllOfTransformer(super.transformers);

  @override
  Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
    final result = <String, dynamic>{};
    for (final t in transformers) {
      if ((t as dynamic).canExtract(relation.relatedType,child)) {
        final map = t.extract(child, relation);
      if (map != null) map.forEach((k,v) {
        if (v != null) result[k] = v;
      });
      }
    }
    return result.isNotEmpty ? result : null;
  }

  @override
  void attach(EntityInterface child, dynamic parent, RelationMeta relation) {

    //final abstractParent = "${relation.relatedType}Entity" ;

    for (final t in transformers) {
      if (t.canExtract(parent.runtimeType.toString(), child)) {
        // safe attach, because transformer expects abstract type
        t.attach(child, parent, relation);
    }
  }
  }


  /**
   * Function canExtract
   * Computed dynamically based on the child entity
   **/
  bool canExtract(String parentType,EntityInterface child) {

    List<String>childFields= Entity_Index[child.runtimeType.toString()]!['fields'];
    // String parentType= T.runtimeType.toString();
    print("AllOfTransformer L49, Generic Type: $parentType");
    List<String>parentFields= Entity_Index[parentType]!['fields'];
    print("canExtract? parent=$parentType child=${child.runtimeType} childFields=$childFields parentFields=$parentFields");

    final intersection = childFields.where((f) => parentFields.contains(f)).toList();
    print("canExtract? parent=$parentType child=${child.runtimeType} "
        "commonFields=$intersection");

    return intersection.isNotEmpty;
  }
}
