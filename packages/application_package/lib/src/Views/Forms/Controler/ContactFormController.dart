

import 'package:flutter/material.dart';

import 'package:get/get.dart';


class ContactFormController extends GetxController {



  late Map<Key, RxString> fieldValues = <Key, RxString>{}.obs;
  var clearField= false.obs;
  var isEmailSent= false.obs;

  ContactFormController();



  //Use ContacFormController as singleton
  //It is initialized in Contact page
  static ContactFormController get to => Get.find();

/*
 * Function registerField
 * Use to bind field to ContactFormController
 */
  void registerField(Key key, String initialValue) {
    fieldValues[key] = initialValue.obs;
    debugPrint('Field registered: $key with initial value: $initialValue');

  }
  void updateField(Key key, String value) {
    debugPrint('Updating field: $key with value: $value');
    if (obs.value.fieldValues.containsKey(key)) {
      obs.value.fieldValues[key]!.value = value;
      debugPrint('Field updated: $key with value: $value');
    } else {
      debugPrint('Field not found: $key');
    }
    debugPrint('fieldValues after update: ${obs.value.fieldValues.toString()}');
  }
  Map<Key, RxString> fetchData() {
    //debugPrint('Fetching data: ${fieldValues.entries.toString()}');
    debugPrint('Fetching data: ${obs.value.fieldValues.toString()}');
    //return Map<Key, RxString>.from(fieldValues); //Return a copy of fieldValues
    return obs.value.fieldValues;
  }

  /*
  Map<Key, RxString> fetchData() {
    debugPrint('Fetching data: ${fieldValues.entries.toString()}');
    return Map<Key, RxString>.from(fieldValues); // Return a copy of fieldValues
  }
*/

  void delete() {
    obs.value.fieldValues.clear();
    clearField.value = true;
    debugPrint('Field values deleted');
    debugPrint('fieldValues after delete: ${obs.value.fieldValues.toString()}');
  }

  Future<bool> send() async {

    try {
      debugPrint('Before fetchData: ${fieldValues.entries.toString()}');
      Map<Key, RxString> data = fetchData();
      debugPrint('After fetchData: ${data.toString()}');
      //debugPrint('After fetchData: ${fieldValues.entries.toString()}');

      if (fieldValues.isEmpty) {
        throw ("ContactFormController L72, Form values are empty!");
      }

      Map<String, String> emailData = fieldValues.map((key, values) {
        return MapEntry(key.toString(), values.value);
      });

      debugPrint('Email data: $emailData');


      /*
      isEmailSent.value = (await htmlService.send(
        htmlRequest: 'https://localhost:2000/email',
        method: 'POST',
        data: jsonEncode(emailData),
        isEncrypted: true,
      )) ;

      if(isEmailSent.value == true) clearField.value = true;

      return isEmailSent.value;*/
    } catch (e) {
      debugPrint("ContactFormController L94 Error: $e");
    }
    return false;
  }

  }


