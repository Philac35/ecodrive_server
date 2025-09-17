import 'Interface/ParserJsonInterface.dart';
import 'dart:convert';

class ParserJson<T> implements ParserJsonInterface {
  T? jsonObject;

  ParserJson({this.jsonObject});

  @override
  /**
   * Function decode
   * @Param jsonString
   * @Return either List or Map<String,dynamic>
   */
  dynamic decode(String jsonString) {
    try {
      if (jsonObject != null) {
        return jsonObject as Map<String, dynamic>;
      } else {
        var strDecoded = jsonDecode(jsonString);
        if (strDecoded is List) {
          return List<String>.from(strDecoded);
        } else {
          return strDecoded as Map<String, dynamic>;
        }
      }
    } catch (e, s) {
      print('Error decoding JSON: $e \n $s');
      return null;
    }
  }

  //return json.decode(jsonString) as Map<String, dynamic>;

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
    } catch (e, s) {
      print('Error encoding JSON: $e \n $s');
      return null;
    }
  }

  String encodeToString(dynamic input) {
    final encodedMap = encode(input);
    return encodedMap != null ? json.encode(encodedMap) : '{}';
  }
}
