import '../../../Interface/entityInterface.dart';
import '../../Relations/RelationMeta.dart';
import '../Interface/TransformerCombinator.dart';
import 'package:shared_package/BDD/Model/Index/Entity_Index.dart';

/**
 * Class OneOfTransformer
 * use the first transformer that matches/extracts data.
 *
 * Usage :
 * final transformers = {
 *   User: OneOfTransformer([
 *   UserTransformer(),       // tries to extract from person.authUser
 *   LegacyUserTransformer(), // maybe from another schema path
 *  ]),
 *   Person: PersonTransformer(),
 *   };
 */
class OneOfTransformer<T extends EntityInterface>
    extends TransformerCombinator<T> {
  OneOfTransformer(super.transformers);

  @override
  Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
    for (final t in transformers) {
      if ((t as dynamic).canExtract(relation.relatedType, child)) {
      final data = t.extract(child, relation);
      if (data != null && data.isNotEmpty) {
        return data;
      }}
    }
    return null;
  }

  @override
  void attach(EntityInterface child,dynamic parent, RelationMeta relation) {
    for (final t in transformers) {
      try {
        t.attach(child, parent, relation);
        return; // stop after first success
      } catch (_) {
        // ignore and continue
      }
    }
  }

  /**
   * Function canExtract
   * Computed dynamically based on the child entity
   **/
  bool canExtract(String parentType,EntityInterface child) {

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
