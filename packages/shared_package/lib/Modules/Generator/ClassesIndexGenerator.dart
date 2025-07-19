import 'dart:io';

/// Class ClassesIndexGenerator v.1
/// cf. printHelp
///
/// Author E.H 27/06/2025
///
class ClassesIndexGenerator {
  final Directory dir;
  final String registryName;
  final String outputFileName;
  bool? isQueryClass;
  bool? isSerializerClass;

  ClassesIndexGenerator({
    required this.dir,
    this.registryName = 'classIndex',
    this.outputFileName = 'class_index.dart',
    this.isQueryClass = false,
    this.isSerializerClass = false
  });


  /// Converts a snake_case or lowercase file name to UpperCamelCase (PascalCase).
  String toCamelCase(String input) {
    return input.split('_').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join();
  }


  /*
   * Function getFiles
   * return Files form 1 directory and subdirectory
   */
  List<File> getFiles({bool recursive = true}) {
    final files = dir
        .listSync(recursive: recursive)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'))
        .toList();

    files.sort((a, b) => a.uri.pathSegments.last.toLowerCase().compareTo(
        b.uri.pathSegments.last.toLowerCase())
    );
    return files;
  }


  void generate() {
    final buffer = StringBuffer();
    buffer.write('/// GENERATED FILE - DO NOT MODIFY BY HAND\n');
    buffer.write(
        '/// Use modules Generator, Script : ClassesIndexGenerator.dart v.1 \n');
    buffer.writeln('/// Author E.H 27/06/2025 \n');

    buffer.write('///  Use : Instanciated classes access in files : \n');
    buffer.writeln('///        classIndex[\'entityName\']!()\n');

    isQueryClass!
        ? buffer.writeln(
        "import '../../../server_package/Router/RoutesEntityBuilder.dart';")
        : '';

    print('classIndexGenerator L33$isQueryClass');

    final files = getFiles();


    //Alpha ordered
    files.sort((a, b) =>
        a.uri.pathSegments.last.toLowerCase().compareTo(
            b.uri.pathSegments.last.toLowerCase())
    );

    final classNames = <String>[];

    //Imports declarations
    for (var file in files) {
      final fileName = file.uri.pathSegments.last;
      buffer.writeln("import '$fileName';");

      final className = toCamelCase(fileName.replaceAll('.dart', ''));
      classNames.add(className);
    }

    //Map declaration
    buffer.writeln('\nfinal Map<String, ${ isQueryClass!
        ? 'dynamic'
        : 'dynamic Function()'}> $registryName = {');
    for (var className in classNames) {
      isQueryClass!
          ? className = className.replaceFirst('Entity', "")
          : className;


      //
      if (isQueryClass! && isSerializerClass!) {
        buffer.writeln(
            "  '$className': { 'type': $className,'queryClass':${className}Query(),'serializerClass': ${className}Serializer(),'fromMap': ${className}Serializer.fromMap},");
      }
      //'routeBuilder': (route)=>RouteEntityBuilder<$className>(router: route)},
      else if (isQueryClass! == true) {
        buffer.writeln(
            "  '$className': { 'type': $className,'queryClass':${className}Query()},");
      }
      else {
        buffer.writeln("  '$className': () => $className() },");
      }
    }
      buffer.writeln('};');

      final outputPath = '${dir.path}/$outputFileName';
      File(outputPath).writeAsStringSync(buffer.toString());
      print('Index generated at $outputPath');

  }



  static void printHelp() {
    print('''
ClassesIndexGenerator - Dart Class Index Generator
Create a registy as Map of all class associated to there empty constructors.
Usage:
  dart run your_script.dart [options]

Options:
  -dir <directory>      Directory to scan for .dart files (default: lib/controllers)
  -model                If you work on models' directories set this boolean to true 
  -name <registryName>  Name of the generated registry variable (default: classIndex)
  -out <outputFile>     Output file name for the registry (default: class_registry.dart)
  -h, --help            Show this help message  

Examples:
  dart run ClassesIndexGenerator.dart 
  dart run ClassesIndexGenerator.dart -dir lib/services -name serviceIndex -out Service_registry.dart
  dart run ClassesIndexGenerator.dart -name controller_registry -out Controller_index.dart
  dart run ClassesIndexGenerator.dart -dir '../../BDD/Model' -name QueryClass_Index -out Entity_Index.dart -queryClass true -serializerClass true  
''');
  }

  static void cli(List<String> args) {
    // Defaults
    var dir = Directory('../../Controller');
    var registryName = 'classIndex';
    var outputFileName = 'class_index.dart';
    var  isQueryClass= 'false';
    var isSerializerClass ='false';

    for (var i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '-dir':
          if (i + 1 < args.length) dir = Directory(args[++i]);
          break;
        case '-name':
          if (i + 1 < args.length) registryName = args[++i];
          break;
        case '-out':
          if (i + 1 < args.length) outputFileName = args[++i];
          break;
        case '-queryClass':
          if (i + 1 < args.length) isQueryClass = args[++i] ;
          break;
        case '-serializerClass':
          if (i + 1 < args.length) isSerializerClass = args[++i] ;
          break;
      case '--help':
      case '-h':
      printHelp();
      return;
      }
    }
    var isQueryClas= bool.parse(isQueryClass);
    var isSerializerClas= bool.parse(isSerializerClass);
     print('classIndexGenerator L130$isQueryClas');

    init(dir,registryName,outputFileName ,isQueryClass: isQueryClas ,isSerializerClass: isSerializerClas);

  }


  static init(dir,registryName,outputFileName,{bool isQueryClass=false,bool isSerializerClass=false}){
    ClassesIndexGenerator(
      dir: dir,
      registryName: registryName,
      outputFileName: outputFileName,
      isQueryClass : isQueryClass,
      isSerializerClass: isSerializerClass,
    ).generate();
  }



}

void main(List<String> args) {
  ClassesIndexGenerator.cli(args);
}
