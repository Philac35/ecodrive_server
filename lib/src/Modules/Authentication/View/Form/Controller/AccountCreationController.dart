import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:core' show Map ;
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:camera/camera.dart';
import 'package:ecodrive_server/src/Entities/Interface/entityInterface.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:get/get.dart';

import 'package:ecodrive_server/src/Controller/Controller.dart';
import 'package:ecodrive_server/src/Entities/Driver.dart';
import 'package:ecodrive_server/src/Entities/User.dart';
import 'package:ecodrive_server/src/Services/HTMLService/HTMLService.dart';
import 'package:ecodrive_server/src/Entities/Photo.dart';

import '../../../Controllers/AuthUserController.dart';
import '../../../Entities/AuthUser.dart';
import 'ControllerFormInterface.dart';
import 'package:flutter/foundation.dart';

// Here we must use Entities
// AUth Entities
// Address
// Driver
// User
class AccountCreationController extends GetxController implements ControllerFormInterface{


  Controller<Driver>? driverController;
  Controller<User>? userController;
  late  Map<Key, RxString> fieldValues = <Key, RxString>{}.obs;
  late HTMLService htmlService;
   String backgroundAddress='';

  @override
  get clearField => false.obs;


  AccountCreationController(){
    htmlService= HTMLService();
  }

  //TODO Test if this function work cf. sub entities :  photos and address
  Future<Map<String, dynamic>> processInformations() async {
    Map<String, dynamic> res = {};

    Iterable<RxString> rx = fieldValues.values;
    Map<String, dynamic> entityMap = fieldValues.map(
            (key, rx) => MapEntry(key.toString(), rx.value)
    );

    // Debug print the entire entityMap
    debugPrint('Entity Map: $entityMap');

   Future <bool>? isCreated ;
   int entityId ;

    // It must be bind with authEntity
    if (entityMap['photo'] != null) {
      // Handle photo if needed
    }



    // Debug print the role value
    String role = entityMap['role']?.toLowerCase().trim() ?? '';
    debugPrint('Role value: $role');

    // TODO beneath entity relative to role, seams to manage address and photos but it must be tested
    switch (role) {
      case 'driver':
        driverController = Controller<Driver>();
        isCreated =  driverController?.create(entityMap) ;
        if(isCreated==true){
          Driver  user = await  userController?.repository?.findLast() as Driver ;
          entityId=   user.id! ;}
        break;

      case 'passenger':
        userController = Controller<User>();
        isCreated = userController?.create(entityMap) ;
        if(isCreated==true){
          User  user = await  userController?.repository?.findLast() as User ;
          entityId=   user.id! ;}
        break;

      case 'passenger-driver' || 'driver-passenger':
        driverController = Controller<Driver>();
        isCreated =driverController?.create(entityMap) ;
        if(isCreated==true){
          Driver  user = await  userController?.repository?.findLast() as Driver ;
          entityId=   user.id! ;}

        break;

      default:
        userController = Controller<User>();
        isCreated = userController?.create(entityMap); //Here when you create the Entities they are automatically persisted
        if(isCreated == true){
            User  user = await  userController?.repository?.findLast() as User ;
          entityId=   user.id! ;}

        break;
    }

    //If entity is created, we  must create authEntity binded.
    //TODO /!\ The used id must be one of table of superior level, otherwiser we will have the same id for differents tables.
    // Relation OneToMany   une table autherController is binded to several other table
    if(isCreated == true) {
      // Reification
      AuthUserController authController= AuthUserController();
      Pattern p = RegExp("[-|,]");
      List<String> role=  (entityMap['role'] as String).split(p);
      isCreated=authController.createAuthUser(username: entityMap['identifiant'], password:entityMap['password'],role:role );
      //res.addAll(authUserEntry);
    }




    // Send
    return res;
  }






  //Use ContacFormController as singleton
  //It is initialized in Contact page
  static AccountCreationController get to => Get.find();



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


  Future<void> updatePhoto(XFile photo) async {
    Photo image=Photo(title:photo.name, uri:photo.path,description: 'Photo de Profile' , photo: await photo.readAsBytes() );
     updateField(ValueKey('photo'), jsonEncode(image.toJson()));
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
    debugPrint('Field values deleted') ;

  }

  Future<bool>send(){
    Future<bool> isSent= Future<bool>(()=>false) ;
    var formInfo=processInformations();
   String informations=jsonEncode(formInfo);
      isSent= htmlService.send(htmlRequest:backgroundAddress+'/api/accountCreation',method:'POST',data:informations);
    return isSent;
  }


}

