

/*
class ExtractFunctionWithAnalyzer {
//Not tested , i prefered to use my ExtractFunctionIndexGenerator cause there is cascading pb to solve
//This is a base and must be improve to run.
//Advantages of using Analyzer : better care of inheritage, mixin, implements etc.



  Future<void> main(List<String> args) async {
    if (args.isEmpty) {
      print('Usage: dart list_methods.dart <file.dart> <ClassName>');
      exit(1);
    }
    final filePath = args[0];
    final className = args[1];

    // Parse the file
    final result = await resolveFile2(path: filePath);
    // result.unit is the AST (CompilationUnit)


    // Find the class declaration in the AST
    ClassDeclaration? classDecl;
    for (var decl in result.unit.declarations) {
      if (decl is ClassDeclaration && decl.name.lexeme == className) {
        classDecl = decl;
        break;
      }
    }

    if (classDecl == null) {
      print('Class $className not found in $filePath');
      exit(2);
    }


    final classElement = libraryElement?.getType(className);

    if (classElement == null) {
      print('Class $className not found in $filePath');
      exit(2);
    }

    // Collect all public instance methods (including inherited)
    final methods = <String, MethodElement>{};
    void collectMethods(InterfaceElement element) {
      for (final method in element.methods) {
        if (!method.isPrivate && !method.isStatic) {
          methods[method.name] = method;
        }
      }
      // Recursively collect from supertypes
      for (final supertype in element.allSupertypes) {
        collectMethods(supertype.element);
      }
    }

    collectMethods(classElement);

    print('Methods for $className (including inherited):');
    for (final name in methods.keys) {
      print('  $name');
    }
  }
}

 */