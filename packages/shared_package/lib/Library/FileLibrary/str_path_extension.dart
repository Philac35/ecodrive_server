import 'dart:io';

import 'package:shared_package/Library/StringLibrary/str_extension.dart';

extension StrPathExtension on String{

  separatorAtFirst(){
    if ((this as String).firstCaracter()!= Platform.pathSeparator){
     return  Platform.pathSeparator+this; }
    else{ return this;}
  }
}