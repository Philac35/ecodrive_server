

import '../../Interface/entityInterface.dart';
import '../../Model/AbstractModels/EmployeeEntity.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/TransformerAbstract.dart';

class PersonFromEmployeeTransformer extends TransformerAbstract<Employee>{


@override
Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
  final json = child.toJson();
   var ret= json!["person"];
   return ret;
}

@override
void attach(EntityInterface child, dynamic parent, RelationMeta relation) {
  if (child is Employee) {
    child.person = parent;
  }
}
}