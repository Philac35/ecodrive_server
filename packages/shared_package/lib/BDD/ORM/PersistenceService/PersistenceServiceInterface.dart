import 'package:shared_package/BDD/Executor/MysqlPoolExecutor.dart';

import '../../Interface/entityInterface.dart';
import '../Relations/ClassRelation_Index.dart';
import '../Relations/RelationMeta.dart';

abstract class PersistenceServiceInterface {

 MySqlPoolExecutor get executor;

  Future<EntityInterface?> findById(String type,int id);
  Future<EntityInterface?> findByFields(RelationMeta relation, EntityInterface entity);

  Future<List<EntityInterface?>?> findAllByFields(RelationMeta relation, Map<String, dynamic> fields);

  Future<EntityInterface?> persist(EntityInterface entity);

 Future<EntityInterface?> update(EntityInterface entity);

  Future<EntityInterface?> upsert(
      EntityInterface newEntity,
      EntityInterface existingEntity,
      RelationMeta relation,
      );

  Future<EntityInterface?> persistFromMap(String entityType, Map<String, dynamic> map);



  Future<bool>delete(EntityInterface entity);

  // New for many-to-many

 Future<void> insertPivotTuple(
     RelationMeta relation,
     String joinTable,
     dynamic ownerId,
     dynamic relatedId,
     );

 Future<void> deletePivot(RelationMeta relation, dynamic entityId);
 Future<void> deletePivotTuple(RelationMeta relation,dynamic ownerId,dynamic relatedId);
}
