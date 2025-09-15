
import 'package:shared_package/BDD/Executor/MysqlPoolExecutor.dart';
import 'package:shared_package/BDD/ORM/PersistenceService/CTIPersistenceService.dart';
import 'package:shared_package/BDD/ORM/RelationHandler/BelongsToHandler.dart';
import 'package:shared_package/BDD/ORM/RelationHandler/RelationResolver.dart';
import 'package:shared_package/BDD/ORM/Relations/ClassRelation_Index.dart';
import 'package:shared_package/Services/BDDService/BDDService.dart';

import '../../Library/StringLibrary/string_librairy.dart';
import '../Interface/entityInterface.dart';
import '../Model/Index/Entity_Index.dart';
import 'PersistenceService/PersistenceServiceInterface.dart';
import 'RelationHandler/BelongsToManyHandler.dart';
import 'RelationHandler/HasManyHandler.dart';
import 'RelationHandler/HasOneHandler.dart';
import 'RelationHandler/Interface/DeletableRelationHandlerInterface.dart';
import 'RelationHandler/Interface/RelationHandlerInterface.dart';
import 'RelationHandler/IsAHandler.dart';

import 'EntityMapper.dart';
import 'Relations/RelationMeta.dart';

/// ORM orchestrates persistence + relation handling
class ORM {
  late PersistenceServiceInterface persistence;
  EntityMapper mapper;
  late final Map<RelationType, RelationHandlerInterface> relationHandlers;
  // Tracker for the current persist operation
  Set<String> _persistingTracker = {};


  ORM( this.mapper,this.persistence){
         //mapper= EntityMapper();
         relationHandlers = {
           RelationType.belongsTo: BelongsToHandler(persistence,mapper,this),
           RelationType.hasOne: HasOneHandler(persistence, mapper,this),
           RelationType.hasMany: HasManyHandler(persistence, mapper,this),
           RelationType.belongsToMany: BelongsToManyHandler(persistence, mapper,this),
           RelationType.isA: IsAHandler(persistence, mapper,this),
         };

  }


  String keyTracker="";
  /// Persist an entity and its relations
  Future<EntityInterface?> persist(EntityInterface entity,{
  Set<String>? persistingTracker,
  }) async {
    persistingTracker ??= {};

  String entityType = entity.runtimeType.toString();


   //Check is already persisted in BDD and in EntityMapper
    final isAlreadyPersisted = entity.id != null || mapper.hasPersistedEntityMap(entity);
    if (_persistingTracker.contains(keyTracker) && isAlreadyPersisted) {
      return entity; // already being persisted → prevent loop
    }else{
      //Avoid infinite boucle cause of already persisted Entity
      String keyTracker=createKeyTracker(entity);
      _persistingTracker.add(keyTracker);
      mapper.storeUpdatedMap(entity);
    }

// Check if entity is known in index
 try{
    final meta = Entity_Index[entityType];  // relations are not in Entity_Index
    if (meta == null) throw Exception("Unknown entity type: ${entity.runtimeType}");


    //Search related relations
    final relations = ClassRelationsIndex[entityType] as List<RelationMeta>? ?? [];

     //handle parent's entities with belongsTo, IsA relations
     await cascadeParent(entity, relations, persistingTracker: persistingTracker);


    // 2) Persist the main entity with updated foreignKeys
    EntityInterface? persistedEntity;
    if (!isAlreadyPersisted) {
      persistedEntity = await persistence.persist(entity);  // Informations of authUser are ereased in persistedEntity
      if (persistedEntity != null) {

        mapper.storeUpdatedMap(persistedEntity!);
      }
    } else {

      persistedEntity = entity; // already persisted
    }



    //handle children's entities with hasOne, hasMany, belongsToMany, manyToMany
    await cascadeChildren(persistedEntity!, relations,persistingTracker: persistingTracker);


    // Step 3: update cache
    mapper.storeUpdatedMap(persistedEntity!);
    return persistedEntity;
    }  catch(e,s){print("ORM L99 Persist, error : $e \n Stack:$s");}
    finally {
       // _persistingTracker.remove(keyTracker);
  }
  }




  // Cascade parents (belongsTo / base entities)
 Future<void>  cascadeParent(entity,relations, {required Set<String> persistingTracker})async {

   for (final relation in relations.where((r) =>
    r.type == RelationType.belongsTo || r.type == RelationType.isA)) {
      final handler = relationHandlers[relation.type];
      if (handler != null) {
        final entityUpdated= await handler.handle(entity, relation, persistingTracker: _persistingTracker);
/*
        // Update foreign keys after parent persist
        if (entityUpdated != null && entityUpdated.id!=null) {
          // Update the actual entity field, not the JSON map
          entity.setField(StringLib.snakeToCamel(relation.foreignKey), int.parse(persistedParent.id));

          // Persist the updated entity in the DB
          if( entity.id!=null){ await persistence.update(entityUpdated);}  // /!\ id must be set otherwise it update all entities
   // as here user doesn't have id , it update all the fields
          // Update the ORM cache to reflect this change*/
        if(entityUpdated!=null) mapper.storeUpdatedMap(entityUpdated);

      }
    }

  }
  /// Helper: Get related entity ID after parent persist
  Future<dynamic> getRelatedEntityId(EntityInterface entity, RelationMeta relation) async {
    final relatedEntity = entity.toJson()?[relation.fieldName] as EntityInterface?;
    return relatedEntity?.id;
  }

