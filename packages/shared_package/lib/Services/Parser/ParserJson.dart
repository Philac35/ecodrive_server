import 'Interface/ParserJsonInterface.dart';
import 'dart:convert';

class ParserJson<T> implements ParserJsonInterface {
  T? jsonObject;

  ParserJson(this.jsonObject);

  @override
  Map<String, dynamic> decode(String jsonString) {
    try {
      if (jsonObject != null) {
        return jsonObject as Map<String, dynamic>;
      } else {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error decoding JSON: $e');
      return {};
    }
  }

  @override
  Map<String, dynamic>? encode(dynamic input) {
    try {
      if (jsonObject != null) {
        return jsonObject as Map<String, dynamic>;
      } else if (input is Map<String, dynamic>) {
        return input;
      } else {
        return json.decode(json.encode(input)) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error encoding JSON: $e');
      return null;
    }
  }

  String encodeToString(dynamic input) {
    final encodedMap = encode(input);
    return encodedMap != null ? json.encode(encodedMap) : '{}';
  }
}
