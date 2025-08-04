import 'package:angel3_orm/angel3_orm.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_package/BDD/Connection/MysqlConnection.dart';
import 'package:shared_package/Controller/Index/Index_ControllerFunction.dart';
import 'package:shared_package/Controller/Index/Controller_index.dart';
import '../../Controller/Index/Controller_index.dart';
import '../Executor/MysqlPoolExecutor.dart';
import 'ORMExtension/SymbolToStringConverter.dart';
import 'Relations/ClassRelation_Index.dart';
import '../Interface/entityInterface.dart';
import '../Model/Index/Entity_Index.dart';

class ORM{

  Map <String, dynamic>  controllerIndex;
  Map <String, dynamic>  entityIndex;
  Map <String, dynamic>  classRelationsIndex;

  MySQLConnectionPool? connexionPool;
  QueryExecutor? executor;


   ORM(): entityIndex=Entity_Index,
                     classRelationsIndex= ClassRelationsIndex,
                     controllerIndex=ControllerIndex
  {
    initMySqlPoolConnection();
    executor= MySqlPoolExecutor( connexionPool!);
  }


  initMySqlPoolConnection()  {

    MysqlConnection c= MysqlConnection();
    connexionPool = c.connectPool();

  }

  //ORM Angel3 Persist Logic
  //Implementation persist Entity with cascading abilities
  Future<EntityInterface?> persist(dynamic entity) async {
    //print("ORM L40, entity:  ${entity}");
    final entityType = entity.runtimeType.toString();
    final fromMap = entityIndex[entityType]['fromMap'] as Function;
    Map<String, dynamic> entityMap = entity.toJson();
    //print("ORM L44, entity:  ${entityMap}");
    final relations = classRelationsIndex[entityType] ?? [];

    var updatedMap = Map<String, dynamic>.from(entityMap);



    // Parents (belongsTo / hasOne)
    await cascadeParents(relations, updatedMap);


   // print("ORM L53, entity:  ${updatedMap}");
    // Main entity save
    final updatedEntity = fromMap(updatedMap);
    await isA(relations,updatedMap,updatedEntity);


    final controller = controllerIndex["${entityType}Controller"]?.call();

    if (controller == null) {
      print('ORM ERROR: No controller found for $entityType!');
      throw Exception('No controller found for $entityType');
    }

    await controller.initRepository();




    final persistedEntity =await controller.save(updatedEntity);
    print('ORM L70, Main Entity Persisted in DB: $persistedEntity');


    //After parent insert we manage child Entities and check each relations:
    await hasOne(relations,updatedMap,persistedEntity);
    await hasMany(relations,updatedMap,persistedEntity);
    await belongTo(relations,updatedMap,persistedEntity);

    return persistedEntity;
  }

