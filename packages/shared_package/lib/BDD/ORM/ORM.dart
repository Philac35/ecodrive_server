import 'package:angel3_orm/angel3_orm.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_package/BDD/Connection/MysqlConnection.dart';
import 'package:shared_package/Controller/Index/Index_ControllerFunction.dart';
import 'package:shared_package/Controller/Index/Controller_index.dart';
import '../../Controller/Controller.dart';
import '../../Controller/Index/Controller_index.dart';
import '../Executor/MysqlPoolExecutor.dart';
import 'ORMExtension/SymbolToStringConverter.dart';
import 'Relations/ClassRelation_Index.dart';
import '../Interface/entityInterface.dart';
import '../Model/Index/Entity_Index.dart';
import 'package:shared_package/Library/StringLibrary/str_extension.dart';

class ORM {
  Map<String, dynamic> controllerIndex;
  Map<String, dynamic> entityIndex;
  Map<String, dynamic> classRelationsIndex;

  late EntityInterface? relatedPersisted;
  late Map<String,dynamic> updatedMap;  //Should be a named map different for each child and parent entities
  late Map<String, Map<String,dynamic> > updatedMaps;


  MySQLConnectionPool? connexionPool;
  QueryExecutor? executor;

  ORM()
      : entityIndex = Entity_Index,
        classRelationsIndex = ClassRelationsIndex,
        controllerIndex = ControllerIndex {
    initMySqlPoolConnection();
    executor = MySqlPoolExecutor(connexionPool!);
    updatedMap={};
    updatedMaps={};
  }

  initMySqlPoolConnection() {
    MysqlConnection c = MysqlConnection();
    connexionPool = c.connectPool();
  }

  //ORM Angel3 Persist Logic
  //Implementation persist Entity with cascading abilities
  Future<EntityInterface?> persist(dynamic entity) async {
    //print("ORM L40, entity:  ${entity}");
    updatedMap=entity.toJson();   //updatedMap become main entity
   var relations=getRelations(entity);

    // Parents (belongsTo / hasOne)
    await cascadeParentsR(relations);

       //Reify entity to be sur of Type
       final entityType = entity.runtimeType.toString();
       final fromMap = entityIndex[entityType]['fromMap'] as Function;

       await isAwReuse(relations, fromMap(updatedMap));

     EntityInterface? persistedEntity=await save(relations,entity);// //Peut avoir été updated


    //After parent insert we manage child Entities and check each relations:
    _cascadeChildren(relations,  persistedEntity) ;

    return persistedEntity;
  }


  Future<void> _cascadeChildren(relations,  persistedEntity) async {
    await hasOne(relations,  persistedEntity);
    await hasMany(relations, persistedEntity);
    await belongTo(relations, persistedEntity);


  }
  getRelations(dynamic entity){
    final entityType = entity.runtimeType.toString();


    //print("ORM L44, entity:  ${entityMap}");
    final relations = classRelationsIndex[entityType] ?? [];
    return relations;
  }

  /**
   * Function save
   * @Param relations
   * @Param EntityInterface entity
   */
  Future<EntityInterface?>save(List<RelationMeta> relations, EntityInterface entity)async{
    final entityType = entity.runtimeType.toString();

   // Map<String, dynamic> entityMap = entity.toJson();
    //updatedMap = Map<String, dynamic>.from(entityMap);
    mergeMapsShallow(updatedMap,entity.toJson()!);

    // print("ORM L53, entity:  ${updatedMap}");
    // Main entity save (can be updated in cascadingParent)
    final fromMap = entityIndex[entityType]['fromMap'] as Function;
    var updatedEntity = fromMap(updatedMap);

     updatedEntity = fromMap(await isAwReuse(relations, updatedEntity)!);

    print('ORM L63, debug, superEntity :  $updatedEntity!');

    final controller = controllerIndex["${entityType}Controller"]?.call();

    if (controller == null) {
      print('ORM ERROR: No controller found for $entityType!');
      throw Exception('No controller found for $entityType');
    }

    await controller.initRepository();

    final persistedEntity = await controller.save(updatedEntity);
    print('ORM L75, Main Entity Persisted in DB: $persistedEntity');
    return persistedEntity;
  }


