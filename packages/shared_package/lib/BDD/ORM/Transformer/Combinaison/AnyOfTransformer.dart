import '../../../Interface/entityInterface.dart';
import '../../Relations/RelationMeta.dart';
import '../Interface/TransformerCombinator.dart';
import 'package:shared_package/BDD/Model/Index/Entity_Index.dart';

/**
 * Class AnyOfTransformer
 * apply whichever transformer succeed, then combine loosely
 */
class AnyOfTransformer<T extends EntityInterface>
    extends TransformerCombinator<T> {
  AnyOfTransformer(super.transformers);

  @override
  Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
    final results = transformers
        .map((t) {
           // Try to extract only if canExtract returns true
            if ((t as dynamic).canExtract(child, child)) {
               return t.extract(child, relation);
             }
           return null; // Return null if not extracted
          })
        .whereType<Map<String, dynamic>>()    // Filter out nulls, keep only maps
        .toList();
    if (results.isEmpty) return null;
    return results.reduce((a, b) => a..addAll(b));
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
