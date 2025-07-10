import 'package:shared_package/Services/Interface/Service.dart';
import 'package:shared_package/Services/LogSystem/LogSystemBDD.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


//Design to work with android it need dart:io that is not available on flutter web
class SecureStorage implements Service {
  static final SecureStorage _instance = SecureStorage._internal();
  FlutterSecureStorage? _store;

  SecureStorage._internal() {
    getId();
  }

  factory SecureStorage() {
    return _instance;
  }

  Future<FlutterSecureStorage> initialize() async {
    _store = FlutterSecureStorage();
    return _store!;
  }

  Future<void> record(String key, String value) async {
    if (_store == null) {
      throw Exception('Secure storage not initialized');
    }
   try{
    await _store!.write(key: key, value: value);
    print('SecureStorage L45, record :$key was wrote');
    LogSystemBDD().log('SecureStorage L45,record: $key was wrote');
  }
   catch(e){debugPrint('SecureStorage L45, record : $key wasn\'t wrote');
   LogSystemBDD().log('SecureStorage L45, record : $key wasn\'t wrote');
   }
  }

  Future<String?> getEntry(String name) async {
    if (_store == null) {
      throw Exception('Secure storage not initialized');
    }
    return await _store!.read(key: name);

  }

  Future<void> delete(String name) async {
    if (_store == null) {
      throw Exception('Secure storage not initialized');
    }
    try{
    await _store!.delete(key: name);
    print('SecureStorage L45, delete :$name was deleted');
    LogSystemBDD().log('SecureStorage L45, delete :$name was deleted');
    }
    catch(e){debugPrint('SecureStorage L45, delete : $name wasn\'t deleted');
    LogSystemBDD().log('SecureStorage L45, delete : $name wasn\'t deleted');
    }
  }

  @override
  int getId() {
    var random = Random();
    int randomNumber = random.nextInt(10 ^ 15);
    return randomNumber;
  }
}