  /**
   * Function cascadeParentsSaved
   * Parents (belongsTo / hasOne)
   * Save entities related return updatedMap of parent Entities
   */
  Future<void> cascadeParentsSaved(Iterable relations) async {
    for (final rel in relations.where((r) =>
        r.type == RelationType.belongsTo || r.type == RelationType.hasOne)) {
      final relatedType = rel.relatedType;

      final entityIndexEntry = Entity_Index[relatedType];
      if (entityIndexEntry == null) continue;
      final relatedFromMap = entityIndexEntry['fromMap'] as Function;
      //print("ORM L92, related entity ${relatedFromMap} ");
      var related = updatedMap[rel.fieldName];

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
              updatedMap[rel.foreignKey] = existing.id;
              updatedMap[rel.fieldName] =
                  null; //The related entity was persisted, we delete the content of rel.fieldName
              relatedPersisted = existing;
            } else {
              print(
                  "ORM L124, No entity was found with findByFields we persist bared related Entity");
              relatedPersisted = await persist(related);
            }
            print(
                "ORM L127, Reuse related entity ${related.runtimeType.toString()}");
          } else {
            print(
                "ORM L130, related entity ${related.runtimeType.toString()} persist triggered}");
            relatedPersisted = await persist(related);
          }

          print('ORM: L120 relatedPersisted or Reused $relatedPersisted');

