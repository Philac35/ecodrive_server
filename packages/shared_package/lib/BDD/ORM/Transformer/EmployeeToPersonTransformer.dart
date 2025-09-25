import '../../Interface/entityInterface.dart';
import '../../Model/AbstractModels/EmployeeEntity.dart';
import '../../Model/Index/Entity_Index.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/TransformerAbstract.dart';

class EmployeeToPersonTransformer extends TransformerAbstract <Employee>{

  @override
  Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
    final user = child as Employee;
    var json= user.toJson();
    List<String>fields= Entity_Index["Person"]!['fields'];
    print("EmployeeToPerson.extract: json=$json, Person.fields=$fields");

    Map<String, dynamic>? res={};

    for (final field in fields) {
      if (json.containsKey(field)) {
        res[field] = json[field];
      }
    }

// Special case: nested authUser
    // Merge nested authUser (flatten into person fields)
    if (json['person']!["authUser"] != null) {
      final authJson = json!['person']!["authUser"] as Map<String, dynamic>;
      if (authJson["id"] != null) {
        res["authUserId"] = authJson["id"];
      }
      // if you want inline auth_user object for persistence:
      res["authUser"] = authJson;
    }


    return res;

  }

  @override
  void attach(EntityInterface child, dynamic parent, RelationMeta relation) {
    final user = child as Employee;
    user.person = parent;
  }


}