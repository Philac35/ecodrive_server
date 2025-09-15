import 'package:shared_package/BDD/Interface/entityInterface.dart';
import 'package:shared_package/BDD/Model/Index/Entity_Index.dart';

import '../../Library/StringLibrary/string_librairy.dart';
import '../../Services/LogSystem/LogFunction.dart';
import 'package:shared_package/BDD/ORM/Relations/RelationMeta.dart';

class EntityMapper{

  late Map<String, Map<String, dynamic>> updatedMaps;

  EntityMapper(){
    updatedMaps={};
  }


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

  Future<EntityInterface?> getUpdatedEntity(EntityInterface entity) async {
    Map<String,dynamic> m= updatedMaps[getOrAssignKey(entity)]!;
    return   fromMap(entity.runtimeType.toString(),m);
  }

  Future<bool> hasPersistedEntityMapById(EntityInterface entity,int id) async {
    String entityType=entity.runtimeType.toString();
     return  updatedMaps.containsKey('$entityType#$id');

  }


  Future<EntityInterface?> getUpdatedEntityById(String entityType,int id) async {
    Map<String,dynamic> m= updatedMaps['$entityType#$id']!;
    return   fromMap(entityType,m);
  }

  bool hasUpdatedMap(EntityInterface entity) {
    if (entity.id == null) return false;

    final key = getOrAssignKey(entity);
    return updatedMaps.containsKey(key);
  }

  bool hasPersistedEntityMap(EntityInterface entity){
    final key = getOrAssignKey(entity);
    if (entity.id == null) return false;
    if (key.contains(RegExp(r'#\d+'))) return true;

    if (key.contains(RegExp(r'@temp'))) return false;

    return updatedMaps.containsKey(key);

  }

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
      e.cascadeTempKey = '${identityHashCode(e)}';
    }
    var tempKey= '${e.runtimeType}@temp${(e as dynamic).cascadeTempKey}';
    return tempKey;
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
      p('replaceKey: Moved map from $oldKey to $newKey',"L65");
    } else {
      p('replaceKey: No map moved - either missing oldKey or same keys','L67');
    }
  }


  Future<EntityInterface?>  fromMap(String entityType, Map<String,dynamic>row) async{
    var fromMap=Entity_Index[entityType]!['fromMap'] as Function;
    return fromMap(row);
  }


  /*
  * Function mergeMapsDeep
  * mergeShallow nested map of nested Entity
  * @Param Map target
  * @Param Map source
  * @Return target updated
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


}