import 'package:angel3_orm/angel3_orm.dart';

import 'package:mysql_client/mysql_client.dart';
import 'package:shared_package/BDD/Connection/MysqlConnection.dart';
import 'package:shared_package/Controller/Index/Index_ControllerFunction.dart';
import 'package:shared_package/Controller/Index/Controller_index.dart';
import '../../Controller/Controller.dart';

import '../../Library/StringLibrary/string_librairy.dart';
import '../Executor/MysqlPoolExecutor.dart';

import 'Relations/ClassRelation_Index.dart';
import '../Interface/entityInterface.dart';
import '../Model/Index/Entity_Index.dart';
import 'package:shared_package/Library/StringLibrary/str_extension.dart';

import 'Relations/RelationMeta.dart';

class ORMSaved{
  Map<String, dynamic> controllerIndex;
  Map<String, dynamic> entityIndex;
  Map<String, dynamic> classRelationsIndex;

  //TODO Implement Transactions, Use to save preformed queries in the cascading system to make transactions. Ids must be managed Correctly
  //Map <String, dynamic> transactionContext;

  EntityInterface? relatedPersisted;
  late Map<String, Map<String, dynamic>> updatedMaps;

  MySQLConnectionPool? connexionPool;
  QueryExecutor? executor;

  ORMSaved()
      : entityIndex = Entity_Index,
        classRelationsIndex = ClassRelationsIndex,
        controllerIndex = ControllerIndex {
    initMySqlPoolConnection();
    executor = MySqlPoolExecutor(connexionPool!);

    updatedMaps = {};
  }

  initMySqlPoolConnection() {
    MysqlConnection c = MysqlConnection();
    connexionPool = c.connectPool();
  }

  //ORM Angel3 Persist Logic
  //Implementation persist Entity with cascading abilities
  Future<EntityInterface?> persist(EntityInterface entity) async {
    storeUpdatedMap(entity);
    final relations = getRelations(entity);

        print("ORM L52 ,persist , Entity to persist : ${entity.runtimeType.toString()} ");


    // Cascade parents (belongsTo )
    await cascadeParentsR(entity, relations);

    // Handle isA (inheritance)
    final superEntity = await isAwReuse(entity, relations);
    if (superEntity != null) {
      // The super entity is now persisted; update the child's foreign key
      final foreignKey =
          relations.firstWhere((r) => r.type == RelationType.isA).foreignKey;
      final updatedMap = getUpdatedMap(entity)!;
      updatedMap[foreignKey] = superEntity.id;
    }

    // Persist the main entity
    final persistedEntity = await save(relations, entity);
    if (persistedEntity == null) return null;

    // Cascade children (hasOne, hasMany, belongsToMany)
    await _cascadeChildren(relations, persistedEntity);

    return persistedEntity;
  }

  Future<EntityInterface?> persist2(EntityInterface entity) async {
    //print("ORM L40, entity:  ${entity}");
    // _getOrAssignKey(entity);
    storeUpdatedMap(entity!);

    var relations = getRelations(entity!);

    // Parents (belongsTo / hasOne)
    await cascadeParentsR(entity!, relations);

    //Reify entity to be sur of Type
    final entityType = entity.runtimeType.toString();
    final fromMap = entityIndex[entityType]['fromMap'] as Function;

    var persistedisEntity =
        await isAwReuse(fromMap(getUpdatedMap(entity)), relations);
    print("ORM L59, PersistedIsEntity :$persistedisEntity");

    EntityInterface? persistedEntity =
        await save(relations, entity); // //Peut avoir été updated
    if (persistedEntity != null) {
      replaceKey(entity, persistedEntity);
    } else {
      return null;
    }

    //After main entity insert we manage child Entities and check each relations:
    _cascadeChildren(relations, persistedEntity);

    //After all entries exist
    await manyToMany(relations, persistedEntity);
    await belongsToMany(relations, persistedEntity);

    return persistedEntity;
  }

  Future<void> _cascadeChildren(relations, persistedEntity) async {
    await hasOne(relations, persistedEntity);
    await hasMany(relations, persistedEntity);
  }

  /**
   * Function getRelations
   * @Param dynamic (can be an entity or its String name or entity Type)
   */
  getRelations(dynamic entity) {
    var entityType;
    if (entity is EntityInterface) {
      print("ORM L123, getRelations works with Type");
      entityType = entity.runtimeType.toString();
    } else {
      print("ORM L126, getRelations works with String");
      entityType = StringLib().firstToUpperCase(entity);
    }
    print("ORM L125, entity:  ${entityType}");
    //print("ORM L123, entity:  ${StringLib().firstToUpperCase(entityType)}");
    final relations = classRelationsIndex[entityType] ?? [];
    print("ORM L131, relations:  ${relations}");
    return relations;
  }

  RelationMeta? getRelationForKey(String key) {
    // /!\  In relation for key authUser. must be Fuppercase and we find person

    var relations = getRelations(key);
    if (key == "authUser") {
      key = "person";
    }
    print(
        "ORM L134, ensemble des relations relatives à  ${key}:  ${relations.toString()}");
    try {
      print("ORM L136, relations:  ${key}");
      return relations.firstWhere(
        (rel) => rel.fieldName == key || rel.foreignKey == key,
      );
    } catch (e) {
      // No matching relation found
      return null;
    }
  }

  RelationMeta? getRelationForKey2(EntityInterface entity, String key) {
    // /!\  In relation for key authUser. must be Fuppercase and we find person

    print("ORM L134, relations:  ${key}");
    var relations = getRelations(entity);
    print("ORM L134, relations:  ${relations}");
    try {
      print("ORM L136, relations:  ${key}");
      return relations.firstWhere(
        (rel) => rel.fieldName == key || rel.foreignKey == key,
      );
    } catch (e) {
      // No matching relation found
      return null;
    }
  }

