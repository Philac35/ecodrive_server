

/**
 * Function p
 * @Param String message
 * @Param StackTrace? stack
 * @Param in level
 * Usage : p(message, StackTrace.current);
 */

void p_v1(String message, {int level = 1}) {
  var a = StackTrace.current;
  final regexCodeLine = RegExp(r" (\(.*\))$");

  print("$message${regexCodeLine.stringMatch(a.toString().split("\n")[level])}");
}


void p_v2(String message, StackTrace? stack,{ int level = 1}) {


  String a = stack.toString();
    // RegExp reg = RegExp(r"\((.*)\)$)) reg.firstMatch(a){level}
    // RegExp reg = RegExp(r".*/(.*?)\.dart:(\d+):(\d+)\)"); //without function name /!\ here just use g 1,2,3 and erease fileAndFonction
    RegExp reg = RegExp(r'#\d+\s+(\S+)\s+\(.*\/(.*?):(\d+):(\d+)\)'); //with function name
  RegExpMatch? match;
  if((match=reg.firstMatch(a))  !=null){
    String fileAndFonction= match!.group(1)!;
    String file= match!. group(2)!;
    String line= match!.group(3)!;
    String col= match!.group(4)!;

    print("$fileAndFonction L$line, $message;");
  }else{
    print("LogFunction 25, Regex not found in StackTrace!");
  };


}

void p2(String message){
   p(message,"");
}

void p(String message, String? line) {

  var frames = StackTrace.current.toString().split('\n');

  // Usually, frame 0 is inside logWithCallerInfo, frame 1 is the caller
  if (frames.length > 1) {
    var callerFrame = frames[1];

    //RegExp reg = RegExp(r".*/(.*?)\.dart:(\d+):(\d+)\)"); //without function name /!\ here just use g 1,2,3 and erease fileAndFonction
    RegExp reg = RegExp(
        r'#\d+\s+(\S+)\s+\(.*\/(.*?):(\d+):(\d+)\)'); //with function name
    RegExpMatch? match;
    if ((match = reg.firstMatch(callerFrame)) != null) {
      String fileAndFonction = match!.group(1)!.replaceFirst('.', ' ');
      String file = match!.group(2)!;
      String line = match!.group(3)!;
      String col = match!.group(4)!;

      print("$fileAndFonction L$line, $message;");
    } else {
      print("LogFunction 54, Regex not found in StackTrace!");
    };
  }
}






/* Solution with external module stack_trace.dart
 * Just a parser of dart StackTrace

import 'package:stack_trace/stack_trace.dart';
class StackTraceModule {
  void logWithTrace(String message) {
    var trace = Trace.current();
    var frame = trace.frames[1]; // skip log function frame
    print('${frame.uri.pathSegments.last}:${frame.line} $message');
  }
}
 */
