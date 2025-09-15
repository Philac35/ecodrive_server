import 'package:get_it/get_it.dart';

import '../../Interface/entityInterface.dart';
import '../EntityMapper.dart';
import '../ORM.dart';
import '../PersistenceService/PersistenceServiceInterface.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/DeletableRelationHandlerInterface.dart';
import 'Interface/RelationHandlerInterface.dart';

class BelongsToManyHandler implements DeletableRelationHandler {
  final PersistenceServiceInterface persistence;
  final EntityMapper mapper;
  ORM? orm;

  BelongsToManyHandler (this.persistence,this.mapper,this.orm);


  /// Fetch all related entities for a parent through the join table
  Future<List<EntityInterface?>> getChildren(EntityInterface parent, RelationMeta relation) async {
    final joinTable = relation.joinChildForeignKey; // e.g., the pivot table
    final childType = relation.relatedType;
    final foreignKey = relation.joinParentForeignKey; // parent ID in join table
    final childForeignKey = relation.joinChildForeignKey; // child ID in join table

      Map<String,dynamic> parameters= {foreignKey:parent.id};
      // Get all child IDs from the join table
    final joinRows = await persistence.executor.query(joinTable,
      'SELECT $childForeignKey FROM $joinTable WHERE $foreignKey = :$foreignKey',
      parameters,
    );

    // Fetch each child entity
    final children = <EntityInterface?>[];
    for (final row in joinRows) {
      final id = row[childForeignKey];
      final child = await persistence.findById(childType, id);
      if (child != null) children.add(child);
    }

    return children;
  }

  /// Persist all children and store updated map
  @override
  @override
  Future<EntityInterface?> handle(
      EntityInterface parent,
      RelationMeta relation, {
        Set<String>? persistingTracker,
      }) async {
    final raw = parent.getField(relation.fieldName);
    if (raw == null) return parent;

    final relateds = (raw as List).whereType<EntityInterface>().toList();
    if (relateds.isEmpty) return parent;

    if (parent.id == null) {
      throw StateError(
        "BelongsToManyHandler: parent '${parent.runtimeType}' must be persisted before inserting pivot tuples.",
      );
    }

    // Optional de-duplication
    final seen = <String>{};
    for (final related in relateds) {
      final key = "${related.runtimeType}:${related.id ?? related.hashCode}";
      if (!seen.add(key)) continue;

      // Reuse/upsert if configured
      EntityInterface? persisted;
      if (relation.reuseIfExists) {
        persisted = await persistence.findByFields(relation, related);
        if (persisted != null && relation.updateIfExist) {
          persisted = await persistence.upsert(related, persisted, relation);
        }
      }

      // Persist if needed
      persisted ??= await orm?.persist(related, persistingTracker: persistingTracker);
      if (persisted?.id == null) continue;

      // Insert into pivot using your method
      await persistence.insertPivotTuple(
        relation,
        relation.pivotTable!,                 // make sure RelationMeta has this
        parent.id!,                           // owner
        persisted!.id!,                       // related
      );

      mapper.storeUpdatedMap(persisted);
    }

    return parent;
  }

  @override
  Future<void> delete(EntityInterface entity, RelationMeta relation) async {
    // Explicit: delete all join-table records for this entity
    //ToDebug see if all entities are well deleted
    await persistence.deletePivot(relation, entity.id);
  }
}
