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
      if ((t as dynamic).canExtract(child)) {
        final data = t.extract(child, relation);
      if (data != null) result.addAll(data);}
    }
    return result;
  }

  @override
  void attach(EntityInterface child, T parent, RelationMeta relation) {
    for (final t in transformers) {
      t.attach(child, parent, relation);
    }
  }

  /**
   * Function canExtract
   * Computed dynamically based on the child entity
   **/
  bool canExtract(EntityInterface parent,EntityInterface child) {

    List<String>childFields= Entity_Index[child.runtimeType.toString()]!['fields'];
    List<String>parentFields= Entity_Index[T.runtimeType.toString()]!['fields'];
    bool res=true;

    for (final f in childFields) {
      if (!parentFields.contains(f)) {
        return false;  // child has a field parent cannot map
      }
    }
    return res;
  }

}
