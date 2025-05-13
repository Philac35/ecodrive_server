

import 'package:flutter/foundation.dart';

import '../Interface/Service.dart';
import 'dart:math';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:io';

import 'LogLevel.dart';

class LogSystem implements Service{
  String ApplicationName='MyApp';
  late int id;
  //Implementation d'un singleton
  static final LogSystem _instance = LogSystem._internal();

  //Private constructor
  LogSystem._internal(){
    this.id=this.getId();
  }

  // Factory constructor to return the singleton instance
  factory LogSystem() {
    return _instance;
  }

  @override
  int getId() {
    var random = Random();
    int randomNumber = random.nextInt(10^15);
    return randomNumber;
  }

  Future<void> setupLogging() async {
    Map<String, dynamic> config = await loadConfig('../../Configuration/config.json');

    Logger.root.level = LogLevel.values.firstWhere((level) => level.toString().split('.').last == config['logLevel']) as Level?; //LogLevel is cast as Level of library logger.dart




    final logFilePath=await getLogFilePath();
    final logFile = File(logFilePath+'/ecodrive_server_error.log');

    Logger.root.onRecord.listen((record) async {
      await checkLogFileSize(logFile); // Check file size before writing
      final logMessage = '${record.level.name}: ${record.time}: ${record.message}\n';
      print(logMessage); // Still log to console
      try {
        logFile.writeAsStringSync(
            logMessage, mode: FileMode.append); // Log to file
      } catch(e){if (kDebugMode) {
        print("Error in LogSystem.dart L43, writeAsStringSync does not work as needed  : ${e}");
      } }
    });
  }

  Future<void> checkLogFileSize(File logFile) async {
    const int maxSizeInBytes = 5 * 1024 * 1024; // 5 MB
    if (await logFile.exists() && await logFile.length() >= maxSizeInBytes) {
      String newLogFileName = '${path.basenameWithoutExtension(logFile.path)}_${DateTime.now().millisecondsSinceEpoch}.log';
      await logFile.rename(path.join(path.dirname(logFile.path), newLogFileName));
    }
  }

  Future<String> getLogFilePath() async {
    late final Directory directory;

    if (Platform.isAndroid || Platform.isIOS) {
      // Mobile platforms
      directory = await getApplicationDocumentsDirectory();
    } else {
      // Desktop platforms
      final homeDir = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
      directory = Directory(path.join(homeDir!, '.ecodrive_server'));
    }

    // Ensure the directory exists
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return path.join(directory.path, 'logs', 'error.log');
  }

  void all(String message) {
    Logger(this.ApplicationName).log(parseLevel(LogLevel.all), message);
  }
  void error(String message,{String? stackTrace}) {
    Logger(this.ApplicationName).log(parseLevel(LogLevel.error), message,stackTrace);
  }
  void log(String message, Level level) {
    Logger(this.ApplicationName).log(level, message);
  }
  void debug(String message) {
    Logger(this.ApplicationName).log(parseLevel(LogLevel.debug), message);
  }
  void verbose(String message) {
    Logger(this.ApplicationName).log(parseLevel(LogLevel.verbose), message);
  }
  void warning(String message) {
    Logger(this.ApplicationName).log(parseLevel(LogLevel.warning), message);
  }
  void fatal(String message) {
    Logger(this.ApplicationName).log(parseLevel(LogLevel.fatal), message);
  }


//Load configuration
  Future<Map<String, dynamic>> loadConfig(String path) async {
    final configFile = File(path);
    if (await configFile.exists()) {
      String contents = await configFile.readAsString();
      return json.decode(contents);
    }
    throw Exception('Configuration file not found');
  }



/**
 * Exemple utilisation
 * void main() async {
 *  WidgetsFlutterBinding.ensureInitialized();
 *  await LogSystem().setupLogging();  //it call the factory
 *   runApp(MyApp());
 *   }
 */
}

