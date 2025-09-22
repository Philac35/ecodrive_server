import '../../Interface/entityInterface.dart';
import '../EntityMapper.dart';
import '../ORM.dart';
import '../PersistenceService/PersistenceServiceInterface.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/RelationHandlerInterface.dart';
import 'RelationResolver.dart';
import 'package:shared_package/Library/StringLibrary/str_extension.dart';




class ManyToManyHandler implements RelationHandlerInterface {
  final PersistenceServiceInterface persistence;
  final EntityMapper mapper;
   RelationResolver? resolver; // <-- handles reuseIfExists
   ORM orm;
 ManyToManyHandler(this.persistence, this.mapper, this.orm);
  //ManyToManyHandler (this.persistence,this.mapper,this.orm);

  @override
  Future<EntityInterface?> handle(
      EntityInterface entity,
      RelationMeta relation,{
        Set<String>? persistingTracker,
        bool cascadeDelete = false}) async {

    String joinParentfk=(relation.joinParentForeignKey as String ).snakeToCamel();
    // Fetch existing children from join table
    final existingLinks = await persistence.findAllByFields(
      relation,
      {joinParentfk: entity.getField(joinParentfk)},  //This available for Driver> parent User
    );
    resolver= RelationResolver(orm.relationHandlers,persistence);
   //For reuseIfExist
    List existingChildIds = existingLinks!=null? existingLinks:[]
        .map((e) => e?.id)
        .whereType<String>()
        .toList();

    // Get new children from entity
    final childrenToPersist = entity.getField(relation.fieldName);
    /* or final childrenToPersist = entity.toJson()![relation.fieldName]
    as List<EntityInterface>? ??   -> pb it can be a raw of ids not entities themselves
        [];
   */

    // Persist each child using RelationResolver
    // Get new children from entity

    List newChildIds = <String>[];

    //If childrenToPersist is a list of entities
    if (childrenToPersist is List<EntityInterface>) {
      for (final child in childrenToPersist) {
        final persistedChild = await resolver!?.reUseIfExist(child, relation);  //Persist Child
        if (persistedChild == null) continue;

        newChildIds.add(persistedChild.id!);

        //Persist Pivot reference.
        if (!existingChildIds.contains(persistedChild.id)) {
               await persistence.insertPivotTuple(relation, entity.id, persistedChild.id);

        }

        mapper.storeUpdatedMap(persistedChild);
      }
    }
      // If childrenToPersist is a list of IDs (int or string)
    else if (childrenToPersist is List) {
      for (final childId in childrenToPersist) {
        final idStr = childId.toString();
        newChildIds.add(idStr);



        if (!existingChildIds.contains(idStr)) {
          //persist relation.joinParentForeignKey and    relation.joinChildForeignKey
          await persistence.insertPivotTuple(relation, entity.id, idStr);
          }
      }
    }



    for (final child in childrenToPersist) {
      // Persist child (reuse if exists)
      final persistedChild = await resolver!.reUseIfExist(child, relation);
      if (persistedChild == null) continue;

      newChildIds.add(persistedChild.id!);

      // Insert or ensure link exists in join table
      if (!existingChildIds.contains(persistedChild.id)) {
        //persist relation.joinParentForeignKey and    relation.joinChildForeignKey
        String ownerId=entity.id;

        var entityType=entity.runtimeType.toString();
        ownerId = mapper.getUpdatedMap(entity)![(relation.joinParentForeignKey as String).snakeToCamel()].toString() ;  //For an other entity joinParentFK could be entity itself instead of super, It wouldn't matter.
        await persistence.insertPivotTuple(relation, int.parse(ownerId), persistedChild.id);  //for driver user_id  is entity.user.id not entity.id
      }

      mapper.storeUpdatedMap(persistedChild);
    }

    // Optional cascade delete: remove orphan links/obsolete join rows
     if (cascadeDelete) {
      final orphanIds = existingChildIds.toSet().difference(newChildIds.toSet());
      for (final orphanId in orphanIds) {
        await persistence.deletePivotTuple(
          relation,
          entity.id,  //relation.joinParentForeignKey
          orphanId,   // relation.joinChildForeignKey
        );

       /*   {
          '${relation.joinParentForeignKey} = ? AND ${relation.joinChildForeignKey} = :${relation.joinChildForeignKey}',
          [entity.id, orphanId]
          }*/

      }
    }

    return entity;
  }




//Don't take care of list of ids
@override
  Future<EntityInterface?> handle_V1(
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
      final persistedChild = await resolver!.reUseIfExist(child, relation);
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


/*
* class ManyToManyHandler implements RelationHandlerInterface {
  final CTIPersistenceService persistence;

  ManyToManyHandler(this.persistence);

  @override
  Future<EntityInterface?> handle(
      EntityInterface entity,
      RelationMeta relation, {
        Set<String>? persistingTracker,
      }) async {

    final joinTable = relation.joinEntity; // ex: UserNoticesMtoMEntity
    final ids = entity.getField(relation.fieldName); // noticesIdList

    if (ids != null && ids is List<int>) {
      for (final noticeId in ids) {
        final joinEntity = joinTable()
          ..setField('user_id', entity.id)
          ..setField('notice_id', noticeId);
        await persistence.persist(joinEntity);
      }
    }

    return entity;
  }
}
*/