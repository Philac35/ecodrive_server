 import '../../../Interface/entityInterface.dart';
import '../../Relations/RelationMeta.dart';

abstract interface class  RelationHandlerInterface{

   Future<EntityInterface?>? handle(
       EntityInterface entity,
       RelationMeta relation,
       {
         Set<String>? persistingTracker,
       }
       );
 }