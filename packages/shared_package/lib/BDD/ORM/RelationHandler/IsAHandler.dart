import 'package:get_it/get_it.dart';
import 'package:shared_package/Library/StringLibrary/string_librairy.dart';

import '../../Interface/entityInterface.dart';
import '../../Model/Index/Entity_Index.dart';
import '../EntityMapper.dart';
import '../ORM.dart';
import '../PersistenceService/CTIPersistenceService.dart';
import '../PersistenceService/PersistenceServiceInterface.dart';
import '../Relations/ClassRelation_Index.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/DeletableRelationHandlerInterface.dart';
import 'Interface/RelationHandlerInterface.dart';
import 'Interface/RelationHandlerInterface.dart' show RelationType;


class IsAHandler implements DeletableRelationHandler {
  final PersistenceServiceInterface persistence;
  final EntityMapper mapper;
  ORM? orm;

  IsAHandler(this.persistence,this.mapper,this.orm);

  @override
  Future<EntityInterface?> handle(
      EntityInterface entity,
      RelationMeta relation,
      {
        Set<String>? persistingTracker,
      }
      ) async {
    try {


      final baseType = relation.relatedType;
      final fromMapBase = Entity_Index[baseType]['fromMap'] as Function;

      // Step 1: Persist base entity ( Person)

      //Get baseFields of User that Person manage and Merge with Parent.base field
      final baseFields = _baseFieldsFor(entity, baseType);
      //baseFields must be merge with User.person before being set to persist

      Map relatedField={};
      try{
         int?  id=  entity.getField(StringLib.snakeToCamel(relation.foreignKey));
         if(id!=null){ return  mapper.getUpdatedEntityById(StringLib.snakeToCamel(relation.relatedType),id);}
      }catch(e,s){
        print("IsAHandler  L53, entity with id doesn't exist in updatedMap , error :$e \n $s "); }
      try{
        print("isAHandler L51, updatedMaps : ${mapper.updatedMaps}");
        relatedField=mapper.getUpdatedMap(entity)![relation.fieldName];
      }catch(e,s){

        print("IsHandler L51, entity doesn't exist in updatedMap , error : $e \n $s");

      }

       mapper.mergeMapsDeep(relatedField,baseFields,relation:relation);


      EntityInterface? baseEntity=fromMapBase(relatedField);

      EntityInterface? baseEntityPersisted = await orm?.persist(baseEntity!,
          persistingTracker: persistingTracker);
      if (baseEntityPersisted == null) return null;

      // Step 2: Cascade children of base from baseEntity(that have all the fields merged) (e.g., AuthUser)
      final baseRelations = ClassRelationsIndex[baseType] as List<RelationMeta>? ?? [];
      for (final rel in baseRelations) {
        final handler = orm?.relationHandlers[rel.type];
        if (handler != null) {
          baseEntity?.setField('id', baseEntityPersisted.id);
          //Return modified parent , not the children ->
          var baseEntityUpdated=   await handler.handle(baseEntity!, rel, persistingTracker: persistingTracker);
         if(baseEntityUpdated!=null){baseEntity=baseEntityUpdated;}
        }

      }
      //Update person in BDD after children persist
     var updatedEntity= await persistence.update(baseEntity!);
      // Step 3: Persist subclass (User) with FK to base
      final subclassFields = _subclassFieldsFor(baseEntity!);
      subclassFields[relation.foreignKey] = baseEntityPersisted.id;  //-> serve to nothing operationally
      String FKcamelCase=StringLib.snakeToCamel(relation.foreignKey);
      String RelatedTypelowerCase=relation.relatedType.toLowerCase();
      entity.setField(FKcamelCase, baseEntityPersisted.id is String?int.parse(baseEntityPersisted.id):baseEntityPersisted.id);
      entity.setField(RelatedTypelowerCase,null);
      //var entityPeristed = await orm?.persist(entity,  persistingTracker: persistingTracker);

      // Step 4: Update mapper
      mapper.storeUpdatedMap(baseEntity!); //ParentEntity
     // if (entityPeristed != null) mapper.storeUpdatedMap(entityPeristed); //ChildEntity

      return entity;
    } catch (e, st) {
      print("IsAHandler Error: $e\nstack:$st");
      rethrow;
    }
  }


  /**
   * _baseFieldsFor
   * /!\ don't return entities that all fields are not fullfilled
  * Returns only base table fields for a given entity
  **/
  Map<String, dynamic> _baseFieldsFor(EntityInterface entity, String baseType) {
    print(" fields  for baseType:$baseType : ${Entity_Index[baseType]['fields']}" );
    final baseFieldNames = StringLib().snakeToCamelFromList(Entity_Index[baseType]['fields']) as List<String>? ?? [];
    final json = entity.toJson() ?? {};
    //final json = StringLib().camelToSnakeKeyFromMap(entity.toJson()!) ?? {};
    print("IsAHandler L113, Fields in index: $baseFieldNames");
    print("IsAHandler L114, JSON keys: ${json.keys}");
    return Map.fromEntries(
        json.entries.where((e) {
          final matches = baseFieldNames.contains(e.key);
          /*if (!matches) {
            print("IsAHandler L119, debug: Omitting field: ${e.key}");
          }*/
          return matches;
        }));
  }

  /// Returns only subclass table fields for a given entity
  Map<String, dynamic> _subclassFieldsFor(EntityInterface entity) {
    final type = entity.runtimeType.toString();
    final subclassFieldNames = Entity_Index[type]['fields'] as List<String>? ?? [];
    final json = entity.toJson() ?? {};
    return Map.fromEntries(json.entries.where((e) => subclassFieldNames.contains(e.key)));
  }



  @override
  Future<void> delete(EntityInterface entity, RelationMeta relation) async {
    // Delete subclass first
    await persistence.delete(entity);

    // Then delete base (superclass)
    final baseEntity = await persistence.findByFields(relation, entity);
    if (baseEntity != null) {
      await persistence.delete(baseEntity);
    }
  }
}


