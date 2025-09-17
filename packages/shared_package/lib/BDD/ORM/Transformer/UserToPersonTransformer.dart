

import '../../Interface/entityInterface.dart';
import '../../Model/Abstract/PersonEntity.dart';
import '../../Model/AbstractModels/UserEntity.dart';
import '../../Model/Index/Entity_Index.dart';
import '../Relations/RelationMeta.dart';
import 'Interface/TransformerAbstract.dart';

class UserToPersonTransformer extends TransformerAbstract<Person> {
@override
Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
final user = child as User;  // could do user.toJson() and use Angel
var json= user.toJson();
List<String>fields= Entity_Index["Person"]!['fields'];

Map<String, dynamic>? res={};

for (final field in fields) {
  if (json.containsKey(field)) {
    res[field] = json[field];
  }
}

// Special case: nested authUser
if (user.authUser != null) {
  res["authUser"] = user.authUser!.toJson();
}
return res;

}

@override
void attach(EntityInterface child, Person parent, RelationMeta relation) {
final user = child as User;
user.person = parent;
}
}


/**
 * or
 * Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
 *   final user = child as User;

 *   return {
   * // map User fields down to Person
  *  "firstname": user.firstname,
  *  "lastname": user.lastname,
  *  "email": user.email,
  *  // link to authUser if present
  *  if (user.authUser != null) "authUser": user.authUser!.toMap(),
  *  };
   * }

 */