  /**
   * Function save
   * @Param relations
   * @Param EntityInterface entity
   */
  Future<EntityInterface?> save(
      List<RelationMeta> relations, EntityInterface entity) async {
    final entityType = entity.runtimeType.toString();

    // Map<String, dynamic> entityMap = entity.toJson();
    //updatedMap = Map<String, dynamic>.from(entityMap);
    mergeMapsDeep(getUpdatedMap(entity)!, convertMap(entity.toJson()!));

    // print("ORM L53, entity:  ${updatedMap}");
    // Main entity save (can be updated in cascadingParent)
    final fromMap = entityIndex[entityType]['fromMap'] as Function;
    var updatedEntity = fromMap(getUpdatedMap(entity)!);
    print('ORM L134, debug, updatedEntity : $updatedEntity!');
    var a = await isAwReuse(updatedEntity, relations)!;

    if (a != null) {
      // replaceKey(updatedEntity, a); //This replace the child Type by parent Type and cause pbs
      // Do not updatedEntity= a;
    } else {
      return null;
    }

    print('ORM L144, debug, superEntity :  $updatedEntity!');

    final controller = controllerIndex["${entityType}Controller"]?.call();

    if (controller == null) {
      print('ORM L149 ERROR: No controller found for $entityType!');
      throw Exception('No controller found for $entityType');
    }

    await controller.initRepository();

    var persistedEntity = await controller.save(updatedEntity);

    // delete related field
    String relatedType = a.runtimeType.toString().toLowerCase();
    var entityMap = persistedEntity.toJson();
    entityMap[relatedType] = null;

    persistedEntity = fromMap(entityMap);
    replaceKey(persistedEntity, persistedEntity);

    // Ensure the persisted entity has an ID
    if (persistedEntity == null || persistedEntity.id == null) {
      throw Exception('ORM L159, Failed to persist $entityType: ID is null');
    }

    // Update the updatedMaps with the new ID
    final persistedMap = persistedEntity.toJson()!;

    updatedMaps[getOrAssignKey(persistedEntity)] = persistedMap;

    print('ORM L180, Main Entity Persisted in DB: $persistedEntity');

    return persistedEntity;
  }

  /**
   * Function cascadeParentsSaved
   * Parents (belongsTo / hasOne)
   * Save entities related return updatedMap of parent Entities
   */
  Future<void> cascadeParentsSaved(
      EntityInterface entity, Iterable relations) async {
    for (final rel in relations.where((r) =>
        r.type == RelationType.belongsTo || r.type == RelationType.hasOne)) {
      final relatedType = rel.relatedType;

      final entityIndexEntry = Entity_Index[relatedType];
      if (entityIndexEntry == null) continue;
      final relatedFromMap = entityIndexEntry['fromMap'] as Function;
      //print("ORM L92, related entity ${relatedFromMap} ");
      var related = getUpdatedMap(entity)![rel.fieldName];

      //print("ORM L95, related entity ${related.runtimeType.toString()} belongsTo}");

      if (related != null) {
        if (related is Map) related = relatedFromMap(related);
        EntityInterface? relatedPersisted;
        var relatedController =
            controllerIndex["${relatedType}Controller"]?.call();
        if (relatedController != null) {
          await relatedController.ready;

          //ReuseIfExits -> reuse child in parent record if it preexist
          if (rel.reuseIfExists && rel.findBy.isNotEmpty) {
            final lookupMap = <String, dynamic>{};
            for (final key in rel.findBy) {
              lookupMap[key] = (related as dynamic).toJson()[key];
            }
            final existing = await relatedController.findByFields(lookupMap);
            print("ORM 118 findByFields ${existing}");
            if (existing != null) {
              getUpdatedMap(entity)![rel.foreignKey] = existing.id;
              getUpdatedMap(entity)![rel.fieldName] =
                  null; //The related entity was persisted, we delete the content of rel.fieldName
              relatedPersisted = existing;
            } else {
              print(
                  "ORM L124, No entity was found with findByFields we persist bared related Entity");
              relatedPersisted = await persist(related);
            }
            print(
                "ORM L275, Reuse related entity ${related.runtimeType.toString()}");
          } else {
            print(
                "ORM L130, related entity ${related.runtimeType.toString()} persist triggered}");
            relatedPersisted = await persist(related);
          }

          print('ORM: L282 relatedPersisted or Reused $relatedPersisted');

          // Update map: set the FK to parent id, remove nested object
          final parentJson = (relatedPersisted as dynamic)!.toJson();
          final parentId = parentJson['id'];
          var map = getUpdatedMap(entity!)!;
          map![rel.foreignKey] = parentId;
          map![rel.fieldName] = null;
        }
      }
    }
  }

  /**
   * Function cascadeParents
   * Parents (belongsTo / hasOne)
   * Save entities related return updatedMap of parent Entities
   */
  Future<void> cascadeParents(
      Iterable relations, EntityInterface entity) async {
    for (final rel
        in relations.where((r) => r.type == RelationType.belongsTo)) {
      final relatedType = rel.relatedType;

      final entityIndexEntry = Entity_Index[relatedType];
      if (entityIndexEntry == null) continue;
      final relatedFromMap = entityIndexEntry['fromMap'] as Function;
      //print("ORM L92, related entity ${relatedFromMap} ");
      var related = getUpdatedMap(entity)![rel.fieldName];

      //print("ORM L95, related entity ${related.runtimeType.toString()} belongsTo}");

      if (related != null) {
        if (related is Map) related = relatedFromMap(related);
        EntityInterface? relatedPersisted;
        var relatedController =
            controllerIndex["${relatedType}Controller"]?.call();
        if (relatedController != null) {
          await relatedController.ready;

          print(
              "ORM L130, related entity ${related.runtimeType.toString()} persist triggered}");
          relatedPersisted = await persist(related);

          print('ORM: L120 relatedPersisted or Reused $relatedPersisted');

          // Update map: set the FK to parent id, remove nested object
          final parentJson = (relatedPersisted as dynamic)!.toJson();
          final parentId = parentJson['id'];
          var map = getUpdatedMap(entity);
          map![rel.foreignKey] = parentId;
          map![rel.fieldName] = null;
        }
      }
    }
  }

