
import 'package:get_it/get_it.dart';
import 'package:shared_package/BDD/Model/Index/Entity_Index.dart';

import '../../../Library/StringLibrary/string_librairy.dart';
import '../../Interface/entityInterface.dart';
import '../EntityMapper.dart';
import '../ORM.dart';
import '../PersistenceService/PersistenceServiceInterface.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/DeletableRelationHandlerInterface.dart';
import 'Interface/RelationHandlerInterface.dart';


class HasOneHandler implements DeletableRelationHandler {
  final PersistenceServiceInterface persistence;
  final EntityMapper mapper;
  ORM? orm;

  HasOneHandler(this.persistence,this.mapper,this.orm);

  /// Fetch the single child entity for a given parent
  Future<EntityInterface?> getChild(EntityInterface parent, RelationMeta relation) async {
    // Build the fields to query the child table
    final fields = { relation.foreignKey: parent.id };

    // Reuse findAllByFields and return only the first result
    final children = await persistence.findAllByFields(relation, fields);
    if(children!=null){return children.first;}
    else {return null;}

  }

  /// Handle persisting the child entity
  @override
  Future<EntityInterface?> handle(EntityInterface parent, RelationMeta relation,{
    Set<String>? persistingTracker,
  }) async {
   EntityInterface? child;
    var childTemp=parent.getField(relation.fieldName);
     if (childTemp is Map){
       var fromMap=Entity_Index[child.runtimeType.toString()]!["fromMap"] as Function;
       child=fromMap(childTemp);
     }else{child=childTemp;}

    if (child == null) return null;



    // Persist child via ORM
    final persistedChild = await orm?.persist(child, persistingTracker: persistingTracker);

    // Update parent reference if necessary
    if (persistedChild != null) {
      parent.setField(relation.fieldName, null); // Remove nested object before persisting parent
      if (relation.foreignKey != null) {
        parent.setField(relation.foreignKey, int.parse(persistedChild.id));
      }
      mapper.storeUpdatedMap(parent);
      mapper.storeUpdatedMap(persistedChild);
    }

    return parent;

  }

  @override
  Future<void> delete(EntityInterface entity, RelationMeta relation) async {
    final child = await persistence.findByFields(relation, entity);
    if (child != null) {
      await persistence.delete(child);
    }
  }
}
