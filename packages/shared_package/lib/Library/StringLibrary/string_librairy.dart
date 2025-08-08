import './str_extension.dart';


class StringLib {



  Map camelToSnakeKeyFromMap(Map map){
    final newMap = <String, dynamic>{};

    map.forEach((key, value) {
//Convert keys from camelCase to snake_case
      final keyStr = key.toString();
      final snakeKey = camelToSnake(keyStr);
//Put into new map
      newMap[snakeKey] = value;
    });
    return newMap;
  }

  static String camelToSnake(String entry) {
    final reg = RegExp(r'[A-Z]');
    var result = entry.replaceAllMapped(reg, (Match m) => '_${m.group(0)!.toLowerCase()}');
    if (result.startsWith('_')) {
      result = result.substring(1);
    }
    return result;
  }

  static String snakeToCamel(String entry) {
    final reg = RegExp(r'_([a-z])');

    var result = entry.replaceAllMapped(reg, (Match m) => '${m.group(1)!.toUpperCase()}');
    if (result.startsWith('A-Z')) {
      result = result.firstToLowerCase();
    }
    return result;
  }


}

