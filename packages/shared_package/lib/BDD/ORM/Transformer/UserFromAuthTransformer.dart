import '../../Interface/entityInterface.dart';
import '../../Model/AbstractModels/DriverEntity.dart';
import '../../Model/AbstractModels/UserEntity.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/TransformerAbstract.dart';

class UserFromAuthTransformer extends TransformerAbstract<User> {
  @override
  Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
    final json = child.toJson();
    return json!["person"]?["authUser"];
  }

  @override
  void attach(EntityInterface child, User parent, RelationMeta relation) {
    if (child is Driver) {
      child.user = parent;
    }
  }
}