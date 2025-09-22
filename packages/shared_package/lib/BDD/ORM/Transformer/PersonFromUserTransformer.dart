import '../../Interface/entityInterface.dart';
import '../../Model/Abstract/PersonEntity.dart';
import '../../Model/AbstractModels/UserEntity.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/TransformerAbstract.dart';
import 'Transformer.dart';

class PersonFromUserTransformer extends TransformerAbstract<User>{

  @override
  Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
    final json = child.toJson();
    return json!["person"];
  }

  @override
  void attach(EntityInterface child, dynamic parent, RelationMeta relation) {
    if (child is User) {
      child.person = parent;
    }
  }
}