  /**
   * Function cascadeParentsR
   * With ReuseIfExist
   * Parents (belongsTo )
   * Save entities related return updatedMap of parent Entities
   */
  Future<void> cascadeParentsR(
      EntityInterface entity, Iterable relations) async {
    for (final rel
        in relations.where((r) => r.type == RelationType.belongsTo)) {
      final relatedType = rel.relatedType;

      if (relatedType == 'AuthUser') {
        print("ORM L233,CascadeParents AuthUser will be persisted");
      }

      final entityIndexEntry = Entity_Index[relatedType];

      if (entityIndexEntry == null) {
        continue;
      } else {
        print("ORM L237, CascadeParents $relatedType");
      }
      final relatedFromMap = entityIndexEntry['fromMap'] as Function;
      //print("ORM L92, related entity ${relatedFromMap} ");

      //Fetch fields of entity from updatedMap;
      var map = getUpdatedMap(entity!);
      print("ORM L254, updatedMap : $map");
      print("ORM L255, updatedMap : ${entity.toString()}");
      var related = getUpdatedMap(entity)![
          rel.fieldName]; //here updatedMap is related to Main Entity not Child

      //print("ORM L208,debug related entity ${related.runtimeType.toString()} belongsTo}");
      if (relatedType == 'AuthUser') {
        print("ORM L243,CascadeParents AuthUser :$related");
      }
      if (related != null) {
        if (related is Map) related = relatedFromMap(related);
        EntityInterface? relatedPersisted;

        //ReuseIfExits -> reuse child in parent record if it preexist
        relatedPersisted = await reUseIfExist(related, rel);

        print('ORM: L120 relatedPersisted or Reused $relatedPersisted');

        // Update map: set the FK to parent id, remove nested object
        final relatedJson = (relatedPersisted as dynamic)!.toJson();
        final relatedId = relatedJson['id'];
        var map = getUpdatedMap(entity)!;
        map![rel.foreignKey] = relatedId;
        map![rel.fieldName] = null;
      }
    }
  }

  /**
   * Function reUseIfExist
   * @Param Map relatedMap
   * @Param RelationMeat relation
   * @Return  Future<EntityInterface?>
   */
  Future<EntityInterface?> reUseIfExist(
      EntityInterface entity, RelationMeta? relation) async {
    final relatedType = relation?.relatedType;
    print(
        "DEBUG reUseIfExist: entity type: ${entity.runtimeType}, relatedType: ${relation?.relatedType}");
    var relatedController = controllerIndex["${relatedType}Controller"]?.call();
    if (relatedController == null) {
      print(
          "ORM L360,reUseIfExist: No controller found for ${relation?.relatedType}");
      return null;
    }

    if (relatedController != null) {
      await relatedController.ready;

      if (relation!.reuseIfExists && relation!.findBy.isNotEmpty) {
        //Create a Map<key,value> to pass in findByFields
        EntityInterface? existing = await findByFields(relation, entity);
        print("ORM 426, findByFields ${existing}");
        final entityMap = entity.toJson() ?? {};

        if (existing != null) {
          bool upsertDone = false;
          //Upsert if we need to update preexisting entity
          if (relation.updateIfExist) {
            upsertDone =
                await upsert(entity, existing, relatedController, relation);
          }
          if (existing != null) {
            if (upsertDone) {
              entity = existing;
            } else {
              print("Entity exist but, Upsert was not done correctly!");
            }
            var updatedMap = getUpdatedMap(entity) ?? {};
            updatedMap[relation.foreignKey] = entity.id;
            updatedMap[relation.fieldName] = null;

            relatedPersisted = entity;
          }
        } else {// If doesn't exist
             print(
                  "ORM L450, No entity was found with Fields we persist bared related Entity");
             print(
              'ORM L452, reUseIfExist: Persisting new entity...type : $entity.runtimeType.toString() ; entity : $entity.toString');
             var entityType = entity.runtimeType.toString();

             if (entityType == 'AuthUser') {

               // Si AuthUser récupération de l'id en bdd
                storeUpdatedMap(entity);
                Controller nestedEntityController =
                   controllerIndex['${entityType}Controller']!.call();
                  await nestedEntityController.ready;
                int? id = (await nestedEntityController.getLastId())! +1;
                print("ORM L463, entity id : ${id}");

                   if (id != null) {
                       getUpdatedMap(entity)!['id'] = id.toString();
                      print("ORM L463, entity id : ${  getUpdatedMap(entity)!['id']}");
                   }

             }

             print("ORM L472, entity  : ${entity}");
             var fromMap = entityIndex[entityType]['fromMap'] as Function;
             entity = fromMap(getUpdatedMap(entity));
             print("ORM L475, entity  : ${entity}");
             relatedPersisted = await persist(entity);


              print('ORM L479, reUseIfExist: Persisted entity: $relatedPersisted');
        }

        print( "ORM L482, Reuse related entity ${entity.runtimeType.toString()}");
        print("ORM L483, Reuse related entity ${entity.toString()}");

      } else {
        // If reuseIfExist== false and findBy empty

        var entityType = entity.runtimeType.toString();
        Controller nestedEntityController =
            controllerIndex['${entityType}Controller']!.call();
        await nestedEntityController.ready;
        int? id = (await nestedEntityController.getLastId())!+1;
        if (id != null) {
          getUpdatedMap(entity)!["id"] = id ;
          print("ORM L485, entity id : ${id}");
        }
        var fromMap = entityIndex[entityType]['fromMap'] as Function;
        entity = fromMap(getUpdatedMap(entity));
        print("ORM L489, entity id : ${entity}");
        print("ORM L490, related entity ${entityType} persist triggered}");

        relatedPersisted = await persist(entity);

        print('ORM L493,reUseIfExist: Persisted entity: $relatedPersisted');

      }

     if(relatedPersisted!= null) storeUpdatedMap(relatedPersisted!);
      print('ORM L498,reUseIfExist: RelatedPersisted entity: $relatedPersisted');

      return relatedPersisted;
    }
  }

  Future<EntityInterface?> reUseIfExist2(
      EntityInterface entity, RelationMeta relation) async {
    final relatedType = relation.relatedType;
    var relatedController = controllerIndex["${relatedType}Controller"]?.call();
    if (relatedController == null) {
      print(
          "ORM L308,reUseIfExist: No controller found for ${relation.relatedType}");
      return null;
    }

    if (relatedController != null) {
      await relatedController.ready;

      if (relation.reuseIfExists && relation.findBy.isNotEmpty) {
        //Create a Map<key,value> to pass in findByFields
        EntityInterface? existing = await findByFields(relation, entity);
        print("ORM 318, findByFields ${existing}");
        if (existing != null) {
          bool upsertDone = false;
          //Upsert if we need to update preexisting entity
          if (relation.updateIfExist) {
            upsertDone =
                await upsert(entity, existing, relatedController, relation);
          }
          if (upsertDone == true) {
            entity = existing;
            storeUpdatedMap(entity);
            getUpdatedMap(entity)?[relation.foreignKey] = entity.id;
            getUpdatedMap(entity)?[relation.fieldName] = null;
            storeUpdatedMap(existing);
            getUpdatedMap(entity)?[relation.foreignKey] = existing.id;
            getUpdatedMap(entity)?[relation.fieldName] =
                null; //The related entity was persisted, we delete the content of rel.fieldName
            relatedPersisted = existing;
          }
        } else {
          print(
              "ORM L512, No entity was found with Fields we persist bared related Entity");
          print('reUseIfExist: Persisting new entity...');
          relatedPersisted = await persist(entity);
          print('ORM L515,reUseIfExist: Persisted entity: $relatedPersisted');
        }
        print(
            "ORM L338, Reuse related entity ${entity.runtimeType.toString()}");
        print("ORM L518, Reuse related entity ${entity.toString()}");
      } else {
        print(
            "ORM L521, related entity ${entity.runtimeType.toString()} persist triggered}");
        relatedPersisted = await persist(entity);
        print('ORM L523,reUseIfExist: Persisted entity: $relatedPersisted');
      }
      print(
          'ORM L525,reUseIfExist: RelatedPersisted entity: $relatedPersisted');
      return relatedPersisted;
    }
  }

