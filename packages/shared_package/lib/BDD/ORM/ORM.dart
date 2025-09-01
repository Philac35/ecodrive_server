

import 'package:angel3_orm/angel3_orm.dart';

import 'package:mysql_client/mysql_client.dart';
import 'package:shared_package/BDD/Connection/MysqlConnection.dart';
import 'package:shared_package/Controller/Index/Index_ControllerFunction.dart';
import 'package:shared_package/Controller/Index/Controller_index.dart';
import '../../Controller/Controller.dart';

import '../../Library/StringLibrary/string_librairy.dart';
import '../../Modules/Authentication/Entities/AuthUser.dart';
import '../Executor/MysqlPoolExecutor.dart';

import '../Model/Abstract/PersonEntity.dart';
import 'Relations/ClassRelation_Index.dart';
import '../Interface/entityInterface.dart';
import '../Model/Index/Entity_Index.dart';
import 'package:shared_package/Library/StringLibrary/str_extension.dart';
import  'package:shared_package/Services/LogSystem/LogFunction.dart';

class ORM {
  Map<String, dynamic> controllerIndex;
  Map<String, dynamic> entityIndex;
  Map<String, dynamic> classRelationsIndex;

  //TODO Implement Transactions, Use to save preformed queries in the cascading system to make transactions. Ids must be managed Correctly
  //Map <String, dynamic> transactionContext;

  EntityInterface? relatedPersisted;
  late Map<String, Map<String, dynamic>> updatedMaps;

  MySQLConnectionPool? connexionPool;
  QueryExecutor? executor;

  ORM()
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


    p("persist , Entity to persist : ${entity.runtimeType.toString()} ","L58");


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

