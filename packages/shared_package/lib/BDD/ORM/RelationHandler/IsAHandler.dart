import 'package:get_it/get_it.dart';
import 'package:shared_package/Library/StringLibrary/string_librairy.dart';

import '../../Interface/entityInterface.dart';
import '../../Model/Abstract/PersonEntity.dart';
import '../../Model/AbstractModels/DriverEntity.dart';
import '../../Model/AbstractModels/UserEntity.dart';
import '../../Model/Index/Entity_Index.dart';
import '../EntityMapper.dart';
import '../ORM.dart';
import '../PersistenceService/CTIPersistenceService.dart';
import '../PersistenceService/PersistenceServiceInterface.dart';
import '../Relations/ClassRelation_Index.dart';
import '../Relations/RelationMeta.dart';
import '../Transformer/Interface/TransformerAbstract.dart';
import '../Transformer/Index/TransformerIndex.dart';
import '../Transformer/Transformer.dart';
import 'BelongsToHandler.dart';
import 'HasManyHandler.dart';
import 'Interface/DeletableRelationHandlerInterface.dart';
import 'Interface/RelationHandlerInterface.dart';
import 'Interface/RelationHandlerInterface.dart' show RelationType;
import 'RelationResolver.dart';
import 'package:shared_package/Library/StringLibrary/str_extension.dart';

class IsAHandler implements DeletableRelationHandler {
  final PersistenceServiceInterface persistence;
  final EntityMapper mapper;
  ORM? orm;
  RelationResolver? resolver;
  IsAHandler(this.persistence,this.mapper,this.orm);



  @override
  Future<EntityInterface?> handle(
      EntityInterface entity,
      RelationMeta relation, {
        Set<String>? persistingTracker,
      }) async {
    try {
    // 1. Get parent relation (from registry)
    final parentMetaList = ClassRelationsIndex[relation.relatedType];
    final relatedTypeStr = relation.relatedType;  //or childType
     String entityType= entity.runtimeType.toString();
    // 2. Transform entity data into relative
    final transformer = transformerIndex[entityType]?[relatedTypeStr];
    //transformerIndex[relatedTypeStr] as  TransformerAbstract<EntityInterface>?;
    if (transformer == null) {
      throw StateError("No transformer for $relatedTypeStr → $entityType");
    }
    if (!transformer.canExtract(relation.relatedType , entity)) {
      throw Exception(
          "Transformer cannot extract $relatedTypeStr from $entityType");
    }
    final parentData = transformer?.extract(entity, relation);
    if (parentData == null) return entity;

    // 3. Build parent with persistence/mapper
    var fromMap= await persistence!.getFunctionFromMap(relatedTypeStr);
    var parent = fromMap!( parentData);
    print("IsHandler, after fromMap entity to persist :$parent");


    // 4. Persist parent (authUser / person / …)
    EntityInterface? persistedParent = await persistence.persist(parent);  //we don't use orm.persist like in V1


    //5 Update child’s foreign key if needed
    String FKcamelCase=relation.foreignKey.snakeToCamel();
    entity.setField(FKcamelCase, int.parse(persistedParent!.id));
    entity.setField(relation.fieldName,null);
    parent.id= persistedParent.id; //persistedParent no longer have authUser need for the rest. We must use parent but update id
    //await persistence.update(entity!); -> not needed, it is done at end of function


// 6. Persist nested relations (belongsTo / hasOne) and update FKs
      //-> this update ids in bdd. repeat steps 1->5
      /*   Map<RelationType, RelationHandlerInterface> handlers = {
      relationType: this as RelationHandlerInterface
    };*/
      if (parentMetaList != null) {
        final resolver = RelationResolver(orm!.relationHandlers!, persistence);
        for (final rel in parentMetaList) {
          final nested = parent.getField(rel.fieldName); // assumes getField returns EntityInterface
          if (nested != null) {

            if (rel.type == RelationType.belongsTo || rel.type == RelationType.hasOne) {
              // Use relation’s FK field if defined
              final fkField = rel.relatedKey!.snakeToCamel();
              nested.setField(fkField, int.tryParse(parent.id));
            }


             parent = await resolver.resolve(parent, rel, persistingTracker: persistingTracker);
             print("");
            // Update FK on parent is set at end of used handler
            //here saveNested = parent + id

          }
        }
        // Update parent after nested FKs
        parent = await persistence.update(parent);
      }
    // 7. Link parent to child
    transformer.attach( entity,persistedParent!,  relation)  ;  // ! entity is parent and persistedParent is child

    // 8. Update mapper
    mapper.storeUpdatedMap(entity);

    return entity;
    } catch (e, s) {
      print("IsAHandler Error: $e\nstack:$s");
      rethrow;
    }
  }




@override
  Future<EntityInterface?> handle_V1(
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
         int?  id=  entity.getField(relation.foreignKey.snakeToCamel());
         if(id!=null){ return  mapper.getUpdatedEntityById(relation.relatedType.snakeToCamel(),id);}
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
    } catch (e, s) {
      print("IsAHandler Error: $e\nstack:$s");
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




