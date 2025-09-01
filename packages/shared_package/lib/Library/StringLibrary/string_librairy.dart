import './str_extension.dart';


class StringLib {


  /**
   * Function camelToSnakeKeyFromMap
   * Convert keys from camelCase to snake_case
   * @Param Map<String, dynamic>
   * @Return Map
   */
  Map camelToSnakeKeyFromMap(Map map){
    final newMap = <String, dynamic>{};

    map.forEach((key, value) {
      final keyStr = key.toString();
      final snakeKey = camelToSnake(keyStr);

      newMap[snakeKey] = value;
    });
    return newMap;
  }


  /**
   * Function snakeToCamelKeyFromMap
   * Convert keys from snake_case  to camelCase
   * @Param Map<String, dynamic>
   * @Return Map
   */
  Map snakeToCamelKeyFromMap(Map map){
    final newMap = <String, dynamic>{};

    map.forEach((key, value) {
      final keyStr = key.toString();
      final camelKey = snakeToCamel(keyStr);

      newMap[camelKey] = value;
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


  /**
   * Function firstToUpperCase
   */
  firstToUpperCase(String str) {
    if (str.startsWith(RegExp(r'[a-z]'))) {
      return "${str.substring(0, 1).toUpperCase()}${str.substring(1, str.length)}";
    }
  }

  /**
   * Function firstToLowerCase
   */
  firstToLowerCase(String str) {
    if (str.startsWith(RegExp('[A-Z]'))) {
      return "${str.substring(0, 1).toLowerCase()}${str.substring(
          1, str.length)}";
    }
  }
  }

