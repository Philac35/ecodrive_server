
import 'dart:core';
import 'dart:io';




/// Class ExtractFunctionIndexGenerator v.1
/// cf. printHelp
///
/// Author E.H 3/07/2025
///
class ExtractFunctionIndexGenerator {
  final Directory dir;
  final String indexName;
  final String outputFileName;


  ExtractFunctionIndexGenerator({
    required this.dir,
    this.indexName = 'classIndex',
    this.outputFileName = 'class_Index.dart',

  });



  Future<void> addMapFunctionToController() async {
    List<File> files = readFilesInDirectory();

    for (var file in files) {
      String strfile = await file.readAsString();

      // Remove existing functionMap getter if present
      final functionMapRegex = RegExp(
        r'Map\s*<\s*String\s*,\s*Function\s*>\s*get\s*functionMap\s*=>\s*\{[^}]*\};',
        multiLine: true,
        dotAll: true,
      );
      strfile = strfile.replaceAll(functionMapRegex, '');
 print('L42 Hello');
      // Find the position of the last closing brace '}'
      final lastBraceIndex = strfile.lastIndexOf('}');
      if (lastBraceIndex == -1) continue;

      var functionMap = await fetchFunctionsWithInheritage(file);
      print('L48 Hello');
      // Write functions in Map
      final buffer = StringBuffer();
      buffer.write('\n  Map<String, Function> get functionMap => {');
      for (var methodName in functionMap.entries) {
        buffer.write('\'${methodName.key}\': ${methodName.key}, ');
      }
      buffer.writeln('};\n');
      print(buffer.toString() );
      final newFileContent = strfile.substring(0, lastBraceIndex) +
          buffer.toString() +
          strfile.substring(lastBraceIndex);

      print('L61 Hello');
      // Write to a new file or overwrite the original
      await file.writeAsString(newFileContent);
    }
  }





  Future<void> generateIndexFile() async {
    final buffer = StringBuffer();
    buffer.write('/// GENERATED FILE - DO NOT MODIFY BY HAND\n');
    buffer.write('/// Use modules Generator, Script : ExtractFunctionIndexGenerator.dart v.1 \n');
    buffer.writeln('/// Author E.H 3/07/2025 \n');

    buffer.write('///  Use : Map access in files : \n');
    buffer.writeln('///        Index_ControllerFunctionMap[\'entityName\']!()\n');




    List<File> files=readFilesInDirectory();

    final classNames = <String>[];

    for (var file in files) {
      final fileName = file.uri.pathSegments.last;
      buffer.writeln("import '$fileName';");

      final className = toCamelCase(fileName.replaceAll('.dart', ''));
      classNames.add(className);
    }




    //Write the main map
    buffer.writeln('\nfinal Map<String, Map<String,Function >> $indexName = {');
    for (var className in classNames) {
     buffer.writeln("  '$className':  $className().functionMap,");
    }
    buffer.writeln('};');

    final outputPath = '${dir.path}/$outputFileName';
    File(outputPath).writeAsStringSync(buffer.toString());
    print('Index generated at $outputPath');
  }

  /// Converts a snake_case or lowercase file name to UpperCamelCase (PascalCase).
  String toCamelCase(String input) {
    return input.split('_').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join();
  }



  static void printHelp() {
    print('''
ClassesIndexGenerator - Dart Class Index Generator
Create a functionMap at the end of each classes
Create an Index of Map of all Function associated to their classes

Usage:
  dart run your_script.dart [options]

Options:
  -dir <directory>      Directory to scan for .dart files (default: lib/controllers)
  -model                If you work on models' directories set this boolean to true 
  -name <indexName>  Name of the generated index variable (default: classIndex)
  -out <outputFile>     Output file name for the index (default: class_index.dart)
  -h, --help            Show this help message  

Examples:
  dart run ExtractFunctionIndexGenerator.dart
  dart run ExtractFunctionIndexGenerator.dart -dir lib/services -name serviceIndex -out Service_index.dart
  dart run ExtractFunctionIndexGenerator.dart -name controller_index -out Controller_index.dart
  dart run ExtractFunctionIndexGenerator.dart -dir '../../Controller' -name Index_ControllerFunctionMap -out Index_ControllerFunction.dart -mapController true -mapindex true  
''');
  }

