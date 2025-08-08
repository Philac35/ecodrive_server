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
  late Map updatedMap;

  MySQLConnectionPool? connexionPool;
  QueryExecutor? executor;

  ORM()
      : entityIndex = Entity_Index,
        classRelationsIndex = ClassRelationsIndex,
        controllerIndex = ControllerIndex {
    initMySqlPoolConnection();
    executor = MySqlPoolExecutor(connexionPool!);
    updatedMap={};
  }

  initMySqlPoolConnection() {
    MysqlConnection c = MysqlConnection();
    connexionPool = c.connectPool();
  }

  //ORM Angel3 Persist Logic
  //Implementation persist Entity with cascading abilities
  Future<EntityInterface?> persist(dynamic entity) async {
    //print("ORM L40, entity:  ${entity}");
    final entityType = entity.runtimeType.toString();

    Map<String, dynamic> entityMap = entity.toJson();
    //print("ORM L44, entity:  ${entityMap}");
    final relations = classRelationsIndex[entityType] ?? [];

     updatedMap = Map<String, dynamic>.from(entityMap);

    // Parents (belongsTo / hasOne)
    await cascadeParentsR(relations);

    // print("ORM L53, entity:  ${updatedMap}");
    // Main entity save
    final fromMap = entityIndex[entityType]['fromMap'] as Function;
    var updatedEntity = fromMap(updatedMap);

    var updatedMa = await isAwReuse(relations, updatedEntity);
    if (updatedMa != null) {
      updatedEntity = fromMap(updatedMa);
    }
    print('ORM L63, debug, superEntity :  $updatedEntity!');

    final controller = controllerIndex["${entityType}Controller"]?.call();

    if (controller == null) {
      print('ORM ERROR: No controller found for $entityType!');
      throw Exception('No controller found for $entityType');
    }

    await controller.initRepository();

    final persistedEntity = await controller.save(updatedEntity);
    print('ORM L75, Main Entity Persisted in DB: $persistedEntity');

    //After parent insert we manage child Entities and check each relations:
    await hasOne(relations,  persistedEntity);
    await hasMany(relations, persistedEntity);
    await belongTo(relations, persistedEntity);

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

      final entityIndexEntry = Entity_Index[relatedType];
      if (entityIndexEntry == null) continue;

      final relatedFromMap = entityIndexEntry['fromMap'] as Function;
      //print("ORM L92, related entity ${relatedFromMap} ");
      var related = updatedMap[rel.fieldName];

      //print("ORM L208,debug related entity ${related.runtimeType.toString()} belongsTo}");

      if (related != null) {
        if (related is Map) related = relatedFromMap(related);
        EntityInterface? relatedPersisted;

        //ReuseIfExits -> reuse child in parent record if it preexist
        relatedPersisted= reUseIfExist(related, rel);

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
      var existing = await findByFields(relation, entity);
      print("ORM 118 findByFields ${existing}");
      if (existing != null) {
        updatedMap[relation.foreignKey] = existing.id;
        updatedMap[relation.fieldName] =  null; //The related entity was persisted, we delete the content of rel.fieldName
        relatedPersisted = existing;
      } else {
        print(
            "ORM L124, No entity was found with findByFields we persist bared related Entity");
        relatedPersisted = await persist(entity);
      }
      print(
          "ORM L127, Reuse related entity ${entity.runtimeType.toString()}");
    } else {
      print(
          "ORM L130, related entity ${entity.runtimeType.toString()} persist triggered}");
      relatedPersisted = await persist(entity);
    }
    return relatedPersisted;
    }
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

          await cascadeParents(
              classRelationsIndex[superEntity.runtimeType.toString()]);
          final persistedSuper = await persist(superEntity);

          // Update foreign key / IDs if needed
          String foreignKey = rel.foreignKey.camelToSnake();
          updatedMap[foreignKey] = persistedSuper?.id;
          print('ORM L165, debug, function isA , updatedMap :  $updatedMap!');
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
        EntityInterface? superEntity = getSuperEntity(entity, rel);
        if (superEntity != null && updatedMap != null) {
          // Recursively cascade persist the super entity
          //TODO We must have a ReuseIfExist
          await cascadeParents(
              classRelationsIndex[superEntity.runtimeType.toString()]);

           superEntity=(await reUseIfExist(superEntity!, rel))??superEntity;
          final persistedSuper = await persist(superEntity);

          // Update foreign key / IDs if needed
          String foreignKey = rel.foreignKey.camelToSnake();
          updatedMap[foreignKey] = persistedSuper?.id;
          print('ORM L165, debug, function isA , updatedMap :  $updatedMap!');
          return updatedMap;
        }
      }
    }
  }

//Helper isA functions
  getSuperEntity(EntityInterface entity, RelationMeta rel) {

    var fromMap = Entity_Index[rel.relatedType]["fromMap"] as Function;
    return fromMap(entity.toJson()!);
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
            print("ORM L230, related entity persisted");
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
}
