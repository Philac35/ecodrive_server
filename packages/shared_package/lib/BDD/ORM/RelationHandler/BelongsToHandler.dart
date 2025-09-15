import 'package:get_it/get_it.dart';
import 'package:shared_package/BDD/ORM/EntityMapper.dart';

import '../../Interface/entityInterface.dart';
import '../ORM.dart';
import '../PersistenceService/PersistenceServiceInterface.dart';
import '../Relations/ClassRelation_Index.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/RelationHandlerInterface.dart';

class BelongsToHandler implements RelationHandlerInterface {
  final PersistenceServiceInterface persistence;
  final EntityMapper mapper;
  ORM? orm;

  BelongsToHandler(this.persistence,this.mapper,this.orm);

  @override
  Future<EntityInterface?> handle(
      EntityInterface entity,
      RelationMeta relation,
      {
        Set<String>? persistingTracker,
      }
      ) async {


    final relatedEntity = entity.getField(relation.fieldName);

    if (relatedEntity == null) return null;


    // Try to reuse existing entity if enabled
    EntityInterface? related = relation.reuseIfExists
        ? await persistence.findByFields(relation, entity)
        : null;

    if (related != null && relation.updateIfExist) {
      related = await persistence.upsert(entity, related, relation);
      mapper.storeUpdatedMap(related!);
    }

    // Persist parent through ORM (not persistence directly)
    related ??=  await orm?.persist(
      entity.getField(relation.fieldName),
      persistingTracker: persistingTracker,
    );

    if (related != null) {
      entity.setField(relation.foreignKey, related.id);
      entity.setField(relation.fieldName,null);
      mapper.storeUpdatedMap(related);

      // Apply transformation hook if present
      relation.transformer?.call(entity, related);
    }


    return entity;
  }
}