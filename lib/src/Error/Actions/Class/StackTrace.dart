import 'dart:io';
import 'package:path_provider/path_provider.dart';


class StackTrace{


  Future<File> saveStackTraceToFile(String stackTrace) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/error_stacktrace.txt');
    return file.writeAsString(stackTrace);
  }


  void openFileInEditor(String filePath) {
    if (Platform.isWindows) {
      Process.run('notepad.exe', [filePath]);
    } else if (Platform.isMacOS) {
      Process.run('open', ['-a', 'TextEdit', filePath]);
    } else if (Platform.isLinux) {
      Process.run('xdg-open', [filePath]);
    }
  }

  void showStackTraceInEditor(String stackTrace) async {
    final file = await saveStackTraceToFile(stackTrace);
    openFileInEditor(file.path);
  }




}