  /**
   * Function ConvertMap
   * @Param Map source
   * @Return Map<String, dynamic>
   * Convert  key dynamic in String
   * It is used with mergeMapsDeep to be sur to get Map<String, dynamic> as Entry
   * */
  Map<String, dynamic> convertMap(Map<dynamic, dynamic> source) {
    return source.map((key, value) {
      if (value is Map) {
        // Recursive convert nested map
        return MapEntry(key.toString(), convertMap(value));
      } else if (value is List) {
        // Convert each element if it's a Map
        return MapEntry(
            key.toString(),
            value.map((item) {
              if (item is Map) return convertMap(item);
              return item;
            }).toList());
      } else {
        // Base case: value is not a Map or List
        return MapEntry(key.toString(), value);
      }
    });
  }

  /**
   * Function upsert
   * @Param EntityInterface entity (from the query)
   * @Param EntityInterface existing (preexist in BDD
   * @Param Controller<EntityInterface> relatedController
   * @Param RelationMeta relation
   */

  //With recursion
  Future<bool> upsert(dynamic entity, EntityInterface existing,
      relatedController, RelationMeta relation) async {
    var ret;
    final existingMap = existing.toJson() ?? {};
    final entityMap = entity.toJson() ?? {};
    final mergedMap = Map<String, dynamic>.from(existingMap);
    print('ORM L592, : entityMap:${entityMap.toString()}');
    print('ORM L593, : existingMap:${existingMap.toString()}');
    print('ORM L638 : DEBUG :  type : ${entity.runtimeType.toString()},  entity : $entity.toString');
    print("ORM L639, DEBUG upsert: entity type: ${entity.runtimeType}, existing id: ${existing.id}");

    // Persist nested entities properly and update foreign keys
    for (var entry in entityMap.entries) {
      var key = entry.key;
      var value = entry.value;
      var keyFUpper = key.toString().firstToUpperCase();
      print('ORM 596, : entry:${entry.toString()}');
      if (entityIndex.containsKey(keyFUpper) && value != null && value != {}) {
        print(
            "ORM L598 DEBUG processing nested key: $key for entity type: ${entity.runtimeType}");
        var fromMap = entityIndex[keyFUpper]['fromMap'] as Function;
        print('ORM L600, : value : ${value.toString()} ');
        var nestedEntity = fromMap(value);
        print(
            'ORM L609 Attempting to reuse or persist nested entity: $nestedEntity');
        var persistedNested;
        var entityNestedPersisted;
        try {
          var nestedRelation = getRelationForKey(key);
          /*
              if( relation.type== RelationType.isA){
                 nestedRelation = getRelationForKey2(nestedEntity,relation.fieldName);
              }else{
                nestedRelation = getRelationForKey(key);
              }
          */
          if (nestedRelation != null) {
            // Use nestedRelation in reUseIfExist and recursive upsert
            persistedNested = await reUseIfExist(nestedEntity, nestedRelation);

            var existingNested = persistedNested ?? nestedEntity;
            Controller nestedController =
                ControllerIndex['${nestedEntity.runtimeType}Controller']!();

            bool nestedPersisted = await upsert(
              nestedEntity,
              existingNested,
              nestedController,
              nestedRelation,
            );

            if (nestedPersisted != null && nestedEntity.id != null) {
              mergedMap[nestedRelation.foreignKey] = nestedEntity.id;
              mergedMap[nestedRelation.fieldName] = null;
            } else {
              print(
                  'ORM L632, Nested persistence failed or nested entity id is null');
            }
          } else {
            print('ORM L635, No matching relation found for key $key');
          }

          print('ORM L638 After reUseIfExist, got: $persistedNested');

          //I must delete this to avoid double persistence?
          //var controllerNested= '${nestedEntity.runtimeType.toString()}Controller';
          // print('ORM L621 upsert,   controllerNested: $controllerNested');
          var controllerFunction = ControllerIndex[
              '${nestedEntity.runtimeType.toString()}Controller'] as Function;
          Controller controllerNested = controllerFunction();

          print('ORM L649 I goes here');
          if (controllerNested.repository == null) {
            await controllerNested.initRepository();
          }
          if (await controllerNested.ready) {
            print('ORM L658 I goes here');
            var persist =
                index_ControllerFunctionMap[controllerNested]!['persist']
                    as Function;
            print('ORM L660 upsert, persist function : $persist');
            entityNestedPersisted = await persist(persistedNested);

            print(
                'ORM L664 upsert, Returned entityNestedPersisted: $entityNestedPersisted');
            print(
                'ORM L665 upsert, Returned entityNestedPersisted.id: ${entityNestedPersisted?.id}');
          }
        } catch (e, stack) {
          print('Exception during nested persistence: $e\n$stack');
          rethrow;
        }
        print(
            'ORM L641, After persist call, entityNestedPersisted: $entityNestedPersisted');

        if (entityNestedPersisted?.id != null) {
          print(
              'ORM L645 upsert, Updating mergedMap foreign key ${relation.foreignKey} with id ${entityNestedPersisted.id}');
          mergedMap[relation.foreignKey] = entityNestedPersisted.id;
          mergedMap[relation.fieldName] = null;
        } else {
          print(
              'ORM L649 upsert, Persistence failed or id is null on nested entity');
        }
      }
    }

    //Deep merge of nested entity
    mergeMapsDeep(mergedMap, entityMap, relation: relation);
    /* or you can use (but only merge level 1)
    entityMap.forEach((key, value) {
      if (value != null) mergedMap[key] = value;
    });*/

    if (existingMap.containsKey('id')) {
      mergedMap['id'] = existingMap['id'];
      ret = await relatedController.update(parameters: mergedMap);
    } else {
      var createRet = await relatedController.create(mergedMap);
      if (createRet?.value?.id != null) {
        mergedMap[relation.foreignKey] = createRet.value.id;

        var controller =
            controllerIndex["${entity.runtimeType.toString()}Controller"]
                ?.call();
        if (controller != null) {
          await controller.ready;
          ret = await controller.update(parameters: mergedMap);
        } else {
          ret = true;
        }
      } else {
        ret = false;
        print('show mergedMap: $mergedMap');
      }
    }

    print('ORM L588, persist, show mergedMap: $mergedMap');
    updatedMaps[getOrAssignKey(existing)] = mergedMap;
    return ret;
  }

//Without recursion
  Future<bool> upsertSaved(dynamic entity, EntityInterface existing,
      relatedController, RelationMeta relation) async {
    var ret;
    final existingMap = existing.toJson() ?? {};
    final entityMap = entity.toJson() ?? {};
    final mergedMap = Map<String, dynamic>.from(existingMap);

    // Persist nested entities properly and update foreign keys
    for (var entry in entityMap.entries) {
      var key = entry.key;
      var value = entry.value;
      if (entityIndex.containsKey(key)) {
        var fromMap = entityIndex[key]['fromMap'] as Function;
        var nestedEntity = fromMap(value);
        print('Attempting to reuse or persist nested entity: $nestedEntity');
        var persistedNested;
        var entityNestedPersisted;
        try {
          persistedNested = await reUseIfExist(nestedEntity, relation);
          print('ORM 694 After reUseIfExist, got: $persistedNested');
          var controllerNested =
              '${nestedEntity.runtimeType.toString()}Controller';
          print('ORM L696 upsert,   controllerNested: $controllerNested');

          Controller controller = ControllerIndex[
                  '${nestedEntity.runtimeType.toString()}Controller']
              as Controller<EntityInterface>;
          if (controller.repository == null) {
            await controller.initRepository();
          }
          if (await controller.ready) {
            var persist = ControllerIndex[nestedEntity.runtimeType.toString()]
                ['persist'] as Function;
            entityNestedPersisted = await persist(persistedNested);

            print(
                'ORM L750 upsert, Returned entityNestedPersisted: $entityNestedPersisted');
            print(
                'ORM L751 upsert,Returned entityNestedPersisted.id: ${entityNestedPersisted?.id}');
          }
        } catch (e, stack) {
          print('Exception during nested persistence: $e\n$stack');
          rethrow;
        }
        print(
            'ORM L756, After persist call, entityNestedPersisted: $entityNestedPersisted');

        if (entityNestedPersisted?.id != null) {
          print(
              'ORM L554 upsert, Updating mergedMap foreign key ${relation.foreignKey} with id ${entityNestedPersisted.id}');
          mergedMap[relation.foreignKey] = entityNestedPersisted.id;
          mergedMap[relation.fieldName] = null;
        } else {
          print(
              'ORM L764 upsert, Persistence failed or id is null on nested entity');
        }
      }
    }

    //Deep merge of nested entity
    mergeMapsDeep(mergedMap, entityMap, relation: relation);
    /* or you can use (but only merge level 1)
    entityMap.forEach((key, value) {
      if (value != null) mergedMap[key] = value;
    });*/

    if (existingMap.containsKey('id')) {
      mergedMap['id'] = existingMap['id'];
      ret = await relatedController.update(parameters: mergedMap);
    } else {
      var createRet = await relatedController.create(mergedMap);
      if (createRet?.value?.id != null) {
        mergedMap[relation.foreignKey] = createRet.value.id;

        var controller =
            controllerIndex["${entity.runtimeType.toString()}Controller"]
                ?.call();
        if (controller != null) {
          await controller.ready;
          ret = await controller.update(parameters: mergedMap);
        } else {
          ret = true;
        }
      } else {
        ret = false;
        print('show mergedMap: $mergedMap');
      }
    }

    print('ORM L588, persist, show mergedMap: $mergedMap');
    updatedMaps[getOrAssignKey(existing)] = mergedMap;
    return ret;
  }

