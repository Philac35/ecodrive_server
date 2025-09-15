
import '../../Interface/entityInterface.dart';

enum RelationType { belongsTo,belongsToMany, hasOne, hasMany, manyToMany, isA }
typedef FieldTransformer = void Function(EntityInterface parent, EntityInterface related);

class RelationMeta {
  final String fieldName;
  final String relatedType;
  final RelationType type;
  final String foreignKey;
  final String? relatedKey; // for many-to-many second key
  final String? pivotTable;
  dynamic joinParentForeignKey;
  dynamic joinChildForeignKey;
  final bool cascadeOnDelete;
  final bool reuseIfExists;
  final bool updateIfExist;   //use upsert system
  final List<String> findBy;  //Needed for reuseIfExist BDD search
  FieldTransformer? transformer;
  RelationMeta({required this.fieldName,required this.relatedType,required this.type,required this.foreignKey,this.relatedKey,this.pivotTable,this.joinParentForeignKey, this.joinChildForeignKey, this.cascadeOnDelete= false,this.reuseIfExists=true, this.updateIfExist=true, this.findBy= const [], this.transformer});

  String toString(){
    return "RelationMeta(fieldName:$fieldName, relatedType:$relatedType, type:$type, foreignKey:$foreignKey,relatedKey:$relatedKey, pivotTable:$pivotTable,joinParentForeignKey:$joinParentForeignKey, joinChildForeignKey:$joinChildForeignKey,cascadeOnDelete:$cascadeOnDelete,reuseIfExists:$reuseIfExists,updateIfExist:$updateIfExist,findBy:${findBy.toString()})";
  }
}