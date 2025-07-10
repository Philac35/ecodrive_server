import 'dart:convert';
import 'dart:core';
import 'dart:core' show Map ;

import 'package:camera/camera.dart';

import 'package:get/get.dart';

import 'package:shared_package/Controller/Controller.dart';
import 'package:shared_package/BDD/Model/AbstractModels/DriverEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/UserEntity.dart';
import 'package:shared_package/BDD/Model/AbstractModels/PhotoEntity.dart';
import 'package:shared_package/Services/HTMLService/HTMLService.dart';


import 'package:shared_package/Controller/DriverController.dart';
import 'package:shared_package/Controller/UserController.dart';
import '../../../Controllers/AuthUserController.dart';
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
  @override
  late  Map<Key, RxString> fieldValues = <Key, RxString>{}.obs;
  late HTMLService htmlService;
   String backgroundAddress='';

  @override
  get clearField => false.obs;


  AccountCreationController(){
    htmlService= HTMLService();
  }

  //TODO Test if this function work cf. sub entities :  photos and address
  @override
  Future<Map<String, dynamic>> processInformations() async {
    Map<String, dynamic> res = {};

    Iterable<RxString> rx = fieldValues.values;
    Map<String, dynamic> entityMap = fieldValues.map(
            (key, rx) => MapEntry(key.toString(), rx.value)
    );

    // Debug print the entire entityMap
    debugPrint('Entities Map: $entityMap');

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
        driverController = DriverController();
        isCreated =  driverController?.create(entityMap.cast<Symbol, dynamic >()) ;
        if(isCreated==true){
          Driver  user = await  userController?.repository?.findLast() as Driver ;
          entityId=  int.parse( user.id!) ;}
        break;

      case 'passenger':
        userController = UserController();
        isCreated = userController?.create(entityMap.cast<Symbol, dynamic>()) ;
        if(isCreated==true){
          User  user = await  userController?.repository?.findLast() as User ;
          entityId=  int.parse( user.id!) ;}
        break;

      case 'passenger-driver' || 'driver-passenger':
        driverController = DriverController();
        isCreated =driverController?.create(entityMap.cast<Symbol,dynamic >()) ;
        if(isCreated==true){
          Driver  user = await  userController?.repository?.findLast() as Driver ;
          entityId=   int.parse(user.id! );}

        break;

      default:
        userController = UserController();
        isCreated = userController?.create(entityMap.cast<Symbol,dynamic >()); //Here when you create the Entities they are automatically persisted
        if(isCreated == true){
            User  user = await  userController?.repository?.findLast() as User ;
          entityId=   int.parse(user.id!) ;}

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
  @override
  void registerField(Key key, String initialValue) {
    fieldValues[key] = initialValue.obs;
    debugPrint('Field registered: $key with initial value: $initialValue');

  }

  @override
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
      isSent= htmlService.send(htmlRequest:'$backgroundAddress/api/accountCreation',method:'POST',data:informations);
    return isSent;
  }


}

