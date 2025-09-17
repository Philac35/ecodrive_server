import 'package:shared_package/BDD/Model/Index/Entity_Index.dart';

import '../../../Interface/entityInterface.dart';
import '../../Relations/RelationMeta.dart';

 abstract class TransformerAbstract<T extends EntityInterface> {
  /// Extracts the data for the parent entity from the child/query
  Map<String, dynamic>? extract(
    EntityInterface child,
    RelationMeta relation,
  );

  /// Attaches the parent entity back into the child
  void attach(
    EntityInterface child,
    T parent,
    RelationMeta relation,
  );


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
