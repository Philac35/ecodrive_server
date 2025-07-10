import 'dart:math';

import 'package:shared_package/Services/Interface/Service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LogSystemBDD implements Service {
  static const String _boxName = 'flutter_web_logs';
  static final LogSystemBDD _instance = LogSystemBDD._internal();
  late int id;


  //Private constructor
  LogSystemBDD._internal(){
    id=getId();
  }

  // Factory constructor to return the singleton instance
  factory LogSystemBDD() {
    return _instance;
  }

  @override
  int getId() {
    var random = Random();
    int randomNumber = random.nextInt(10^15);
    return randomNumber;
  }


  Future<void> initialize() async {
    await Hive.initFlutter(); // Initialize Hive for Flutter
    await Hive.openBox<String>(_boxName); // Open a box for storing logs
    print('Hive logging system initialized');
  }

  Future<void> log(String message) async {
    writeLog('info', message);

  }

  Future<void> error(String message, {String? stackTrace}) async {
    writeLog('error', message,stackTrace:stackTrace);
  }

  Future<void> warning(String message) async {
    writeLog('warning', message);
  }

   Future<void>writeLog(String type, String message,{String? stackTrace})async{
     final box = Hive.box<String>(_boxName);

     final timestamp = DateTime.now().toIso8601String();
     var logEntry="";
     stackTrace! != null  ? logEntry = "$type: $timestamp; $message StackTrace: $stackTrace" :  logEntry = "$type: $timestamp; $message ";


     // Retrieve existing logs
     List<String> logs = box.values.toList();
     logs.add(logEntry);
     print(logEntry); // Immediate feedback

     // Keep only the last 500 log entries
     if (logs.length > 500) {
       logs = logs.sublist(logs.length - 100);
       await box.clear(); // Clear the box before adding trimmed logs
       await box.addAll(logs);
     } else {
       await box.add(logEntry);
     }

   }

  Future<List<String>> getLogs() async {
    final box = Hive.box<String>(_boxName);
    return box.values.toList();
  }

  Future<void> clearLogs() async {
    final box = Hive.box<String>(_boxName);
    await box.clear();
  }


}