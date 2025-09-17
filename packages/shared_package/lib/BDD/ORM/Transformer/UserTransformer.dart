import '../../Interface/entityInterface.dart';
import '../../Model/AbstractModels/DriverEntity.dart';
import '../../Model/AbstractModels/UserEntity.dart';
import '../../Model/Index/Entity_Index.dart';
import '../Relations/RelationMeta.dart';
import 'Transformer.dart';

class UserTransformer extends Transformer<User> {
  UserTransformer();

  @override
  Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
    final json = child.toJson();
    return json!["person"]?["authUser"];

  }

  @override
  /**
   * Function attach
   * @Param EntityInterface entity
   * @Param EntityInterface parent is a User
   * @Param RelationMeta
   */
  void attach(EntityInterface entity, EntityInterface parent , RelationMeta relation) {
    if (entity is Driver) {
      entity.user = parent as User?;
    }
  }
}
