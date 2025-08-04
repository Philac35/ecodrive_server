import 'package:angel3_framework/angel3_framework.dart';

extension SymbolToStringConverter on Model{

//Conversion Symbole to String
static String symbolToString(Symbol symbol) {
final s = symbol.toString(); // e.g. 'Symbol("foo")'
final match = RegExp(r'^Symbol\("(.+)"\)$').firstMatch(s);
if (match != null) {
return match.group(1)!;
}
return s; // fallback, maybe 'Symbol("foo")'
}

/**
 * Function convertSymbolKeysToString
 * @param Map<dynamic,dynamic) in fact Map <Symbol,dynamic>
 * @return Map <String,dynamic>
 */
static Map<String, dynamic> convertSymbolKeysToString(Map<dynamic, dynamic> map) {
   return {
    for (var entry in map.entries)
      entry.key is Symbol
          ? symbolToString(entry.key as Symbol)
          : entry.key.toString(): entry.value
  };
}


static Symbol stringToSymbol(String value) {
    return Symbol(value);
}

/**
 * Function convertStringKeysToSymbol
 * @param Map<dynamic,dynamic) in fact Map <String,dynamic>
 * @return Map <Symbol,dynamic>
 */
static Map<Symbol, dynamic> convertStringKeysToSymbol(Map<dynamic, dynamic> map) {
  return {
    for (var entry in map.entries)
      entry.key is String ? stringToSymbol(entry.key)
          :stringToSymbol(entry.key): entry.value
  };
}

}