  /**
   * Function cascadeParents
   * Parents (belongsTo / hasOne)
   * Save entities related return updatedMap of parent Entities
   */
    Future<void> cascadeParents(
      Iterable relations,
      Map<String, dynamic> updatedMap,
      ) async {
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
        var relatedController = controllerIndex["${relatedType}Controller"]?.call();
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
              updatedMap[rel.fieldName] = null;  //The related entity was persisted, we delete the content of rel.fieldName
              relatedPersisted=existing;
            }else{
              print("ORM L124, No entity was found with findByFields we persist bared related Entity");
              relatedPersisted = await persist(related);
            }
            print("ORM L127, Reuse related entity ${related.runtimeType.toString()}");

        } else {
          print("ORM L130, related entity ${related.runtimeType.toString()} persist triggered}");
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
  }}


  Future<void> isA(List<RelationMeta> relations, Map<String, dynamic> updatedMap, EntityInterface entity) async {
    for (final rel in relations.where((r) => r.type == RelationType.isA))  {
      if (rel.type == RelationType.isA) {
        final superEntity = getSuperEntity(entity, rel);
        if (superEntity != null && updatedMap !=null) {
          // Recursively cascade persist the super entity
          await cascadeParents(classRelationsIndex[superEntity.runtimeType.toString()], updatedMap);
          final persistedSuper = await persist(superEntity);
          // Update foreign key / IDs if needed
          updatedMap[rel.foreignKey] = persistedSuper?.id;
        }
      }
    }
  }

   getSuperEntity(EntityInterface  entity,RelationMeta rel){

     //Map<Symbol,dynamic> m=SymbolToStringConverter.convertStringKeysToSymbol(entity.toJson()!);
   //  print("ORM L171 $m");
     var fromMap=Entity_Index[rel.relatedType]["fromMap"] as Function;
     return fromMap(entity.toJson()!);
     //return Function.apply(Entity_Index[rel.relatedType]["fromMap"]!(),null,m);

   }

  /**
   * Function hasOne
   */
  Future <void> hasOne(List<RelationMeta> relations,
      Map<String, dynamic> updatedMap,
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
  Future <void> hasMany(List<RelationMeta> relations,
      Map<String, dynamic> updatedMap,
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
          var childController = controllerIndex["${childType}Controller"]
              ?.call();
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
  Future <void> belongTo(List<RelationMeta> relations,
      Map<String, dynamic> updatedMap,
      EntityInterface? persistedEntity) async {
    for (final rel in relations.where((r) =>
    r.type == RelationType.belongsToMany)) {
      final childType = rel.relatedType;
      final childFromMap = Entity_Index[childType]['fromMap'] as Function;
      final children = updatedMap[rel.fieldName] as List<dynamic>?;
      if (children != null) {
        final parentId = (persistedEntity as dynamic).toJson()['id'];
        if (parentId == null) throw Exception(
            'Parent id null for belongsToMany!');
        for (var child in children) {
          if (child is Map) child = childFromMap(child);

          // Persist child if it's new
          var childEntityPersisted;
          var childController = controllerIndex["${childType}Controller"]
              ?.call();
          if (childController != null) {


            childEntityPersisted = await childController.persist(child);
            print("ORM L230, related entity persisted");
          } else {
            childEntityPersisted = await persist(child);
            print("ORM L230, related entity persisted");
          }
          final childId = childEntityPersisted.toJson()['id'];
          if (childId == null) throw Exception(
              'Child id null for belongsToMany!');

          // Insert join table entry (assume join table and field names available in rel)
          await insertJoinTableRow(rel.fieldName, {
            // joinParentForeignKey
            // joinChildForeignKey=foreignKey;
            //TOCheck 20/07/2025
            classRelationsIndex[persistedEntity].foreignKey: parentId, // e.g. student_id
            rel.foreignKey: childId, // e.g. course_id
          });
        }
      }
    }
  }

  /**
   * Function insertJoinTableRow
   */
  Future<void> insertJoinTableRow( String table,  Map<String, dynamic> fields,      ) async {
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
      Future<void> Function(dynamic) persistChild
      ) async {
    if (children == null) return;
    final parentId = (persistedEntity as dynamic).toJson()['id'];
    if (parentId == null) throw Exception("Parent id is null for hasMany cascade on $relationName");
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
   */
  Future<void> deleteWithCascade(
      String entityType,
      dynamic entityOrId,
      ) async {
    // 1. Find the entity if only ID was given
    final controller = controllerIndex["${entityType}Controller"]?.call();
    if (controller == null) throw Exception('No controller for $entityType');
    final entity = entityOrId is EntityInterface
        ? entityOrId
        : await controller.repository?.findById(entityOrId);

    if (entity == null) throw Exception('Entity not found');

    final relations = (classRelationsIndex[entityType] ?? {}).values;

    // 2. For each hasMany/hasOne/belongsToMany child: cascade delete
    final entityMap = entity.toJson();

    // hasOne (direct child)
    for (final rel in relations.where((r) => r.type == RelationType.hasOne && r.cascadeOnDelete)) {
      final childType = rel.relatedType;
      final childController = controllerIndex["${childType}Controller"]?.call();
      if (childController == null) continue;
      final childId = entityMap[rel.fieldName]?['id'];
      if (childId != null) {
        await deleteWithCascade(childType, childId);
      }
      // --- hasMany (multiple children) ---
      for (final rel in relations.where((r) => r.type == RelationType.hasMany && r.cascadeOnDelete)) {
        final childType = rel.relatedType;
        final childController = controllerIndex["${childType}Controller"]?.call();
        if (childController == null) continue;
        final children = entityMap[rel.fieldName] as List<dynamic>? ?? [];
        for (final child in children) {
          final childId = child['id'];
          if (childId != null) {
            await deleteWithCascade(childType, childId);
          }
        }
      }

      // --- belongsToMany (clean up join table, and optionally remote entities on flag) ---
      for (final rel in relations.where((r) => r.type == RelationType.belongsToMany)) {
        // Always remove join table rows
        await deleteJoinTableRows(rel.joinTable, rel.joinParentForeignKey, entityMap['id']);
        // If cascadeOnDelete, remove the OTHER entity as well
        if (rel.cascadeOnDelete) {
          final children = entityMap[rel.fieldName] as List<dynamic>? ?? [];
          for (final child in children) {
            final childType = rel.relatedType;
            final childId = child['id'];
            if (childId != null) {
              await deleteWithCascade(childType, childId);
            }
          }
        }
      }

      // --- finally: delete this entity ---
      await controller.repository?.delete(entityMap['id']);

    }

    // hasMany
    for (final rel in relations.where((r) => r.type == RelationType.hasMany)) {
      final childType = rel.relatedType;
      final childController = controllerIndex["${childType}Controller"]?.call();
      if (childController == null) continue;
      final children = entityMap[rel.fieldName] as List<dynamic>? ?? [];
      for (final child in children) {
        final childId = child['id'];
        if (childId != null) {
          await deleteWithCascade(childType, childId);
        }
      }
    }

    // belongsToMany (join table cleanup only)
    for (final rel in relations.where((r) => r.type == RelationType.belongsToMany)) {
      await deleteJoinTableRows(rel.joinTable, rel.joinParentForeignKey, entityMap['id']);
    }

    // 3. Delete entity itself
    await controller.delete(entityMap['id']);
  }

  Future<void> deleteJoinTableRows(String table, String fkField, dynamic id) async {
    final sql = "DELETE FROM $table WHERE $fkField = :id";
    if (executor == null) throw Exception('executor not set');
    await executor!.query(table, sql, {'id': id});
  }


}