import 'dart:convert';
import 'dart:math';
import 'package:shared_package/Services/Interface/Service.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Parser/ParserJson.dart';

class HiveService implements Service {
  late int id;
  static const String _defaultBoxName = 'hive_box_ecod';
  static final _instance = HiveService._internal();

  // Private constructor
  HiveService._internal() {
    id = getId();
  }

  // Factory constructor to return the singleton instance
  factory HiveService() {
    return _instance;
  }

  @override
  int getId() {
    var random = Random();
    return random.nextInt(1000000); // Generate a random ID
  }

  Future<void> initialize({String? boxname}) async {
    await Hive.initFlutter(); // Initialize Hive for Flutter
    boxname!=null? await Hive.openBox<String>(boxname):await Hive.openBox<String>(_defaultBoxName); // Open a default box
    print('Hive logging system initialized');
  }

  Future<Box<String>> openBox(String boxName) async {
    if (boxName.isEmpty) {
      throw Exception("Box name cannot be empty.");
    }
    try {
      final String  box =  boxName ?? _defaultBoxName;
      return await Hive.openBox<String>(box);
    } catch (e) {
     debugPrint("Failed to open Hive box: $e");
     return Future.value(Hive.box<String>(_defaultBoxName));
    }

  }

  Future<bool> record({String? boxName,required String entryKey, required Map<String, dynamic> entry}) async {
    bool isPersisted= false;
    final box =  boxName != null? await openBox(boxName):await openBox(_defaultBoxName);

    final timestamp = DateTime.now().toIso8601String();
    final tuple = '$timestamp: ${ParserJson(entry).encode(null)}';
     try {
       // Store entry with a specific key
       await box.put(entryKey, tuple);
       debugPrint(tuple); // Immediate feedback
       isPersisted=true;
     }catch(error, stack){
       debugPrint("HiveService, record erreur : $error");
       debugPrintStack(stackTrace: stack);
        isPersisted=false;
     }
    return isPersisted;
  }

  Future<List<String>> getRecords({String? boxName}) async {
    final box =  boxName != null? await openBox(boxName):await openBox(_defaultBoxName);
    return box.values.toList();
  }

  Future<String?> getRecordToString({String? boxName,required String entryKey}) async {
    final box =  boxName != null? await openBox(boxName):await openBox(_defaultBoxName);
    return box.get(entryKey);

  }

  Future<Map<String, dynamic>> getRecordsBeginning({
    String? boxName,
    required String beginning,
  }) async {

    final box = boxName != null ? await openBox(boxName) : await openBox(_defaultBoxName);
    Map<String, dynamic> res = {};

    for (var key in box.keys) {
      if (key.startsWith(beginning)) {
        res[key] = box.get(key)!;
      }
    }

    return res;
  }


  Future<Map<String, dynamic>?> getFirstRecordBeginning({
      required String boxName,
      required String beginning,
    }) async {

    if (boxName.isEmpty) {
      throw Exception("Box name cannot be empty.");
    }
    try {
      final box = boxName != null ? await openBox(boxName) : await openBox(_defaultBoxName);

      for (var key in box.keys) {

        if (key.startsWith(beginning)) {

          return {key: box.get(key)};
        }
    } }catch (e) {
      throw Exception("HiveService L108,getFirstRecordBeginning : Failed to open Hive box: $e");
    }



      return null;
    }

  Future<Map<String, dynamic>?> getRecord({
    required String boxName,
    required String entryKey,
  }) async {
    if (boxName.isEmpty) {
      throw Exception("Box name cannot be empty.");
    }
    try {
      final box = await openBox(boxName);
      final record = box.get(entryKey);
      if (record == null) {
        throw Exception("Record not found for key: $entryKey");
      }
      return jsonDecode(record) as Map<String, dynamic>;
    } catch (e, stack) {
      debugPrint("HiveService L140 :${stack.toString()}");
      debugPrint("Failed to retrieve record: $e");
    }
    return null;
  }


  Future<void> deleteRecord({String? boxName, required String entryKey}) async {
    final box =  boxName != null? await openBox(boxName):await openBox(_defaultBoxName);
    await box.delete(entryKey); // Delete the entry by key
  }

  Future<void> clearRecords({String? boxName}) async {
    final box =  boxName != null? await openBox(boxName):await openBox(_defaultBoxName);
    await box.clear(); // Clear all records in the specified box
  }


  //TODO Idem for delete
  Future<Map<String, dynamic>> clearRecordsBeginning({String? boxName, required String beginning}){
    //TODO Implement clearRecordsBeginning
    throw( "Implement clearRecordsBeginning");
}
}
