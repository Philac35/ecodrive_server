import 'dart:convert';

import 'package:ecodrive_server/src/Entities/Interface/entityInterface.dart';
import 'package:ecodrive_server/src/Services/CryptService/TokenService.dart';
import 'package:ecodrive_server/src/Services/LogSystem/LogSystem.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../Controller/Controller.dart';
import '../../../Entities/Driver.dart';
import '../../../Services/LogSystem/LogSystemBDD.dart';
import '../Authenticator.dart';
import '../Entities/AuthUser.dart';
import '../../../Entities/Abstract/Person.dart';
import '../../../Entities/User.dart';
import 'package:flutter/foundation.dart';
import '../Repository/Repository.dart';

class AuthUserController<T extends User> {  //Lorsque l'on cree un AuthUser on créé aussi un user. User fait le lien entre Driver et Passager, celui-ci peut être soit Driver soi Passager soi les deux
  AuthUser? authUser;
  late User? user;
  Authenticator? authenticator;
  late bool isConnected;
  late Controller<T> controller;
  late TokenService tokenService;
  Repository<AuthUser>? repository;

  AuthUserController() {
    this.authenticator = Authenticator(this);
    this.repository = Repository<AuthUser>();

  }

  AuthUserController.user(this.user) {
    this.authenticator = Authenticator(this);
    this.repository = Repository<AuthUser>();
  }

  AuthUserController.authUser({required this.authUser}) {

    this.authenticator = Authenticator(this);
    this.repository = Repository<AuthUser>();
  }

  authenticateUser(User? user) {
    if (user != null) {
      return authenticateAuthUser(user.authUser);
    } else if (this.user != null) {
      return authenticateAuthUser(this.user?.authUser);
    } else {
      debugPrint(
          "AuthUserController authenticateUser L26 : User doesn't exist or is null");
    }
  }

  Future<bool> authenticateAuthUser(AuthUser? authUser) async {
    if (authUser != null) {
      return  (await authenticator)!.authenticate(authUser as AuthUser);
    } else if (this.authUser != null) {
      return (await authenticator)!.authenticate(this.authUser!);
    } else {
      debugPrint(
          "AuthUserController authenticateUser L33 : authUser doesn't exist or is null");
    }
    return false;
  }
/*
  Future<bool> authenticate(String identifiant, String mdp) async {
    bool value;

    // Here it return a boolean true or false // The user is directly fetch by this.fetchUser() an must be available in the getter User after await
    Future<bool> responseJson =(await authenticator?.authenticate(identifiant, mdp)) as Future<bool>;

    this.isConnected = await responseJson;

    this.isConnected ? value = true : value = false;
    return value;
  }
*/

  deconnect() {
    try {
      this.tokenService?.deleteToken();
      isConnected = authenticator?.deconnect();

      debugPrint('AuthUserController L105, deconnect : User was deconnected');
    } catch (e) {
      debugPrint(
          'AuthUserController L108, deconnect : User wasn\'t deconnected');
      debugPrintStack(label: 'User wasn\'t deconnected');
      LogSystemBDD()
          .log('AuthUserController L105, deconnect : User wasn\'t deconnected');
    }
  }

  createAuthUserFromUser(User user) {
    //TODO Implement
    throw ("Implement createAuthUser");
  }

  createAuthUser({required String username, required String password, List<String>? role}) {
     this.authUser =AuthUser(identifiant: username, password: password, role: role );
      save(this.authUser);
     return true;
  }

  reifyAuthUser({required String username, required String password, List<String>? role, int? id}) {
    this.authUser=AuthUser(identifiant: username, password: password, role: role ,id:id);
    return this.authUser;
  }

  /*
   * function fetchUser
   * @Param String userJson
   * Return User implementing EntityInterface
   */
  Future<void> fetchUser(String userJson) async {
    try {
      final Map<String, dynamic> userData = jsonDecode(userJson);
      final User user = User.fromJson(userData);
      String role = user.authUser?.role as String;
      if (role == null) {
        throw Exception("Role of user not found");
      }

      // Create the appropriate controller based on the role
      switch (role) {
        case 'driver':
          this.controller = Controller<Driver>() as Controller<T>;
          await this.controller?.create(user as Map<String, dynamic>);
          break;
        default:
          this.controller = Controller<User>() as Controller<T>;
          await this.controller?.create(user as Map<String, dynamic>);
          break;
      }
    } catch (e) {
      debugPrint("AuthUserController: Could not parse User. Error: $e");
      if (kIsWeb) {
        LogSystemBDD()
            .error("AuthUserController: Could not parse User. Error: $e");
      } else {
        LogSystem()
            .error("AuthUserController: Could not parse User. Error: $e");
      }
      rethrow;
    }

    //Creation et de token
    this.createToken();

    //TODO Needed for Configuration du guard
    //AutoRouter.of(context).pop(true);
  }

  @override
  Future<bool> delete({AuthUser? entity,int? id} )async {
    bool exit=false;
    try {
      var a= await repository?.delete(entity:entity,id:id); //TODO Check if it works
      exit = true;
    } catch (e) {
      debugPrint('Error deleting entity: $e');
    }
    return exit;
  }


  @override
  Future<bool> save(entity)async {
    bool exit=false;
    try {
      var a=   await repository?.persist(entity.toJson() as AuthUser);
      exit = true; // Creation successful
    } catch (e) {
      print('Error creating entity: $e');
    }
    return exit;
  }

  @override
  Future<bool> update(entity)async {
    bool exit=false;
    try {
      var a=   await repository?.update(entity.toJson() as AuthUser);  //TODO Check if it works
      exit = true; // Creation successful
    } catch (e) {
      print('Error creating entity: $e');
    }
    return exit;
  }


  void createToken() {
    tokenService.createToken(controller.entity!.toJson().toString());
    tokenService.persist();
  }
}
