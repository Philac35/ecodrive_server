import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_package/BDD/Connection/MysqlConnection.dart';
import 'package:shared_package/BDD/Executor/MysqlPoolExecutor.dart';

import '../../../Controller/Controller.dart';
import '../../../Controller/Index/Controller_index_unified.dart';
import '../../Interface/entityInterface.dart';
import '../EntityMapper.dart';
import '../Relations/RelationMeta.dart';
import 'PersistenceServiceInterface.dart';


class CTIPersistenceService implements PersistenceServiceInterface {

  final MySqlPoolExecutor executor;
   late GetIt getIt;
  //final DatabaseAdapter db; // abstract adapter (Postgres, SQLite, etc.) Should be interesting but doesn't work with Angel for now

  late final EntityMapper mapper; // maps runtimeType <-> fromMap

  CTIPersistenceService(
      this.executor,
      )
  {
    getIt= GetIt.instance;
    mapper= getIt<EntityMapper>();
  }
  @override
  Future<EntityInterface?> findByFields(RelationMeta relation,
      EntityInterface entity) async {
    if (relation.findBy.isEmpty) return null;

    final where = <String, dynamic>{};
    for (var field in relation.findBy) {
      where[field] = entity.toJson()?[field];
    }

    EntityInterface? entityRelated = await (await _getFunctionMap(
        entity.runtimeType.toString()))!['findByFields']!(
      //relation.relatedType,
        where); //ToDebug 1/09/2025
    if (entityRelated == null) return null;
    return entityRelated;
    //return mapper.fromMap(relation.relatedType, row);
  }

  /// Fetch all entities of the related type matching the given fields  
  Future<List<EntityInterface?>?> findAllByFields(RelationMeta relation,
      Map<String, dynamic> fields) async {
    //See if there is not a list of  relations instead of simple relation.
    final table = relation.relatedType;
    final funcMap = await _getFunctionMap(table);

    if (funcMap == null || !funcMap.containsKey('findByFields')) {
      throw StateError('No findBy function found for $table');
    }

    // Call the findByFields function with the fields
    final List<EntityInterface>? res = await funcMap['findByFields']!(fields);

    return res;
  }

  Future<EntityInterface?> findById(String type, int id) async {
    final row = await (await _getFunctionMap(type))!['getEntity'](id);
    if (row == null) return null;

    return row;
  }


  @override
  Future<EntityInterface?> persist(EntityInterface entity) async {
    final map = entity.toJson();

    final existing = mapper.getUpdatedMap(entity);

    // recursion guard: already being processed
    if (existing != null && identical(existing, entity)) {
      return entity;
    }


    String entityType = entity.runtimeType.toString();
   // final inserted = await (await _getFunctionMap(
     //   entityType))!['create'](parameters:map);
    final inserted =await (await _getController(entityType))!.save(entity);
    print("CTIPersistanceService L88, entity inserted:  $inserted");

    if (inserted != null) {
      mapper.replaceKey(entity, inserted!);
      mapper.storeUpdatedMap(inserted!);
      return inserted;
    }

    return entity;
  }


  Future<Map<String, dynamic>?> _getFunctionMap(String entityType) async {
    var functionMap = ControllerIndex["${entityType}Controller"]!["functionMap"];
    if (functionMap == null) {
      print("PersistenceService: No functionMap for ${entityType}Controller");
      return null;
    }
    return functionMap;
  }


  /*
  * Function mergeMapsDeep
  * mergeShallow nested map of nested Entity
  * @Param Map target
  * @Param Map source
  */
  Map<String, dynamic> mergeMapsDeep(Map<String, dynamic> target,
      Map<String, dynamic> source, {RelationMeta? relation}) {
    source.forEach((key, value) {
      if (key == relation?.foreignKey) return; //protect foreignKey
      if (value != null) {
        if (value is Map<String, dynamic> && target[key] is Map) {
          mergeMapsDeep(target[key], value, relation: relation);
        } else {
          target[key] = value;
        }
      }
    });
    return target;
  }
  Future<EntityInterface?> update(EntityInterface entity) async {
    final map = entity.toJson();

    String entityType = entity.runtimeType.toString();
    //
    EntityInterface? inserted = await (await _getFunctionMap(
        entityType))!['update'](parameters: map);
    //Somewhere here List dynamic is not subtype of Map <String,dynamic> in type cast ( cf type cast Person)
    print("CTIPersistanceService L131  $inserted");

    if (inserted != null) {
      mapper.replaceKey(entity, inserted!);
      mapper.storeUpdatedMap(inserted!);
      return inserted;
    }

    return entity;
  }


