import 'dart:convert';


import 'package:shared_package/Services/Parser/Interface/ParserJsonInterface.dart';

import '../../BDD/Interface/entityInterface.dart';

class ParserEntityJson<T extends EntityInterface> implements ParserJsonInterface {
  final T Function(Map<String, dynamic>) fromJsonFactory;

  ParserEntityJson({required this.fromJsonFactory});

  @override
  T decode(String jsonString) {
    final userMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return fromJsonFactory(userMap);
  }

  @override
  Map<String, dynamic>? encode(dynamic objectJson) {
    if (objectJson != null && objectJson is EntityInterface) {
      return objectJson.toJson();
    }
    return null;
  }
}


/**
 * Suppose you have a User class that implements EntityInterface:
 * class User implements EntityInterface {
 *   final String name;
 *   User({required this.name});
 *
 *   factory User.fromJson(Map<String, dynamic> json) => User(name: json['name']);
 *   @override
 *   Map<String, dynamic> toJson() => {'name': name};
 *   }
 *
 *  You can now use your parser like this:
 *   final parser = ParserEntityJson<User>(fromJsonFactory: (json) => User.fromJson(json));
 *
 *   User user = parser.decode('{"name": "Alice"}');
 *   Map<String, dynamic>? jsonMap = parser.encode(user);
 */