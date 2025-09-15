import '../../../Interface/entityInterface.dart';
import '../../Relations/RelationMeta.dart';
import './RelationHandlerInterface.dart';

/// Relation handlers that support delete cascade implement this.
abstract interface class DeletableRelationHandler implements RelationHandlerInterface {
  Future<void> delete(EntityInterface entity, RelationMeta relation);
}