  /**
   * Function findByFields
   * @Param RelationMeta relation
   * @Map relatedMap
   * Return entity if it preexits in BDD
   * Search by discriminant fields in RelationMeta
   * from List that are translated in Map
   */
  Future<EntityInterface?> findByFields(
      RelationMeta relation, EntityInterface entity) async {
    final relatedType = relation.relatedType;
    var relatedController = controllerIndex["${relatedType}Controller"]?.call();
    final lookupMap = <String, dynamic>{};
    print(
        'ORM L805:  findByFields : entity(before request to Bdd) :${entity.toString()}');
    for (final key in relation.findBy) {
      lookupMap[key] = (entity as dynamic).toJson()[key];
    }
    return await relatedController.findByFields(lookupMap);
  }

  /**
   * Function isA
   * @Param List<RelationMeta> relations
   * @Param InterfaceEntity entity
   * @Return Future<Map?>
   */
  Future<Map?> isA(List<RelationMeta> relations, EntityInterface entity) async {
    for (final rel in relations.where((r) => r.type == RelationType.isA)) {
      if (rel.type == RelationType.isA) {
        final superEntity = await getSuperEntity(entity, rel);
        if (superEntity != null && getUpdatedMap(entity) != null) {
          // Recursively cascade persist the super entity

          await cascadeParentsR(superEntity!,
              classRelationsIndex[superEntity.runtimeType.toString()]);
          final persistedSuper = await persist(superEntity);

          // Update foreign key / IDs if needed
          String foreignKey = rel.foreignKey.camelToSnake();
          var map = getUpdatedMap(entity);
          map![foreignKey] = persistedSuper?.id;
          print('ORM L834, debug, function isA , updatedMaps :  $map!');
          return map;
        }
      }
    }
  }