  @override
  Future<EntityInterface?> upsert(EntityInterface newEntity,
      EntityInterface existingEntity,
      RelationMeta relation) async {

    Map<String,dynamic> newEntityMap=newEntity.toJson()!;
    Map<String,dynamic> existingEntityMap = existingEntity.toJson()!;
    String newEntityType=  newEntity.runtimeType.toString();
    String existingEntityType=  existingEntity.runtimeType.toString();
    final res;
    var exist = null;
    if (existingEntity.id != null) {
      var functionMap = await _getFunctionMap(existingEntityType);
      var exit = functionMap!['getEntity']!(int.parse(existingEntity.id));


      if (exist != null) {
        Map<String, dynamic> entityMap = mergeMapsDeep(
            newEntityMap!, existingEntityMap!, relation: relation);

        res = await (await _getFunctionMap( existingEntityType))!['update']( entity:existingEntity);
      } else {
        res = await (await _getFunctionMap(existingEntityType))!['create']!( parameters:newEntityMap );
      }
      return mapper.fromMap(newEntityType, res);
    }
  }


  @override
  Future<EntityInterface?> persistFromMap(String entityType,
      Map<String, dynamic> map) async {
    final inserted = await (await _getFunctionMap(entityType))!['create'](
     map);
    return mapper.fromMap(entityType, inserted);
  }


  Future<Controller?> _getController(String entityType) async {
    final controller = ControllerIndex["${entityType}Controller"]!["controller"].call();
    if (controller == null) {
      print("PersistenceService: No controller for $entityType");     return null;
    }
    await controller.ready;
    return controller;
  }

    _defaultPivotName(RelationMeta relation) {
      return '${relation.fieldName}_${relation.relatedType}'.toLowerCase();
    }



  Future<void> insertPivotTuple(
      RelationMeta relation,
      String joinTable,
      dynamic ownerId,
      dynamic relatedId,
      ) async {
    final sql = '''
    INSERT INTO $joinTable (${relation.joinParentForeignKey}, ${relation.joinChildForeignKey})
    VALUES (?, ?)
    ON DUPLICATE KEY UPDATE ${joinTable}_left_id = ${joinTable}_left_id
  ''';

    await executor.query(joinTable,sql, {relation.joinParentForeignKey:ownerId, relation.joinChildForeignKey:relatedId});
  }

  @override
  Future<void> deletePivot(RelationMeta relation, dynamic entityId) async {
    final pivotTable = relation.pivotTable ?? _defaultPivotName(relation);

    final sql = 'DELETE FROM $pivotTable WHERE ${relation.foreignKey} = :${relation.foreignKey}';
    Map<String, dynamic> parameters = {"id", entityId} as Map<String, dynamic>;
    await executor.query(pivotTable, sql, parameters);
  }

  /// Delete a specific tuple in the pivot table (owner + related)
  Future<void> deletePivotTuple(RelationMeta relation,
      dynamic ownerId,
      dynamic relatedId) async {
    final pivotTable = relation.pivotTable ?? _defaultPivotName(relation);
    final sql = 'DELETE FROM $pivotTable WHERE ${relation
        .foreignKey} = ? AND ${relation.relatedKey} = ?';
    Map<String, dynamic> parameters = {
      relation.foreignKey: ownerId,
      relation.relatedKey: relatedId
    } as Map<String, dynamic>;

    await executor.query(pivotTable, sql, parameters);
  }

  @override
  Future<bool> delete(dynamic entityOrId) async{
    String entityType=entityOrId.runtimeType.toString();
    return (await _getFunctionMap(
        entityType))!['delete'](entityOrId);
  }

}