      p("getRelations works with Type","L99");
      entityType = entity.runtimeType.toString();
    } else {

      p(" getRelations works with String","L126");
      entityType = StringLib().firstToUpperCase(entity);
    }
    p("entity:  ${entityType}","L106");
    //print("ORM L123, entity:  ${StringLib().firstToUpperCase(entityType)}");
    final relations = classRelationsIndex[entityType] ?? [];
    p("relations:  ${relations}","L109");
    return relations;
  }

  RelationMeta? getRelationForKey(String key) {
    // /!\  In relation for key authUser. must be Fuppercase and we find person

    var relations = getRelations(key);
    if (key == "authUser") {
      key = "person";
    }
    p("ensemble des relations relatives à  ${key}:  ${relations.toString()}", "L134");
    try {
      p("relations:  ${key}","L136");
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

    p("relations:  ${key}","135");
    var relations = getRelations(entity);
    print("ORM L130, relations:  ${relations}");
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
    mergeMapsShallow(getUpdatedMap(entity)!, convertMap(entity.toJson()!));

    final controller = controllerIndex["${entityType}Controller"]?.call();

    if (controller == null) {
      print('ORM L174 ERROR: No controller found for $entityType!');
      throw Exception('No controller found for $entityType');
    }
    await controller.initRepository();

    // int? id=(await controller.getLastId())+1;

    // Main entity save (can be updated in cascadingParent)
    final fromMap = entityIndex[entityType]['fromMap'] as Function;
    //getUpdatedMap(entity)!["id"]=id.toString();
    var entityFromMap = getUpdatedMap(entity);
    var updatedEntity;
    if (entityFromMap == null) {throw("ORM L170, save, UpdatedEntity is null peristence not possible ");}
      updatedEntity = fromMap(entityFromMap);

    p('save, updatedEntity : $updatedEntity',"L180");

    EntityInterface? a = await isAwReuse(updatedEntity, relations)!;

    if (a != null) {
      // replaceKey(updatedEntity, a); //This replace the child Type by parent Type and cause pbs
      // Do not updatedEntity= a;
      final controllerRelated = controllerIndex["${a.runtimeType.toString()}Controller"]?.call();

      //Update BDD Fk of parent in entity
      RelationMeta rel2=getRelationForKey2(a,entityType.toLowerCase())!;
      p('relation: $rel2',"L184");
      final foreignKey2= rel2.foreignKey!;
      //final foreignKey2= StringLib.snakeToCamel(rel2.foreignKey!);
      p('foreignKey2: $foreignKey2 ','L194');

         if (foreignKey2 != null) {
           getUpdatedMap(a)![StringLib.snakeToCamel(foreignKey2)]= entity.id;
           bool isUpdated=  await controllerRelated.update(entity:a, parameters: { foreignKey2 :updatedEntity.id});
       p("isUpdated : $isUpdated",'L199');
         p("updated Map entity ${a.runtimeType.toString()}: ${getUpdatedMap(a)}",'L200');

      }
    }

    p('debug, updatedEntity :  $updatedEntity!',"205");




    var persistedEntity = await controller.save(updatedEntity);

    // delete related field
    String relatedType = a.runtimeType.toString().toLowerCase();
    var entityMap = persistedEntity.toJson();
    entityMap[relatedType] = null;

    persistedEntity = fromMap(entityMap);
    replaceKey(updatedEntity, persistedEntity);

    // Ensure the persisted entity has an ID
    if (persistedEntity == null || persistedEntity.id == null) {
      throw Exception('ORM L192, Failed to persist $entityType: ID is null');
    }

    // Update the updatedMaps with the new ID
    final persistedMap = persistedEntity.toJson()!;

    updatedMaps[getOrAssignKey(persistedEntity)] = persistedMap;

    p('Main Entity Persisted in DB: $persistedEntity','L230');

    return persistedEntity;
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



          p('relatedPersisted or Reused $relatedPersisted','L269');

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
        print("ORM L289,CascadeParents AuthUser :$related");
      }
      if (related != null) {
        if (related is Map) related = relatedFromMap(related);
        EntityInterface? relatedPersisted;

        //ReuseIfExits -> reuse child in parent record if it preexists
        relatedPersisted = await reUseIfExist(related, rel);

        print('ORM: L298 relatedPersisted or Reused $relatedPersisted');

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
  Future<EntityInterface?> reUseIfExistSaved(
      EntityInterface entity, RelationMeta? relation) async {
    if (relation == null) return null;
    final relatedType = relation?.relatedType;  
    p("reuseIfExist ",'348');
    p("DEBUG reUseIfExist: entity type: ${entity.runtimeType}, relatedType: ${relation?.relatedType}",'L349');
    var relatedController = controllerIndex["${relatedType}Controller"]?.call();

    if (relatedController == null) { p("reUseIfExist: No controller found for ${relation?.relatedType}",'352');
      return null;
    }
;
    if (relatedController != null) {
      await relatedController.ready;

      if (relation!.reuseIfExists && relation!.findBy.isNotEmpty) {

        p("reuseIfExist, just after condition reuseIfExists ",'361');
        //Create a Map<key,value> to pass in findByFields
        EntityInterface? existing = await findByFields(relation, entity);

        final entityMap = entity.toJson() ?? {};

        if (existing != null) {
          p("findByFields ${existing}",'L368');
          bool upsertDone = false;
          //Upsert if we need to update preexisting entity
          if (relation.updateIfExist) {
            try {
              upsertDone =
              await upsert(entity, existing, relatedController, relation);
            }catch(e,s){print("ORM L339, Upsert failed for ${entity.runtimeType}: $e \n stack:$s");}
          }

            if (upsertDone) {
              entity = existing;
            }

            getUpdatedMap(entity)![relation.foreignKey] = entity.id;
            getUpdatedMap(entity)![relation.fieldName] = null;

            String  entityType = entity.runtimeType.toString();
            var fromMap = entityIndex[entityType]['fromMap'] as Function;
            var entity2 = fromMap(getUpdatedMap(entity));
            replaceKey(entity, entity2);


          if (entity2 is Person) {
            //In parent entity add current authUserId and delete  authUser field
            int? replaceId;
            RegExp reg = RegExp(r'AuthUser#(\d+)');
            EntityInterface? matched;
            int maxKeyNum = 0;

            for (var entry in updatedMaps.entries) {
              var key = entry.key;
              var valueMap = entry.value;
              if (reg.hasMatch(key)) {
                int keyNum = int.parse(reg.firstMatch(key)!.group(1)!);
                p("$keyNum","L403");
                if (keyNum > maxKeyNum) {
                  // Assuming valueMap.values contains EntityInterface entities
                  valueMap.values.forEach((value)=>print(value.toString()));

                  matched = valueMap.values.firstWhere(
                          (v) => v is EntityInterface, orElse: () => null) as EntityInterface?;
                  maxKeyNum = keyNum;
                p("$maxKeyNum","L409");
                }
              }
            }

                p("$matched","L414");
            if (matched != null && matched.id != null) {
              replaceId = int.tryParse(matched.id!);
            }
            entity2.authUser = null;
            entity2.authUserId = replaceId;
          }




            relatedPersisted = entity2;

        } else {// If doesn't exist
          var entityType = entity.runtimeType.toString();


             p("No entity was found with Fields we persist bared related Entity",'L398');
             p( 'reUseIfExist: Persisting new entity...type : $entityType ; entity : ${entity.toString()}','L399');



             //Check if entity already in UpdatedMaps;
             var mapEntity=getUpdatedMap(entity);
             if(mapEntity!= null){
             var fromMap = entityIndex[entityType]['fromMap'] as Function;
            var  entity2 = fromMap(getUpdatedMap(entity));
             p("entity  : ${entity2.toString()}",'L408');
             replaceKey(entity, entity2);
             entity= entity2;
             }

         if(entity!=null){
          p('entity to persist: ${entity.toString()}',"L414");
          relatedPersisted = await persist(entity); //-> pb the entity is not persisted here
          p('reUseIfExist: Persisted entity: $relatedPersisted','L416');
           //AuthUser is persisted here


         }
         else{p("entity doesn't exist here",'L389');}

        }
        if(relatedPersisted!=null) {
          print('ORM L411, reUseIfExist: Persisted entity: ${relatedPersisted
              .toString()}');
        }else{print('ORM 413, Fail to persist relatedEntity');}
      } else {
        print("ORM L415, Save barred entity,  If reuseIfExist == false and findBy empty");
        var entityType = entity.runtimeType.toString();
      /*
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
    */
        relatedPersisted = await persist(entity);

        print('ORM L493,reUseIfExist: Persisted entity: $relatedPersisted');

      }

     if(relatedPersisted!= null) storeUpdatedMap(relatedPersisted!);
      print('ORM L498,reUseIfExist: RelatedPersisted entity: $relatedPersisted');

      return relatedPersisted;
    }
  }


  /*
  * Function mergeMapsShallow
  * mergeShallow nested map of nested Entity
  * @Param Map target
  * @Param Map source
  */
  void mergeMapsShallow(Map target, Map source, {RelationMeta? relation}) {
    source.forEach((key, value) {
      if (key == relation?.foreignKey) return; //protect foreignKey
      if (value != null) {
        if (value is Map && target[key] is Map) {
          mergeMapsShallow(target[key], value, relation: relation);
        } else {
          target[key] = value;
        }
      }
    });
  }

  /**
   * Function ConvertMap
   * @Param Map source
   * @Return Map<String, dynamic>
   * Convert  key dynamic in String
   * It is used with mergeMapsShallow to be sur to get Map<String, dynamic> as Entry
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
    //final existingMap = existing.toJson() ?? {};
   // final entityMap = entity.toJson() ?? {};
    final existingMap  =getUpdatedMap(existing);
    final entityMap  =getUpdatedMap(entity);
    // final mergedMap = Map<String, dynamic>.from(existingMap);


    print('ORM L493 : DEBUG :  type : ${entity.runtimeType.toString()},  entity : $entity.toString');
    print("ORM L494, DEBUG upsert: entity type: ${entity.runtimeType}, existing id: ${existing.id}");
    print('ORM L495, : entityMap:${entityMap.toString()}');
    print('ORM L496, : existingMap:${existingMap.toString()}');

    // Persist nested entities properly and update foreign keys
    for (var entry in entityMap!.entries) {
      if(entry.value!=null){
      var key = entry.key;
      var value = entry.value;
      var keyFToUp = key.toString().firstToUpperCase();

      p(keyFToUp,"L535");
      p('entry:${entry.value.toString()}',"L536");



      if (entityIndex.containsKey(keyFToUp) && value != null && value != {}) {

        p( "DEBUG processing nested key: $key for entity type: ${entity.runtimeType}","L544");
        var fromMap = entityIndex[keyFToUp]['fromMap'] as Function;


        p(' value : ${value.toString()} ',"L546");

        var nestedEntity = fromMap(value);
        p('Attempting to reuse or persist nested entity: $nestedEntity','L533');
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

            print("UPSERT RECURRENCE Logic for nested entities");
            var existingNested = persistedNested ?? nestedEntity;
            Controller nestedController =
            ControllerIndex['${nestedEntity.runtimeType}Controller']!();

            bool isNestedUpserted = await upsert(
              nestedEntity,
              existingNested,
              nestedController,
              nestedRelation,
            );

            if (isNestedUpserted != null && nestedEntity.id != null) {
              getUpdatedMap(existing)![nestedRelation.foreignKey]= nestedEntity.id;
              getUpdatedMap(existing)![nestedRelation.fieldName]= null;

              //mergedMap[nestedRelation.foreignKey] = nestedEntity.id;
              //            mergedMap[nestedRelation.fieldName] = null;
            } else {
              print(
                  'ORM L568, Nested persistence failed or nested entity id is null');
            }
            print("FIN UPSERT RECURRENCE Logic for nested entities");

          } else {
            print('ORM L571, No matching relation found for key $key');
          }

          print('ORM L574 , upsert ,After reUseIfExist, got: $persistedNested');

          //I must delete this to avoid double persistence?
          //var controllerNested= '${nestedEntity.runtimeType.toString()}Controller';
          // print('ORM L621 upsert,   controllerNested: $controllerNested');
          var controllerFunction = ControllerIndex[
          '${nestedEntity.runtimeType.toString()}Controller'] as Function;
          Controller controllerNested = controllerFunction();


          print('ORM L584 I goes here');
          if (controllerNested.repository == null) {
            await controllerNested.initRepository();
          }
          if (await controllerNested.ready) {
            print('ORM L589 I goes here');
            var persist =
            index_ControllerFunctionMap[controllerNested]!['persist']
            as Function;
            print('ORM L593 upsert, persist function : $persist');
            entityNestedPersisted = await persist(persistedNested);


            print(
                'ORM L598 upsert, Returned entityNestedPersisted: $entityNestedPersisted');
            print(
                'ORM L600 upsert, Returned entityNestedPersisted.id: ${entityNestedPersisted?.id}');
          }
        } catch (e, stack) {
          print('Exception during nested persistence: $e\n$stack');
          rethrow;
        }
        print(
            'ORM L607, After persist call, entityNestedPersisted: $entityNestedPersisted');

        if (entityNestedPersisted?.id != null) {
          print(
              'ORM L611 upsert, Updating mergedMap foreign key ${relation.foreignKey} with id ${entityNestedPersisted.id}');
          getUpdatedMap(existing)![relation.foreignKey] = entityNestedPersisted.id;
          getUpdatedMap(existing)![relation.fieldName] = null;
        } else {

          print('ORM L616 upsert, Persistence failed or id is null on nested entity');
        }
      }
    }}

    //Deep merge of nested entity
    mergeMapsShallow(  getUpdatedMap(existing)!, entityMap, relation: relation);
    /* or you can use (but only merge level 1)
    entityMap.forEach((key, value) {
      if (value != null) mergedMap[key] = value;
    });*/

    if (existingMap!.containsKey('id')) {
      getUpdatedMap(existing)!['id'] = existingMap['id'];
      ret = await relatedController.update(parameters:   getUpdatedMap(existing)!);
    } else {
      var createRet = await relatedController.create(  getUpdatedMap(existing)!);
      if (createRet?.value?.id != null) {
        getUpdatedMap(existing)![relation.foreignKey] = createRet.value.id;

        var controller =
        controllerIndex["${entity.runtimeType.toString()}Controller"]
            ?.call();
        if (controller != null) {
          await controller.ready;
          ret = await controller.update(parameters:   getUpdatedMap(existing));
        } else {
          ret = true;
        }
      } else {
        ret = false;
        print('show mergedMap: ${getUpdatedMap(existing)}');
      }
    }

    print('ORM L651, persist, show mergedMap:  ${getUpdatedMap(existing)}');
    //updatedMaps[getOrAssignKey(existing)] =   getUpdatedMap(existing);
    return ret;
  }



  Future<bool> upsertSaved(dynamic entity, EntityInterface existing,
      relatedController, RelationMeta relation) async {
    var ret;
    final existingMap = existing.toJson() ?? {};
    final entityMap = entity.toJson() ?? {};
    final mergedMap = Map<String, dynamic>.from(existingMap);


    print('ORM L493 : DEBUG :  type : ${entity.runtimeType.toString()},  entity : $entity.toString');
    print("ORM L494, DEBUG upsert: entity type: ${entity.runtimeType}, existing id: ${existing.id}");
    print('ORM L495, : entityMap:${entityMap.toString()}');
    print('ORM L496, : existingMap:${existingMap.toString()}');

    // Persist nested entities properly and update foreign keys
    for (var entry in entityMap.entries) {
      var key = entry.key;
      var value = entry.value;
      var keyFUpper = key.toString().firstToUpperCase();


      // print('ORM L520, : entry:${entry.toString()}'); //Display MapEntry
      // print("ORM L521, $keyFUpper");
      p_v1("$keyFUpper");
      if (entityIndex.containsKey(keyFUpper) && value != null && value != {}) {

        print(
            "ORM L532 DEBUG processing nested key: $key for entity type: ${entity.runtimeType}");
        var fromMap = entityIndex[keyFUpper]['fromMap'] as Function;


        print('ORM L529, : value : ${value.toString()} ');

        var nestedEntity = fromMap(value);
        print(
            'ORM L533 Attempting to reuse or persist nested entity: $nestedEntity');
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

            print("UPSERT RECURRENCE Logic for nested entities");
            var existingNested = persistedNested ?? nestedEntity;
            Controller nestedController =
                ControllerIndex['${nestedEntity.runtimeType}Controller']!();

            bool isNestedUpserted = await upsert(
              nestedEntity,
              existingNested,
              nestedController,
              nestedRelation,
            );

            if (isNestedUpserted != null && nestedEntity.id != null) {
               getUpdatedMap(existing)![nestedRelation.foreignKey]= nestedEntity.id;
               getUpdatedMap(existing)![nestedRelation.fieldName]= null;
               persistedNested.
              mergedMap[nestedRelation.foreignKey] = nestedEntity.id;
              mergedMap[nestedRelation.fieldName] = null;
            } else {
              print(
                  'ORM L568, Nested persistence failed or nested entity id is null');
            }
          } else {
            print('ORM L571, No matching relation found for key $key');
          }

          print('ORM L574 , upsert ,After reUseIfExist, got: $persistedNested');

          //I must delete this to avoid double persistence?
          //var controllerNested= '${nestedEntity.runtimeType.toString()}Controller';
          // print('ORM L621 upsert,   controllerNested: $controllerNested');
          var controllerFunction = ControllerIndex[
              '${nestedEntity.runtimeType.toString()}Controller'] as Function;
          Controller controllerNested = controllerFunction();


          print('ORM L584 I goes here');
          if (controllerNested.repository == null) {
            await controllerNested.initRepository();
          }
          if (await controllerNested.ready) {
            print('ORM L589 I goes here');
            var persist =
                index_ControllerFunctionMap[controllerNested]!['persist']
                    as Function;
            print('ORM L593 upsert, persist function : $persist');
            entityNestedPersisted = await persist(persistedNested);


            print(
                'ORM L598 upsert, Returned entityNestedPersisted: $entityNestedPersisted');
            print(
                'ORM L600 upsert, Returned entityNestedPersisted.id: ${entityNestedPersisted?.id}');
          }
        } catch (e, stack) {
          print('Exception during nested persistence: $e\n$stack');
          rethrow;
        }
        print(
            'ORM L607, After persist call, entityNestedPersisted: $entityNestedPersisted');

        if (entityNestedPersisted?.id != null) {
          print(
              'ORM L611 upsert, Updating mergedMap foreign key ${relation.foreignKey} with id ${entityNestedPersisted.id}');
          mergedMap[relation.foreignKey] = entityNestedPersisted.id;
          mergedMap[relation.fieldName] = null;
        } else {

          print('ORM L616 upsert, Persistence failed or id is null on nested entity');
        }
      }
    }

    //Deep merge of nested entity
    mergeMapsShallow(mergedMap, entityMap, relation: relation);
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

    p('persist, show mergedMap: $mergedMap',"L832");
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
    p('findByFields : entity(before request to Bdd) :${entity.toString()}','L852');
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
          p('debug, function isA , updatedMaps :  $map!','L881');
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
   // p( isAwReuse entity to persist: $entity',"");

    for (final rel in relations.where((r) => r.type == RelationType.isA)) {
      p('isAwReuse entity to persist: $entity','L901');
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


      p('Type:${relatedPersisted.runtimeType} ${updatedMap.toString()}',"L744");

      updatedMaps[getOrAssignKey(entity)] = updatedMap;

      p('entity Type:${relatedPersisted.runtimeType}  save in updatedMaps: ${updatedMaps[getOrAssignKey(entity)]}',"L749");
      return relatedPersisted;
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
      p('parameter entity : ${entity.toString()}',"L746");
      var fromMap = Entity_Index[rel.relatedType]["fromMap"] as Function;
      Map<String, dynamic>? mappedEntity = entity.toJson(); //main entity User
      String relatedEntity = rel.fieldName;
      p('relatedEntity: $relatedEntity',"L949");
      //print('ORM L742: ${entity.runtimeType.toString()} mappedEntity : $mappedEntity');

      String fkInCamel = StringLib.snakeToCamel(rel.foreignKey);
      var id;
      if (mappedEntity?[relatedEntity] != null) {
        ret = fromMap(mappedEntity?[relatedEntity]);
        p('superentity: ${ret!}',"L748");
        storeUpdatedMap(ret!);
      } else if (mappedEntity?[fkInCamel] != null) {
        try {
          p('${mappedEntity?[fkInCamel]}','L960');
          id = mappedEntity?[fkInCamel];
          p('foreignId ${id}','L962');

          var findById = index_ControllerFunctionMap[
                  '${relatedEntity.firstToUpperCase()}Controller']!['getEntity']
              as Function;

          //  print('ORM L924: ${findById.toString()}');
          ret = await findById(id);

          p('superentity: ${ret!}','L927');
          storeUpdatedMap(ret!);
        } catch (e, s) {
          print("ORM 929, error :$e \r stack: $s");
        }
      } else {
        p(
            'No related entity or foreign key found for ${relatedEntity} / ${fkInCamel}.','L979');
      }

      if (ret != null) {
        p('${ret.toString()}','L773');
        p('SuperEntity from Map: ${getUpdatedMap(ret!)}','L774');}
    } catch (e, stack) {
      p('Error : $e \r Stack: $stack','L769');
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
          await childController.save(updatedChild);
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
      p("$childType",'L188');
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
            await childController.save(updatedChild);
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
            childEntityPersisted = await childController.save(child);
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
      //print('ORM L1246, id person  for ${entityMap[rel.fieldName]?['id']}');
      p(' fieldName ${rel.fieldName}','L1247');
      p('Entity id ${entityMap['id']}','L1247');
      p('entity related   ${entityMap[rel.fieldName]}','L1247');
      p(' entity related id  ${entityMap[rel.fieldName]!['id']}','L1247');

      final childController = controllerIndex["${childType}Controller"]?.call();
      if (childController == null) continue;
      //final childId = int.parse(entityMap[rel.fieldName]?['id']);  //fieldName= person
      final childMap = entityMap[rel.fieldName];
      int childId;
      if (childMap != null && childMap['id'] != null) {
        childId = int.parse(childMap['id'].toString());
        p(   'childId Type:${childId.runtimeType.toString()}, id: ${childId}','1260');

        if (childId != null) {
          try {
            await deleteWithCascade(childType, childId,
                deletedEntities: deletedEntities);
          } catch (e) {
            p( " error to delete ${childType.toString()} with id ${childId}","1268");
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
      p('replaceKey: Moved map from $oldKey to $newKey',"L1396");
    } else {
      p('replaceKey: No map moved - either missing oldKey or same keys','L1398');
    }
  }
}