  /**
   * Function isAwReuse
   * @param  List<RelationMeta> relations
   * @param EntityInterface entity
   * @return Future<Map?>
   */
  Future<EntityInterface?> isAwReuse(
    EntityInterface entity,
    List<RelationMeta> relations,
  ) async {
    for (final rel in relations.where((r) => r.type == RelationType.isA)) {
      final superEntity = await getSuperEntity(entity!, rel);
      if (superEntity == null) continue;

      // Store the super entity in updatedMaps before cascading
      storeUpdatedMap(superEntity);

      // Cascade persist the super entity
      await cascadeParentsR(superEntity,
          classRelationsIndex[superEntity.runtimeType.toString()]!);

      // Try to reuse or persist the super entity
      final relatedPersisted = await reUseIfExist(superEntity, rel);
      if (relatedPersisted == null) {
        print("Failed to reuse or persist super entity ${superEntity.runtimeType}");
      }

      // Update the foreign key on the child entity
      final foreignKey = rel.foreignKey;
      final updatedMap = getUpdatedMap(entity) ?? entity.toJson()!;
      updatedMap[foreignKey] = relatedPersisted?.id;
      print(
          'ORM.isAwReuse L542 , Type:${relatedPersisted.runtimeType} ${updatedMap.toString()}');

      updatedMaps[getOrAssignKey(entity)] = updatedMap;
      print(
          'ORM.isAwReuse L544, entity Type:${relatedPersisted.runtimeType}  save in updatedMaps: ${updatedMaps[getOrAssignKey(entity)]}');
      return relatedPersisted;
    }
    return null;
  }

  Future<EntityInterface?> isAwReuse2(
      EntityInterface entity, List<RelationMeta> relations) async {
    for (final rel in relations.where((r) => r.type == RelationType.isA)) {
      if (rel.type == RelationType.isA) {
        EntityInterface? superEntity = await getSuperEntity(entity, rel);
        if (superEntity == null) continue;
        print('ORM L439: isAwReuse, entity: ${entity.toString()}');
        print('ORM L440: isAwReuse, superEntity: ${superEntity.toString()}');

        if (superEntity != null && getUpdatedMap(entity) != null) {
          // Store the superEntity map to updatedMaps before cascade
          this.storeUpdatedMap(superEntity);
          await cascadeParentsR(superEntity,
              classRelationsIndex[superEntity.runtimeType.toString()]);

          final relatedPersisted = await reUseIfExist(superEntity, rel);

          if (relatedPersisted == null) {
            throw Exception("isAwReuse failed to reuse or persist superEntity");
          }

          // Update foreign key / IDs in map
          String foreignKey = rel.foreignKey;
          var updatedMap = getUpdatedMap(relatedPersisted);
          if (updatedMap == null) {
            updatedMap = getUpdatedMap(superEntity);
            updatedMaps[getOrAssignKey(relatedPersisted)] = updatedMap!;
          }
          updatedMap![foreignKey] = relatedPersisted.id;
          print('ORM L506, debug, function isAwReuse, updatedMap: $updatedMap');

          return relatedPersisted;
        }
      }
    }
    return null;
  }

//Helper isA functions
  /**
   * Function getSuperEntity
   * @Param EntityInterface entity
   * @Param RelationMeta rel
   */
  Future<EntityInterface?> getSuperEntity(
      EntityInterface entity, RelationMeta rel) async {
    EntityInterface? ret;

    try {
      print('ORM getSuperEntity L469: fromMap , map : ${entity.toString()}');
      var fromMap = Entity_Index[rel.relatedType]["fromMap"] as Function;
      Map<String, dynamic>? mappedEntity = entity.toJson(); //main entity User
      String relatedEntity = rel.fieldName;
      print('ORM L737: $relatedEntity');
      print('ORM L738: ${entity.runtimeType.toString()} : $mappedEntity');

      String fkInCamel = StringLib.snakeToCamel(rel.foreignKey);
      var id;
      if (mappedEntity?[relatedEntity] != null) {
        ret = fromMap(mappedEntity?[relatedEntity]);
        print('ORM L745 superentity: ${ret!}');
      } else if (mappedEntity?[fkInCamel] != null) {
        try {
          print('ORM L916: ${mappedEntity?[fkInCamel]}');
          id = mappedEntity?[fkInCamel];
          print('ORM L918: foreignId ${id}');

          var findById = index_ControllerFunctionMap[
                  '${relatedEntity.firstToUpperCase()}Controller']!['getEntity']
              as Function;

          //  print('ORM L924: ${findById.toString()}');
          ret = await findById(id);

          print('ORM L927 superentity: ${ret!}');
          storeUpdatedMap(ret!);
        } catch (e, s) {
          print("ORM 929, error :$e \r stack: $s");
        }
      } else {
        print(
            'ORM: No related entity or foreign key found for ${relatedEntity} / ${fkInCamel}.');
      }
      if (ret != null) print('ORM L935: ${getUpdatedMap(ret!)}');
    } catch (e, stack) {
      print('ORM L769 Error : $e \r Stack: $stack');
    }
    return ret;
  }

  /**
   * Function hasOne
   */
  Future<void> hasOne(
      List<RelationMeta> relations, EntityInterface? persistedEntity) async {
    for (final rel in relations.where((r) => r.type == RelationType.hasOne)) {
      final childType = rel.relatedType;
      final childFromMap = Entity_Index[childType]['fromMap'] as Function;
      var child = getUpdatedMap(persistedEntity!)![rel.fieldName];
      if (child != null) {
        if (child is Map) child = childFromMap(child);

        // Persist the parent first (already done above), get parent id:
        final parentId = (persistedEntity as dynamic).toJson()['id'];
        if (parentId == null) throw Exception('Parent id is null for hasOne!');

        // Set FK in child (example: parent_id)
        final childMap = child.toJson();
        childMap[rel.foreignKey] = parentId;
        final updatedChild = childFromMap(childMap);
        var childController = controllerIndex["${childType}Controller"]?.call();
        if (childController != null) {
          await childController.persist(updatedChild);
        } else {
          await persist(updatedChild);
        }
      }
    }
  }

  /**
   * Function hasMany
   */
  Future<void> hasMany(
      List<RelationMeta> relations, EntityInterface? persistedEntity) async {
    for (final rel in relations.where((r) => r.type == RelationType.hasMany)) {
      final childType = rel.relatedType;
      print("ORM L188 $childType");
      final childFromMap = Entity_Index[childType]['fromMap'] as Function;
      final children =
          getUpdatedMap(persistedEntity!)![rel.fieldName] as List<dynamic>?;
      if (children != null) {
        for (var child in children) {
          if (child is Map) child = childFromMap(child);
          // set FK in child
          final childMap = child.toJson();
          childMap[rel.foreignKey] =
              (persistedEntity as dynamic).toJson()['id'];
          final updatedChild = childFromMap(childMap);
          var childController =
              controllerIndex["${childType}Controller"]?.call();
          if (childController != null) {
            await childController.persist(updatedChild);
          } else {
            await persist(updatedChild);
          }
        }
      }
    }
  }

