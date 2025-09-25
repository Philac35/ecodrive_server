

import 'package:shared_package/BDD/ORM/Transformer/Interface/TransformerAbstract.dart';

import '../../Interface/entityInterface.dart';
import '../../Model/Abstract/PersonEntity.dart';
import '../../Model/AbstractModels/AdministratorEntity.dart';
import '../../Model/AbstractModels/EmployeeEntity.dart';
import '../../Model/Index/Entity_Index.dart';
import '../Relations/RelationMeta.dart';

class PersonToEmployee extends TransformerAbstract<Administrator>{

  @override
  Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
    final user = child as Employee; // could do user.toJson() and use Angel
    var json = user.toJson();
    List<String>fields = Entity_Index["Person"]!['fields'];
    print("PersonToPerson.extract: json=$json, Person.fields=$fields");

    Map<String, dynamic>? res = {};

    for (final field in fields) {
      if (json!.containsKey(field)) {
        res[field] = json[field];
      }
    }

// Special case: nested authUser
    // Merge nested authUser (flatten into person fields)
    if (json!['person']!["authUser"] != null) {
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
    final user = child as Administrator;
    user.administratorId = int.parse(parent!.id!);
  }



}