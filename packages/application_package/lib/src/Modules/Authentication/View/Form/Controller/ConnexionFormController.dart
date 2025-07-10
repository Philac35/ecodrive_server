import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_package/Services/CryptService/CryptService.dart';
import 'package:shared_package/Services/HTMLService/HTMLService.dart';
import 'package:shared_package/Modules/Authentication/Entities/AuthUser.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:get/get.dart';
import 'package:convert/convert.dart';


import '../../../../../BDD/Model/AbstractModels/UserEntity.dart';
import '../../../Controllers/AuthUserController.dart';
import 'ControllerFormInterface.dart';
import 'package:flutter/foundation.dart';

class ConnexionFormController  extends GetxController implements ControllerFormInterface {


  late Map<Key, RxString> fieldValues = <Key, RxString>{}.obs;
  late HTMLService htmlService;
  late AuthUserController authController;


  @override
  get clearField => false.obs;


  ConnexionFormController(){

    htmlService= HTMLService();
    authController= AuthUserController<User>();
  }




  //Use ContacFormController as singleton
  //It is initialized in Contact page
  static ConnexionFormController get to => Get.find();

/*
 * Function registerField
 * Use to bind field to ContactFormController
 */
  void registerField(Key key, String initialValue) {
    fieldValues[key] = initialValue.obs;
    debugPrint('Field registered: $key with initial value: $initialValue');

  }

  void updateField(Key key, String value) {
    if (fieldValues.containsKey(key)) {
      fieldValues[key]!.value = value;
      debugPrint('Field updated: $key with value: $value');
    } else {
      debugPrint('Field not found: $key');
    }
  }

  Map<Key, RxString> fetchData() {
    //debugPrint('Fetching data: ${fieldValues.entries.toString()}');
    debugPrint('Fetching data: ${obs.value.fieldValues.toString()}');
    //return Map<Key, RxString>.from(fieldValues); //Return a copy of fieldValues
    return obs.value.fieldValues;
  }



  delete(){
    fieldValues.clear();
    clearField.value=true;
    debugPrint('Field values deleted');
  }



  Future<bool> send() async{

   var res= processInformations();
 debugPrint('ConnexionFormController : authUser :${authController.authUser!.identifiant}');
   Future<bool> isSendAuthentication=  authController.authenticateAuthUser(authController.authUser!)  ;

   // Future<bool> isSendAuthentication=  htmlService.send(htmlRequest: "https://localhost:5003/authentication", method: 'POST',data:jsonEncode(res), isEncrypted: true);
    return isSendAuthentication;
  }





 Future< Map<String, dynamic>> processInformations() async {
    Iterable<RxString> rXvalues = fieldValues.values;
 //   debugPrint("ConnexionFormController L88 rXvalues identifiant: "+rXvalues.elementAt(0).toString());
   authController.reifyAuthUser(username:rXvalues.elementAt(0).toString(), password:rXvalues.elementAt(1).toString() );
 //   debugPrint("ConnexionFormController L88"+authController.toString());
    return authController.authUser!.toJson();
  }

}