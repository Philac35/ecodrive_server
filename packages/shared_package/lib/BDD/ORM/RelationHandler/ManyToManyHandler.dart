import '../../Interface/entityInterface.dart';
import '../EntityMapper.dart';
import '../PersistenceService/PersistenceServiceInterface.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/RelationHandlerInterface.dart';
import 'RelationResolver.dart';

class ManyToManyHandler implements RelationHandlerInterface {
  final PersistenceServiceInterface persistence;
  final EntityMapper mapper;
  final RelationResolver resolver; // <-- handles reuseIfExists

  ManyToManyHandler(this.persistence, this.mapper, this.resolver);

  @override
  Future<EntityInterface?> handle(
      EntityInterface entity,
      RelationMeta relation,
  {
  Set<String>? persistingTracker,
  bool cascadeDelete = false}) async {
    // Fetch existing children from join table
    final existingLinks = await persistence.findAllByFields(
      relation,
      {relation.joinParentForeignKey: entity.id},
    );

    final existingChildIds = existingLinks!
        .map((e) => e?.id)
        .whereType<String>()
        .toSet();

    // Get new children from entity
    final childrenToPersist = entity.toJson()![relation.fieldName]
    as List<EntityInterface>? ??
        [];

    // Persist each child using RelationResolver
    final newChildIds = <String>{};
    for (final child in childrenToPersist) {
      // Persist child (reuse if exists)
      final persistedChild = await resolver.reUseIfExist(child, relation);
      if (persistedChild == null) continue;

      newChildIds.add(persistedChild.id!);

      // Insert or ensure link exists in join table
      if (!existingChildIds.contains(persistedChild.id)) {
        await persistence.persistFromMap(
          relation.relatedType , // join table name  . It would like to had + '_Join'
          {
            relation.joinParentForeignKey: entity.id,
            relation.joinChildForeignKey: persistedChild.id,
          },
        );
      }

      mapper.storeUpdatedMap(persistedChild);
    }

    // Optional cascade delete: remove orphan links
   /* if (cascadeDelete) {
      final orphanIds = existingChildIds.difference(newChildIds);
      for (final orphanId in orphanIds) {
        await persistence.delete(
          relation.relatedType , // It would like to had + '_Join'
          '${relation.joinParentForeignKey} = ? AND ${relation.joinChildForeignKey} = :${relation.joinChildForeignKey}',
          [entity.id, orphanId],
        );
      }
    }*/

    return entity;
  }
}
