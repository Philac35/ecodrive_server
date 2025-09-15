import 'package:get_it/get_it.dart';

import '../../Interface/entityInterface.dart';
import '../EntityMapper.dart';
import '../ORM.dart';
import '../PersistenceService/PersistenceServiceInterface.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/DeletableRelationHandlerInterface.dart';


class HasManyHandler implements DeletableRelationHandler {
  final PersistenceServiceInterface persistence;
  final EntityMapper mapper;

  ORM? orm;
  HasManyHandler(this.persistence,this.mapper,this.orm);

  /**
   * getChildren
   * @Param EntityInterface entity
   * @Param RelationMeta relation
   * @Return Future<List<EntityInterface?>>
   * /!\ It doesn't fetch all children
   */
  Future<List<EntityInterface?>> getChildren(EntityInterface entity, RelationMeta relation) async {
    List<EntityInterface?> children = [];

    // Assuming `relation.foreignKey` is the field in child pointing to parent
    final whereMap = { relation.foreignKey : entity.id };

    // persistence.findAllByFields should return a list of children
    final childList = await persistence.findAllByFields(relation, whereMap);

    children.addAll(childList!);

    return children;
  }



  @override
  Future<EntityInterface?> handle(
      EntityInterface parent,
      RelationMeta relation, {
        Set<String>? persistingTracker,
      }) async {
    // Expect a List<EntityInterface> on the relation field
    final raw = parent.getField(relation.fieldName);
    if (raw == null) return parent;

    final children = (raw as List).whereType<EntityInterface>().toList();
    if (children.isEmpty) return parent;

    // Parent must already be persisted by the time children cascade runs.
    if (parent.id == null) {
      throw StateError(
        "HasManyHandler: parent '${parent.runtimeType}' must be persisted before cascading children.",
      );
    }

    // Optional: de-duplicate children by (type,id or identity)
    final seen = <String>{};
    List<EntityInterface> uniqueChildren = [];
    for (final c in children) {
      final key = "${c.runtimeType}:${c.id ?? c.hashCode}";
      if (seen.add(key)) uniqueChildren.add(c);
    }

    for (final child in uniqueChildren) {
      // 1) Set FK on child (parent → child)
      child.setField(relation.foreignKey, parent.id);

      // 2) Remove embedded back-reference if present to avoid loops
      final json = child.toJson();
      if (json != null && json.containsKey(relation.fieldName)) {  // Instead of child.hasField(relation.fieldName)
        child.setField(relation.fieldName, null);
      }



      // 3) Reuse / upsert if configured
      EntityInterface? persisted;
      if (relation.reuseIfExists) {
        persisted = await persistence.findByFields(relation, child);
        if (persisted != null && relation.updateIfExist) {
          persisted = await persistence.upsert(child, persisted, relation);
        }
      }

      // 4) Persist if not found via reuse
      persisted ??= await orm?.persist(
        child,
        persistingTracker: persistingTracker,
      );

      if (persisted != null) {
        mapper.storeUpdatedMap(persisted);
      }
    }

    return parent;
  }


  @override
  Future<void> delete(EntityInterface entity, RelationMeta relation) async {
    final children = await persistence.findAllByFields(relation, entity.toJson()!);
    for (final child in children!) {
      await persistence.delete(child!);
    }
  }


}

