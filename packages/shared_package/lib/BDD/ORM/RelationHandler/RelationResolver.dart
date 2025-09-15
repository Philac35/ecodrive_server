
import 'package:shared_package/BDD/ORM/RelationHandler/Interface/RelationHandlerInterface.dart';

import '../../Interface/entityInterface.dart';
import '../PersistenceService/CTIPersistenceService.dart';
import '../Relations/RelationMeta.dart';

class RelationResolver {

  /*
  * final resolver = RelationResolver({
  * RelationType.belongsTo: BelongsToHandler(persistence, mapper),
  * RelationType.hasMany: HasManyHandler(persistence, mapper),
  * RelationType.isA: IsAHandler(persistence, mapper), // <---
  * });
  * Notion of Combinator for entities's fields to see : OneOf, AllOf, AnyOf
  **/

  final Map<RelationType, RelationHandlerInterface> handlers;
  CTIPersistenceService persistence;
  RelationResolver(this.handlers, this.persistence);

  Future<EntityInterface?> resolve(
      EntityInterface entity,
      RelationMeta relation,{
        Set<String>? persistingTracker,
      }
      ) async {
    final handler = handlers[relation.type];
    if (handler == null) {
      throw UnimplementedError(
        "No handler found for relation: ${relation.type}",
      );
    }
    return handler.handle(entity, relation,
     persistingTracker:persistingTracker!
    );
  }


  Future<EntityInterface?> reUseIfExist(
      EntityInterface entity,
      RelationMeta relation,
      ) async {
    // 1. Try to find existing entity
    final existing = await _findExisting(entity, relation);

    if (existing != null) {
      return relation.updateIfExist
          ? await _updateExisting(entity, existing, relation)
          : existing;
    }

    // 2. Otherwise, persist new
    return await _createNew(entity, relation);
  }

  Future<EntityInterface?> _findExisting(
      EntityInterface entity, RelationMeta relation) async {
    return await persistence.findByFields(relation, entity);
  }

  Future<EntityInterface?> _updateExisting(
      EntityInterface newEntity,
      EntityInterface existing,
      RelationMeta relation) async {
    return await persistence.upsert(newEntity, existing, relation);
  }

  Future<EntityInterface?> _createNew(
      EntityInterface entity, RelationMeta relation) async {
    return await persistence.persist(entity);
  }

  updatedIfExist(){}
  /*Move all relation handling (reuseIfExist, updateIfExist, relation replacement logic) into RelationResolver.
  Use EntityMapper + PersistenceService inside.*/

}