  /**
   * Function manyToMany
   **/
  Future<void> manyToMany(
      List<RelationMeta> relations, EntityInterface persistedEntity) async {
    genericToMany(relations, persistedEntity);
  }

  /**
   * Function belongsToMany
   **/
  Future<void> belongsToMany(
      List<RelationMeta> relations, EntityInterface persistedEntity) async {
    genericToMany(relations, persistedEntity);
  }

  Future<void> genericToMany(
      List<RelationMeta> relations, EntityInterface persistedEntity) async {
    for (final rel in relations.where((r) =>
        r.type == RelationType.manyToMany ||
        r.type == RelationType.belongsToMany)) {
      final children =
          getUpdatedMap(persistedEntity)![rel.fieldName] as List<dynamic>?;
      if (children != null) {
        for (var child in children) {
          // Ensure the related entity exists
          final childEntity = child is Map
              ? Entity_Index[rel.relatedType]['fromMap'](child)
              : child;
          final childPersisted = await persist(childEntity);
          if (childPersisted == null) {
            throw Exception(
                'Failed to persist related entity ${rel.relatedType}');
          }

          // Ensure IDs are not null
          final parentId = persistedEntity.id;
          final childId = childPersisted.id;
          if (parentId == null || childId == null) {
            throw Exception(
                'Cannot create join table row: ID for ${rel.relatedType} or main entity is null');
          }

          // Insert into join table
          await insertJoinTableRow(
            rel.relatedType.camelToSnake(),
            // Use the join table name directly from the relation
            {
              rel.joinParentForeignKey: parentId,
              rel.joinChildForeignKey: childId,
            },
          );
        }
      }
    }
  }

  /**
   * Function belongTo
   */
  Future<void> belongTo(
      List<RelationMeta> relations, EntityInterface? persistedEntity) async {
    for (final rel
        in relations.where((r) => r.type == RelationType.belongsToMany)) {
      final childType = rel.relatedType;
      final childFromMap = Entity_Index[childType]['fromMap'] as Function;
      final children =
          getUpdatedMap(persistedEntity!)![rel.fieldName] as List<dynamic>?;
      if (children != null) {
        final parentId = (persistedEntity as dynamic).toJson()['id'];
        if (parentId == null)
          throw Exception('Parent id null for belongsToMany!');
        for (var child in children) {
          if (child is Map) child = childFromMap(child);

          // Persist child if it's new
          var childEntityPersisted;
          var childController =
              controllerIndex["${childType}Controller"]?.call();
          if (childController != null) {
            childEntityPersisted = await childController.persist(child);
            print("ORM L230, related entity persisted");
          } else {
            childEntityPersisted = await persist(child);
            print("ORM L443, related entity persisted");
          }
          final childId = childEntityPersisted.toJson()['id'];
          if (childId == null)
            throw Exception('Child id null for belongsToMany!');

          // Insert join table entry (assume join table and field names available in rel)
          await insertJoinTableRow(rel.fieldName, {
            // joinParentForeignKey
            // joinChildForeignKey=foreignKey;
            //TOCheck 20/07/2025
            classRelationsIndex[persistedEntity].foreignKey: parentId,
            // e.g. student_id
            rel.foreignKey: childId
          });
        }
      }
    }
  }

  /**
   * Function insertJoinTableRow (for GenericToMany)
   */
  Future<void> insertJoinTableRow(
    String table,
    Map<String, dynamic> fields,
  ) async {
    final columns = fields.keys.join(', ');
    final placeholders = List.filled(fields.length, '?').join(', ');
    final sql = 'INSERT INTO $table ($columns) VALUES ($placeholders)';
    final values = fields.values.toList();

    if (executor == null) {
      throw Exception('DB executor is not initialized!');
    }

    print('insertJoinTableRow: SQL = $sql, values = $values');

    await executor!.query(table, sql, fields);
  }

  //Theory Dart pseudoCode
  Future<void> cascadeHasMany(
      dynamic persistedEntity,
      String relationName,
      List<dynamic>? children,
      String fkField,
      Function childFromMap,
      Future<void> Function(dynamic) persistChild) async {
    if (children == null) return;
    final parentId = (persistedEntity as dynamic).toJson()['id'];
    if (parentId == null)
      throw Exception("Parent id is null for hasMany cascade on $relationName");
    for (var child in children) {
      if (child is Map) child = childFromMap(child);
      final childMap = child.toJson();
      childMap[fkField] = parentId;
      final updatedChild = childFromMap(childMap);
      await persistChild(updatedChild);
    }
  }