  static void cli(List<String> args) {
    // Defaults
    var dir = Directory('../../Controller');
    var indexName = 'classIndex';
    var outputFileName = 'class_index.dart';
    var  isMapControllerGen= 'false';
    var isMapIndex = 'false';

    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '-dir':
          if (i + 1 < args.length) dir = Directory(args[++i]);
          break;
        case '-name':
          if (i + 1 < args.length) indexName = args[++i];
          break;
        case '-out':
          if (i + 1 < args.length) outputFileName = args[++i];
          break;
        case '-mapcontroller':
          if (i + 1 < args.length) isMapControllerGen = args[++i];
          break;
        case '-mapindex':
          if (i + 1 < args.length) isMapIndex = args[++i];
          break;

        case '--help':
        case '-h':
          printHelp();
          return;
      }
    }


    init(dir,indexName,outputFileName ,isMapControllerGen: bool.parse(isMapControllerGen), isMapIndex:bool.parse(isMapIndex));

  }


  static init(dir,indexName,outputFileName,{bool isMapControllerGen=false,  bool isMapIndex=false}){
    var indexGenerator=ExtractFunctionIndexGenerator(
        dir: dir,
        indexName: indexName,
        outputFileName: outputFileName,

    );

    if(isMapIndex==true) {indexGenerator.generateIndexFile(); }

    if(isMapControllerGen==true){
        indexGenerator.addMapFunctionToController();
    }
        
  }


  //
  List<File> readFilesInDirectory(){
    final files = dir
        .listSync()
        .whereType<File>()
        .where((value)=> RegExp('[index|Index]').hasMatch(value.uri.pathSegments.last)==false)
        .toList();


    //Alpha ordered
    files.sort((a, b) =>
        a.uri.pathSegments.last.toLowerCase().compareTo(b.uri.pathSegments.last.toLowerCase())
    );
    return files;
  }

//Working Functions

  /*
   * Fetch functions on 2 levels : files and file extended, it keep function of child(if overide)
   */
  Future<Map<String, int>>  fetchFunctionsWithInheritage(File file) async{
    Map<String, int> functionMap = {};

    Map<int, File> inheritedFile = {1: file};
    File? extendedFile = await fetchExdendedFile(file);
    if (extendedFile != null) inheritedFile[2] = extendedFile;

    for (var entry in inheritedFile.entries) {
      List<String> functionList = await extractFunctions(entry.value);
      print('Functions found in file ${entry.value.path}: $functionList');
      for (var fl in functionList) {
        functionMap.putIfAbsent(fl, () => entry.key); //Avoid duplicate entry
      }
    }

    print('Final functionMap: $functionMap');
    return functionMap;
  }

  static Future<List<String>> extractFunctions(File file) async {
    List< String> res=[];
    //var funcRegex=RegExp('([a-zA-Z0-9]*)\(.*?\)',multiLine: true,caseSensitive: true);
    //improved
    final funcRegex = RegExp(
      r'^\s*(?:[\w<>?\[\]]+\s+)+([a-zA-Z_][\w]*)\s*\([^)]*\)\s*(?:async\s*)?(?:\{|=>)',
      multiLine: true,
    );
    String? f = await file.readAsString();
    Iterable<RegExpMatch> regExpIt = funcRegex.allMatches(f);
    for (var r in regExpIt){
      final methodName = r.group(1);
      if (methodName != null && !methodName.startsWith('_')) {
        res.add(methodName);

      }
    }
    return res;
  }

  Future<File?> fetchExdendedFile(File file)async{
    File? ret;
    try{
    var extendRegexWithPrefixClassGeneric =RegExp('extends ((.*?)\\.)?(.*?)(<(.*?)>)');
    String strfile= await file.readAsString();

    RegExpMatch? rem= extendRegexWithPrefixClassGeneric.firstMatch(strfile);

    print('ExtractFunctionIndexGenerator L230: ${rem!.group(3)}');


    rem.groupNames;

    String? res= rem.group(3); //Match with Controller of controller.Controller
    if(res != null){
      print('file Controller: $strfile');
      print('ExtractFunctionIndexGenerator L240 RES:^import \'(.*?/.*?$res.dart)\'');
     //                               ^import '(.*?\/.*?Controller\.dart)
      var  extendImportRegex = RegExp("import.*?package(.*/.*?$res.*?dart)'");
    RegExpMatch? rem2= extendImportRegex.firstMatch(strfile);
   // print('ExtractFunctionIndexGenerator L244 : ${rem2?.group(1)}');
    String? address= rem2?.group(1);

   ret=File(address!.replaceFirst(':shared_package', '../..'));}
  }catch(e){  print('ExtractFunctionIndexGenerator L248, error $e');}
    return ret;
  }
}

Future<void> main(List<String> args) async {

   ExtractFunctionIndexGenerator.cli(args);
   /* test
  File file = File('../../Controller/Controller.dart');
  String content = await file.readAsString();
  //print('File content:\n$content');
  List<String> functions = await ExtractFunctionIndexGenerator.extractFunctions(file);
  print(functions);
  */
}
