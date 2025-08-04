import 'dart:convert';
import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

class Uint8ListJsonConverter extends JsonConverter<Uint8List, String> {
  const Uint8ListJsonConverter();

  @override
  Uint8List fromJson(String json) {
    return base64Decode(json);
  }

  @override
  String toJson(Uint8List object) {
    return base64Encode(object);
  }

  /**
   * Function JsonStr
   * Used in model
   * @param value noted as dynamic but use String
   * @return Uint8List
   */
  Uint8List? jsonStrToUint(dynamic value) {
    if (value == null) return null;
    if (value is Uint8List) return value;
    if (value is List<int>) return Uint8List.fromList(value);
    if (value is! String) return null;

    // If JSON array of numbers: "[120,156,0,255,...]"
    if (value.trim().startsWith('[')) {
      try {
        var list = List<int>.from(jsonDecode(value));
        return Uint8List.fromList(list);
      } catch (e) {
        print('Failed to parse JSON num-list for Uint8List: $e');
        return null;
      }
    }

    // Try JSON-decoded base64
    try {
      final decodedJson = jsonDecode(value);
      if (decodedJson is String) {
        return base64Decode(decodedJson);
      } else if (decodedJson is List) {
        return Uint8List.fromList(List<int>.from(decodedJson));
      }
    } catch (e) {
      print("Uint8ListConverter: JSON-decoded base64 failed, error $e");
    }

    // Try base64 directly
    try {
      var str = value;
      if (str.startsWith('"') && str.endsWith('"')) {
        str = str.substring(1, str.length - 1);
      }
      return base64Decode(str);
    } catch (e) {
      print("Uint8ListConverter: base64 decoding failed, error: $e");

    }
    return null;
  }


}