  /**
   * Function deleteWithCascade
   * @Param : String entityType
   * @Param : dynamic entityOrId
   * exemple : await deleteWithCascade('Person', personId);
   *           await deleteWithCascade(entity.runtimeType.toString() entity);
   * @Return bool (if main entity deleted)  /!\ doesn't warranty for related entities
   */
  Future<bool> deleteWithCascade(
    String entityType,
    dynamic entityOrId, {
    Set<String>? deletedEntities, // Pass down
  }) async {
    deletedEntities ??=
        <String>{}; //Prevent delete loop, erasing several time the same entity

    // 1. Find the entity if only ID was given
    final controller = controllerIndex["${entityType}Controller"]?.call();
    if (controller == null) throw Exception('No controller for $entityType');

    if ((await controller.ready) == false) {
      await controller.initRepository();
    }
    final entity = entityOrId is EntityInterface
        ? entityOrId
        : await controller.repository!.findById(entityOrId);

    if (entity == null) throw Exception('Entity not found');

    final relations = classRelationsIndex[entityType] ?? {};

    Map<String, dynamic> entityMap = entity.toJson();
    String id = entityMap['id'];
    // Construct a unique key for this delete operation
    final entityKey = '$entityType-$id';

    // Prevent multiple deletes of the same entity in this chain
    if (deletedEntities.contains(entityKey)) return true;

    deletedEntities.add(entityKey);

    // 2. For each hasMany/hasOne/belongsToMany child: cascade delete

    // hasOne | isA (direct child/Parent)
    for (final rel in relations.where((r) =>
        (r.type == RelationType.hasOne || r.type == RelationType.isA) &&
        r.cascadeOnDelete)) {
      final childType = rel.relatedType;
      //print('ORM L555, id person  for ${entityMap[rel.fieldName]?['id']}');
      print('ORM L555, fieldName ${rel.fieldName}');
      print('ORM L555, Entity id ${entityMap['id']}');
      print('ORM L555, entity related   ${entityMap[rel.fieldName]}');
      print('ORM L555, entity related id  ${entityMap[rel.fieldName]!['id']}');

      final childController = controllerIndex["${childType}Controller"]?.call();
      if (childController == null) continue;
      //final childId = int.parse(entityMap[rel.fieldName]?['id']);  //fieldName= person
      final childMap = entityMap[rel.fieldName];
      int childId;
      if (childMap != null && childMap['id'] != null) {
        childId = int.parse(childMap['id'].toString());
        print(
            ' ORM L540, childId Type:${childId.runtimeType.toString()}, id: ${childId}');

        if (childId != null) {
          try {
            await deleteWithCascade(childType, childId,
                deletedEntities: deletedEntities);
          } catch (e) {
            print(
                "ORM L568, error to delete ${childType.toString()} with id ${childId}");
          }
        }
      } //fieldName= person

      // --- hasMany (multiple children) ---
      for (final rel in relations
          .where((r) => r.type == RelationType.hasMany && r.cascadeOnDelete)) {
        final childType = rel.relatedType;
        final childController =
            controllerIndex["${childType}Controller"]?.call();
        if (childController == null) continue;
        final children = entityMap[rel.fieldName] as List<dynamic>? ?? [];
        for (final child in children) {
          int childId = int.parse(child['id']);
          if (childId != null) {
            await deleteWithCascade(childType, childId,
                deletedEntities: deletedEntities);
          }
        }
      }

      // --- belongsToMany (clean up join table, and optionally remote entities on flag) ---
      for (final rel
          in relations.where((r) => r.type == RelationType.belongsToMany)) {
        // Always remove join table rows
        await deleteJoinTableRows(
            rel.joinTable, rel.joinParentForeignKey, entityMap['id']);
        // If cascadeOnDelete, remove the OTHER entity as well
        if (rel.cascadeOnDelete) {
          final children = entityMap[rel.fieldName] as List<dynamic>? ?? [];
          for (final child in children) {
            final childType = rel.relatedType;
            int childId = int.parse(child['id']);
            if (childId != null) {
              await deleteWithCascade(childType, childId,
                  deletedEntities: deletedEntities);
            }
          }
        }
      }

      // --- finally: delete this entity ---
      await controller.repository!.delete(int.parse(entityMap['id']));
    }

    // hasMany
    for (final rel in relations.where((r) => r.type == RelationType.hasMany)) {
      final childType = rel.relatedType;
      final childController = controllerIndex["${childType}Controller"]?.call();
      if (childController == null) continue;
      final children = entityMap[rel.fieldName] as List<dynamic>? ?? [];
      for (final child in children) {
        final childId = int.parse(child['id']);
        if (childId != null) {
          await deleteWithCascade(childType, childId,
              deletedEntities: deletedEntities);
        }
      }
    }

    // belongsToMany (join table cleanup only)
    for (final rel
        in relations.where((r) => r.type == RelationType.belongsToMany)) {
      await deleteJoinTableRows(
          rel.joinTable, rel.joinParentForeignKey, int.parse(entityMap['id']));
    }

    // 3. Delete entity itself
    return await controller.delete(int.parse(entityMap['id']));
  }

  Future<void> deleteJoinTableRows(
      String table, String fkField, dynamic id) async {
    final sql = "DELETE FROM $table WHERE $fkField = :id";
    if (executor == null) throw Exception('executor not set');
    await executor!.query(table, sql, {'id': id});
  }

  //Helper
  void storeUpdatedMap(EntityInterface entity) {
    final key = getOrAssignKey(entity);
    print('storeUpdatedMap: Storing key: $key');
    Map<String, dynamic> entityMap = entity.toJson()!;
    if (entityMap != null) {
      var normalizedMap =
          StringLib().snakeToCamelKeyFromMap(entityMap) as Map<String, dynamic>;
      updatedMaps[getOrAssignKey(entity)] = normalizedMap;
    }
  }

  /*
  * Function mergeMapsDeep
  * mergeShallow nested map of nested Entity
  * @Param Map target
  * @Param Map source
  */
  void mergeMapsDeep(Map target, Map source, {RelationMeta? relation}) {
    source.forEach((key, value) {
      if (key == relation?.foreignKey) return; //protect foreignKey
      if (value != null) {
        if (value is Map && target[key] is Map) {
          mergeMapsDeep(target[key], value, relation: relation);
        } else {
          target[key] = value;
        }
      }
    });
  }

  Map<String, dynamic>? getUpdatedMap(EntityInterface entity) {
    return updatedMaps[getOrAssignKey(entity)];
  }

  //Entity identifiant with persist resilience

  /**
   * Function getOrAssignKey
   * @Param EntityInterface e
   * get unique id key if exist or assign temporary key
   */
  String getOrAssignKey(EntityInterface e) {
    final id = e.toJson()!['id'];
    if (id != null) {
      return '${e.runtimeType}#$id';
    }
    // Check if entity already has a temp key
    if (e.cascadeTempKey == null) {
      e.cascadeTempKey = '#${identityHashCode(e)}';
    }
    return '${e.runtimeType}@temp${(e as dynamic).cascadeTempKey}';
  }

  /**
   * Function replaceKey
   * Must be used after persistence to reference entities
   * @Param EntityInterface oldEntity
   *  @Param EntityInterface newEntity
   */
  void replaceKey(EntityInterface oldEntity, EntityInterface newEntity) {
    final oldKey = getOrAssignKey(oldEntity);

    final newKey = getOrAssignKey(newEntity);
    //  print('replaceKey: oldKey = $oldKey');
    //  print('replaceKey: newKey = $newKey');
    if (updatedMaps.containsKey(oldKey) && oldKey != newKey) {
      updatedMaps[newKey] = updatedMaps.remove(oldKey)!;
      print('replaceKey: Moved map from $oldKey to $newKey');
    } else {
      print('replaceKey: No map moved - either missing oldKey or same keys');
    }
  }
}