          // Update map: set the FK to parent id, remove nested object
          final parentJson = (relatedPersisted as dynamic)!.toJson();
          final parentId = parentJson['id'];
          updatedMap[rel.foreignKey] = parentId;
          updatedMap[rel.fieldName] = null;
        }
      }
    }
  }

  /**
   * Function cascadeParents
   * Parents (belongsTo / hasOne)
   * Save entities related return updatedMap of parent Entities
   */
  Future<void> cascadeParents(Iterable relations) async {
    for (final rel in relations.where((r) =>
        r.type == RelationType.belongsTo || r.type == RelationType.hasOne)) {
      final relatedType = rel.relatedType;


      final entityIndexEntry = Entity_Index[relatedType];
      if (entityIndexEntry == null) continue;
      final relatedFromMap = entityIndexEntry['fromMap'] as Function;
      //print("ORM L92, related entity ${relatedFromMap} ");
      var related = updatedMap[rel.fieldName];

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
          updatedMap[rel.foreignKey] = parentId;
          updatedMap[rel.fieldName] = null;
        }
      }
    }
  }

  /**
   * Function cascadeParentsR
   * With ReuseIfExist
   * Parents (belongsTo / hasOne)
   * Save entities related return updatedMap of parent Entities
   */
  Future<void> cascadeParentsR(Iterable relations) async {
    for (final rel in relations.where((r) =>
        r.type == RelationType.belongsTo || r.type == RelationType.hasOne)) {
      final relatedType = rel.relatedType;

      if(relatedType=='AuthUser'){print("ORM L233,CascadeParents AuthUser will be persisted");}

      final entityIndexEntry = Entity_Index[relatedType];

      if (entityIndexEntry == null) {
        continue;
      } else{print("ORM L237, CascadeParents $relatedType");}
      final relatedFromMap = entityIndexEntry['fromMap'] as Function;
      //print("ORM L92, related entity ${relatedFromMap} ");

      //Fetch fields of entity from updatedMap;
      var related = updatedMap[rel.fieldName];  //here updatedMap is related to Main Entity not Child

      //print("ORM L208,debug related entity ${related.runtimeType.toString()} belongsTo}");
      if(relatedType=='AuthUser'){print("ORM L243,CascadeParents AuthUser :$related");}
      if (related != null) {
        if (related is Map) related = relatedFromMap(related);
        EntityInterface? relatedPersisted;

        //ReuseIfExits -> reuse child in parent record if it preexist
        relatedPersisted= await reUseIfExist(related, rel);

          print('ORM: L120 relatedPersisted or Reused $relatedPersisted');

          // Update map: set the FK to parent id, remove nested object
          final parentJson = (relatedPersisted as dynamic)!.toJson();
          final parentId = parentJson['id'];
          updatedMap[rel.foreignKey] = parentId;
          updatedMap[rel.fieldName] = null;

      }
    }
  }

  /**
   * Function reUseIfExist
   * @Param Map relatedMap
   * @Param RelationMeat relation
   * @Return  Future<EntityInterface?>
   */
  reUseIfExist(
    EntityInterface entity,
    RelationMeta relation

  ) async {

    final relatedType = relation.relatedType;
    var relatedController =  controllerIndex["${relatedType}Controller"]?.call();
    if (relatedController!=null) {
    await relatedController.ready;

    if (relation.reuseIfExists && relation.findBy.isNotEmpty) {
      //Create a Map<key,value> to pass in findByFields
      EntityInterface? existing = await findByFields(relation, entity);
      print("ORM 251 findByFields ${existing}");
      if (existing != null) {

        //Upsert if we need to update preexisting entity
        if(relation.updateIfExist) {
          upsert(entity, existing, relatedController, relation);
        }

        updatedMap[relation.foreignKey] = existing.id;
        updatedMap[relation.fieldName] =  null; //The related entity was persisted, we delete the content of rel.fieldName
        relatedPersisted = existing;
      } else {
        print(
            "ORM L258, No entity was found with Fields we persist bared related Entity");
        relatedPersisted = await persist(entity);
      }
      print(
          "ORM L262, Reuse related entity ${entity.runtimeType.toString()}");
    } else {
      print(
          "ORM L265, related entity ${entity.runtimeType.toString()} persist triggered}");
      relatedPersisted = await persist(entity);
    }
    return relatedPersisted;
    }
  }

  /*
  * Function mergeMapsShallow
  * mergeShallow nested map of nested Entity
  * @Param Map target
  * @Param Map source
  */
  void mergeMapsShallow(Map target, Map source) {
    source.forEach((key, value) {
      if (value != null) {
        if (value is Map && target[key] is Map) {
          mergeMapsShallow(target[key], value);
        } else {
          target[key] = value;
        }
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
  Future<bool> upsert( dynamic entity,EntityInterface existing, relatedController,RelationMeta relation   )async {
    var ret;
    final existingMap = existing.toJson() ?? {};
    final entityMap = entity.toJson() ?? {};
    print('ORM L342: upsert ,  entityMap : $entityMap');
    // Merge: overwrite only non-null values
    final mergedMap = Map<String, dynamic>.from(existingMap);

    //Deep merge of nested entity
    mergeMapsShallow(mergedMap, entityMap);

    /* or you can use (only merge level 1)
    entityMap.forEach((key, value) {
      if (value != null) mergedMap[key] = value;
    });*/
    Type typeRelated = relatedController.runtimeType;
    print('ORM L354: upsert ,  controllertypeRelated : $typeRelated.toString');
    print('ORM L355: upsert ,  typeRelated : $mergedMap');
    if (existingMap.containsKey('id')) {
       //Update
       mergedMap['id'] = existingMap['id'];
      ret = await relatedController.update(parameters: mergedMap);
    } else {
      //Create
      var createRet = await relatedController.create(mergedMap);
      mergedMap['authUserId'] = createRet.value.id;
      var controller = controllerIndex["${entity.runtimeType
          .toString()}Controller"]?.call();
      if (controller != null) {  await controller.ready;}
      print('ORM L364: upsert ,  typeRelated : $mergedMap');
        ret = await controller.update(parameters: mergedMap);
        ret = createRet != null ? true : false;
      }
     updatedMap=mergedMap;// /!\
      return ret; //Update accept Map<string,dynamic>


  }

  /**
   * Function findByFields
   * @Param RelationMeta relation
   * @Map relatedMap
   * Return entity if it preexits in BDD
   * Search by discriminant fields in RelationMeta
   * from List that are translated in Map
   */
  Future<EntityInterface?> findByFields(RelationMeta relation, EntityInterface entity) async {
    final relatedType = relation.relatedType;
    var relatedController = controllerIndex["${relatedType}Controller"]?.call();
    final lookupMap = <String, dynamic>{};
    print('ORM L386:  findByFields entity :${entity.toString()}');
    for (final key in relation.findBy) {
      lookupMap[key] = (entity as dynamic).toJson()[key];
    }
    return  await relatedController.findByFields(lookupMap);
  }


  /**
   * Function isA
   * @Param List<RelationMeta> relations
   * @Param Map<String,dynamic> updatedMap
   * @InterfaceEntity entity
   * @Return Future<Map?>
   */
  Future<Map?> isA(List<RelationMeta> relations, EntityInterface entity) async {
    for (final rel in relations.where((r) => r.type == RelationType.isA)) {
      if (rel.type == RelationType.isA) {
        final superEntity = getSuperEntity(entity, rel);
        if (superEntity != null && updatedMap != null) {
          // Recursively cascade persist the super entity

          await cascadeParentsR(
              classRelationsIndex[superEntity.runtimeType.toString()]);
          final persistedSuper = await persist(superEntity);

          // Update foreign key / IDs if needed
          String foreignKey = rel.foreignKey.camelToSnake();
          updatedMap[foreignKey] = persistedSuper?.id;
          print('ORM L312, debug, function isA , updatedMap :  $updatedMap!');
          return updatedMap;
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
  Future<Map?> isAwReuse(
      List<RelationMeta> relations, EntityInterface entity) async {
    for (final rel in relations.where((r) => r.type == RelationType.isA)) {
      if (rel.type == RelationType.isA) {
                                                  //injection User
        EntityInterface? superEntity = getSuperEntity(entity, rel);


        print('ORM L439: isAwReuse ,  entity : ${entity.toString()}');
        print('ORM L440: isAwReuse ,  superEntity : ${superEntity.toString()}');
        if (superEntity != null && updatedMap != null) {
          // Recursively cascade persist the super entity
          //TODO We must have a ReuseIfExist
          await cascadeParentsR(
              classRelationsIndex[superEntity.runtimeType.toString()]);


        relatedPersisted=  await reUseIfExist(superEntity!, rel);
          /* No need to make it twice
             then it return updatedMap that is done in reUseIfExist

           superEntity=(await reUseIfExist(superEntity!, rel))??superEntity;
         // final persistedSuper = await persist(superEntity);

          // Update foreign key / IDs if needed
          String foreignKey = rel.foreignKey.camelToSnake();
          updatedMap[foreignKey] = persistedSuper?.id;
          print('ORM L343, debug, function isA , updatedMap :  $updatedMap!');
          */
         // it returns updatedMap that is done in reUseIfExist
          return updatedMap;
        }
      }
    }
  }

//Helper isA functions
  /**
   * Function getSuperEntity
   * @Param EntityInterface entity
   * @Param RelationMeta rel
   */
  getSuperEntity(EntityInterface entity, RelationMeta rel) {
    print('ORM L469: fromMap , map : ${entity.toString()}');
    var fromMap = Entity_Index[rel.relatedType]["fromMap"] as Function;
    Map<String, dynamic>? mappedEntity=entity.toJson(); //main entity User
    String relatedEntity= rel.fieldName;
   return  fromMap(mappedEntity?[relatedEntity]);

  }

  /**
   * Function hasOne
   */
  Future<void> hasOne(List<RelationMeta> relations,
      EntityInterface? persistedEntity) async {
    for (final rel in relations.where((r) => r.type == RelationType.hasOne)) {
      final childType = rel.relatedType;
      final childFromMap = Entity_Index[childType]['fromMap'] as Function;
      var child = updatedMap[rel.fieldName];
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
  Future<void> hasMany(List<RelationMeta> relations,
      EntityInterface? persistedEntity) async {
    for (final rel in relations.where((r) => r.type == RelationType.hasMany)) {
      final childType = rel.relatedType;
      print("ORM L188 $childType");
      final childFromMap = Entity_Index[childType]['fromMap'] as Function;
      final children = updatedMap[rel.fieldName] as List<dynamic>?;
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
   * Function belongTo
   */
  Future<void> belongTo(List<RelationMeta> relations,
      EntityInterface? persistedEntity) async {
    for (final rel
        in relations.where((r) => r.type == RelationType.belongsToMany)) {
      final childType = rel.relatedType;
      final childFromMap = Entity_Index[childType]['fromMap'] as Function;
      final children = updatedMap[rel.fieldName] as List<dynamic>?;
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
            rel.foreignKey: childId,
            // e.g. course_id
          });
        }
      }
    }
  }

  /**
   * Function insertJoinTableRow
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
      }
  ) async {

    deletedEntities ??= <String>{};//Prevent delete loop, erasing several time the same entity

    // 1. Find the entity if only ID was given
    final controller = controllerIndex["${entityType}Controller"]?.call();
    if (controller == null) throw Exception('No controller for $entityType');

    if((await controller.ready) == false){await controller.initRepository();}
    final entity = entityOrId is EntityInterface     ? entityOrId
        : await controller.repository!.findById(entityOrId);

    if (entity == null) throw Exception('Entity not found');

    final relations = classRelationsIndex[entityType] ?? {};

    Map<String,dynamic> entityMap = entity.toJson();
  String  id = entityMap['id'];
    // Construct a unique key for this delete operation
    final entityKey = '$entityType-$id';

    // Prevent multiple deletes of the same entity in this chain
    if (deletedEntities.contains(entityKey)) return true;

    deletedEntities.add(entityKey);


    // 2. For each hasMany/hasOne/belongsToMany child: cascade delete

    // hasOne | isA (direct child/Parent)
    for (final rel in relations
        .where((r) => (r.type == RelationType.hasOne || r.type == RelationType.isA ) && r.cascadeOnDelete)) {
      final childType = rel.relatedType;
      //print('ORM L555, id person  for ${entityMap[rel.fieldName]?['id']}');
      print('ORM L555, fieldName ${rel.fieldName}');
      print('ORM L555, Entity id ${entityMap['id']}');
      print('ORM L555, entity related   ${entityMap[rel.fieldName]}');
      print('ORM L555, entity related id  ${entityMap[rel.fieldName]!['id']}');


      final childController = controllerIndex["${childType}Controller"]?.call();
      if (childController == null) continue;
      //final childId = int.parse(entityMap[rel.fieldName]?['id']);  //fieldName= person
      int childId = int.parse(entityMap[rel.fieldName]?['id']);  //fieldName= person
      print(' ORM L540, childId Type:${childId.runtimeType.toString()}, id: ${childId}');
      if (childId != null) {
        try{
        await deleteWithCascade(childType, childId, deletedEntities: deletedEntities);
        }catch(e){print("ORM L568, error to delete ${childType.toString()} with id ${childId}");}
      }

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
            await deleteWithCascade(childType, childId, deletedEntities: deletedEntities);
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
              await deleteWithCascade(childType, childId, deletedEntities: deletedEntities);
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
        final childId =  int.parse(child['id']);
        if (childId != null) {
          await deleteWithCascade(childType, childId, deletedEntities: deletedEntities);
        }
      }
    }

    // belongsToMany (join table cleanup only)
    for (final rel
        in relations.where((r) => r.type == RelationType.belongsToMany)) {
      await deleteJoinTableRows(
          rel.joinTable, rel.joinParentForeignKey,  int.parse(entityMap['id']));
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
      updatedMaps[_getOrAssignKey(entity)] = entity.toJson()!;
    }

    Map<String, dynamic>? getUpdatedMap(EntityInterface entity) {
      return updatedMaps[_getOrAssignKey(entity)];
    }

 //Entity identifiant with persist resilience


  /**
   * Function getOrAssignKey
   * @Param EntityInterface e
   * get unique id key if exist or assign temporary key
   */
  String _getOrAssignKey(EntityInterface e) {
    final id = e.toJson()!['id'];
    if (id != null) {
      return '${e.runtimeType}#$id';
    }
    // Check if entity already has a temp key
    if (!(e as dynamic).cascadeTempKey) {
      (e as dynamic).cascadeTempKey = identityHashCode(e);
    }
    return '${e.runtimeType}@temp${(e as dynamic). cascadeTempKey}';
  }


  /**
   * Function replaceKey
   * Must be used after persistence to reference entities
   * @Param EntityInterface oldEntity
   *  @Param EntityInterface newEntity
   */
  void replaceKey(EntityInterface oldEntity, EntityInterface newEntity) {
    final oldKey = _getOrAssignKey(oldEntity);
    final newKey = _getOrAssignKey(newEntity);
    if (updatedMaps.containsKey(oldKey)) {
      updatedMaps[newKey] = updatedMaps.remove(oldKey)!;
    }
  }


}