  // Cascade children (hasOne, hasMany, belongsToMany,manyToMany)
  Future<void> cascadeChildren(
      EntityInterface entity,
      List<RelationMeta> relations, {
        required Set<String> persistingTracker,
      }) async {
    for (final relation in relations.where((r) =>
    r.type == RelationType.hasOne ||
        r.type == RelationType.hasMany ||
        r.type == RelationType.belongsToMany ||
        r.type == RelationType.manyToMany)) {

      final value = entity.getField(relation.fieldName);
      if (value == null) continue;

      // ---------------------------
      // hasOne
      // ---------------------------
      if (relation.type == RelationType.hasOne && relation.foreignKey != null) {
        final child ;

        final fromMap = Entity_Index[relation.relatedType]['fromMap'] as Function;
         if(value is Map){child= fromMap(value);}
          else{ child= value as EntityInterface;}

        if (child.getField(relation.relatedKey) == null) { //relation.foreignKey was changed.
          child.setField(relation.relatedKey, entity.id);
        }
        final handler = relationHandlers[relation.type];
        if (handler != null) {
          final persistedChild = await handler.handle(
            child,
            relation,
            persistingTracker: persistingTracker,
          );
          if (persistedChild != null) {
            await persistence.update(persistedChild);
            mapper.storeUpdatedMap(persistedChild);
          }
        }
      }

      // ---------------------------
      // hasMany
      // ---------------------------
      if (relation.type == RelationType.hasMany && relation.foreignKey != null) {
        final rawChildren = value as List?;
        if (rawChildren == null) continue;

        final children = rawChildren.map((child) {
          if (child is EntityInterface) {
            return child;
          } else if (child is Map<String, dynamic>) {
            final relatedType = relation.relatedType;
            final fromMap = Entity_Index[relatedType]['fromMap'] as Function;
            return fromMap(child) as EntityInterface;
          } else {
            throw StateError("Unexpected child type in hasMany: ${child.runtimeType}");
          }
        }).toList();

        for (final child in children) {
          if (relation.foreignKey != null && child.getField(relation.foreignKey) == null) {
            child.setField(relation.foreignKey, entity.id);
          }

          final handler = relationHandlers[relation.type];
          if (handler != null) {
            final persistedChild = await handler.handle(
              entity,
              relation,
              persistingTracker: persistingTracker,
            );
            if (persistedChild != null) {
              await persistence.update(persistedChild);
              mapper.storeUpdatedMap(persistedChild);
            }
          }
        }
      }

      // ---------------------------
      // belongsToMany / manyToMany
      // ---------------------------
      if (relation.type == RelationType.belongsToMany ||
          relation.type == RelationType.manyToMany) {
        final handler = relationHandlers[relation.type];
        if (handler != null) {
         var toManychild= await handler.handle(
            entity,
            relation,
            persistingTracker: persistingTracker,
          );
         if (toManychild != null) {
           // For hasOne / hasMany: update FK in child
           if (relation.type == RelationType.hasOne || relation.type == RelationType.hasMany) {
             toManychild.setField(relation.foreignKey, entity.id);
             await persistence.update(toManychild);
             mapper.storeUpdatedMap(toManychild);
           }
         }
        }
      }
    }
  }



  /// Delete entity, with optional cascade
  Future<bool> delete(EntityInterface entity, {bool cascade = false}) async {
    final meta = Entity_Index[entity.runtimeType.toString()];
    final relations = meta?['relations'] as List<RelationMeta>? ?? [];

    if (cascade) {
      for (final relation in relations) {
        final handler = relationHandlers[relation.type];
        if (handler != null && handler is DeletableRelationHandler) {
          await handler.delete(entity, relation);
        }
      }
    }

   return await persistence.delete(entity);
  }


//Helper

  String createKeyTracker(EntityInterface entity){
    String keyTracker;
    if (entity.id != null) {
      keyTracker = "${entity.runtimeType}:#${entity.id}";  // DB id → already persisted
    } else {
      keyTracker = "${entity.runtimeType}@temp${entity.hashCode}";  // temporary key
    }
    print("ORM L274 created tracker: $keyTracker");
    return   keyTracker;
  }


}
