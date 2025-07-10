import 'package:flutter/src/foundation/key.dart';

abstract interface class  ControllerFormInterface {
  get clearField ;

  get fieldValues ;



 Future<Map<String,dynamic>> processInformations();

  void registerField(Key key, String s) ;

  void updateField(Key key, String value) ;


}