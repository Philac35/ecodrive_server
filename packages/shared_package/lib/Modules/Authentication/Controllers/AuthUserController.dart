import 'dart:convert';

//Token Service have a pb with flutter 8/08/2025
//Todo Debug , pb don't come from LogSystemBDD
//import 'package:shared_package/Services/CryptService/TokenService.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:shared_package/BDD/Executor/MysqlPoolExecutor.dart';
import 'package:shared_package/BDD/Interface/entityInterface.dart';
import 'package:shared_package/BDD/Model/AbstractModels/UserEntity.dart';
import 'package:shared_package/Controller/Controller.dart';

import 'package:shared_package/Controller/DriverController.dart';
import 'package:shared_package/Controller/UserController.dart';
//import 'package:shared_package/Services/LogSystem/LogSystemBDD.dart';
import 'package:shared_package/Services/LogSystem/LogSystem.dart';

import '../../../BDD/Model/AbstractModels/Modules/Authentication/Entities/AuthUserEntity.dart' as a;

import '../../../BDD/Connection/MysqlConnection.dart';
import '../../../BDD/Model/Abstract/PersonEntity.dart';
import '../../../Repository/Repository.dart';
import '../Authenticator.dart';
import '../Entities/AuthUserEntity.dart';
import '../Entities/AuthUser.dart';

import '../Repository/AuthUserRepository.dart';



                           //Person|User
class AuthUserController<T extends dynamic> extends Controller<AuthUser> {
  //Lorsque l'on cree un AuthUser on créé aussi un user.
  // User fait le lien entre Driver et Passager,
  // celui-ci peut être soit Driver soi Passager soi les deux

  AuthUserEntity? authUser;
  Person? person;
  User? user;
  Authenticator? authenticator;
  late bool isConnected;
   Controller<EntityInterface>?  controller;

  //late TokenService tokenService;
   @override
   Repository<EntityInterface>? repository ;

   @override
 late Future<bool> ready;

  AuthUserController(){

    print('AuthUserController use of empty controller L51');
    //var isInit=super.initRepository();
    ready=  initRepository();
    this.authenticator = Authenticator(this);

  }


  AuthUserController.person(this.person) {
    print('AuthUserController With user L54');
    this.authenticator = Authenticator(this);
    super.repository = AuthUserRepository() as Repository< EntityInterface>?;
  }
  AuthUserController.user(this.user) {
    print('AuthUserController With user L54');
    this.authenticator = Authenticator(this);
    super.repository = AuthUserRepository() as Repository< EntityInterface>?;
  }

  AuthUserController.authUser({required this.authUser}) {
    print('AuthUserController With authuser L60');
    this.authenticator = Authenticator(this);
    super. repository = AuthUserRepository() as Repository< AuthUserEntity>?;
  }

  authenticateUser(Person? person) {
    if (person != null) {
      return authenticateAuthUser(person.authUser as AuthUserEntity?);
    } else if (this.person != null) {
      return authenticateAuthUser(this.person?.authUser as AuthUserEntity?);
    } else {
      print(
          "AuthUserController authenticateUser L26 : User doesn't exist or is null");
    }
  }



  @override
  Future<bool> initRepository() async{
    bool ret=false;
 //  bddService.initMySqlPoolConnection();

    repository= (await AuthUserRepository(connexionPool: connectionPool));

    if(repository != null) ret==true;
    print("Controller debug L102 :${repository.toString()}");
    return ret;
  }


  Future<bool> authenticateAuthUser(AuthUserEntity? authUser) async {
    if (authUser != null) {
      return  (authenticator)!.authenticate(authUser as AuthUser);
    } else if (this.authUser != null) {
      return (authenticator)!.authenticate(this.authUser! as AuthUser);
    } else {
      print(
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
     // this.tokenService.deleteToken();
      isConnected = authenticator?.deconnect();

      print('AuthUserController L105, deconnect : User was deconnected');
    } catch (e) {
      print(
          'AuthUserController L108, deconnect : User wasn\'t deconnected');
      print( 'User wasn\'t deconnected');
      //LogSystemBDD().log('AuthUserController L105, deconnect : User wasn\'t deconnected');
    }
  }


  Future<EntityInterface?> create({required Map<dynamic, dynamic> parameters}) async {
    EntityInterface? ret;

    //Map<String, dynamic> parameter =SymbolToStringConverter.convertSymbolKeysToString(parameters);
    parameters['createdAt']=DateTime.now();
    parameters['updatedAt']=DateTime.now();

    if(parameters['id']!=null) {
      parameters['id'] = parameters['id'] is int ? parameters['id'].toString() : parameters['id'];
    }
// supported keys: [any_map, checked, constructor, create_factory, create_field_map, create_json_keys, create_per_field_to_json, create_to_json, disallow_unrecognized_keys, explicit_to_json, field_rename, generic_argument_factories, ignore_unannotated, include_if_null]
    AuthUser entity= AuthUserEntity.fromJson(parameters as Map<String,dynamic>) as AuthUser;


    //T entity = entityFactory!(parameter);

    print("AuthUserController L148, entity ${entity.toString()}");

    //ORM orm= ORM();
    //ret=  await orm.persist(entity)!=null ? true:false;

    return  await save(entity);

  }

  createAuthUserFromUser(User user) {
    //TODO Implement
    throw ("Implement createAuthUser");
  }

  createAuthUser({required String identifiant, required String password, List<String>? role, int? personId}) {
  AuthUserEntity authUser =AuthUser(identifiant: identifiant, password: password, role: role,  personId: personId );
      save(authUser as EntityInterface);
     return true;
  }

  reifyAuthUser({required String identifiant, required String password, List<String>? role, int? id}) {
    String? idStr= id?.toString();
    this.authUser=AuthUser(identifiant: identifiant, password: password, role: role ,id:idStr!);
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
      final User user = User.fromJson(userData) ;
      String role = user.authUser?.role as String;
    Controller relatedController;
      // Create the appropriate controller based on the role
      switch (role) {
        case 'driver':
          relatedController = DriverController() ;
           relatedController != null? relatedController?.create(parameters:user as Map<String, dynamic>):null;
          break;
        default:
          relatedController = UserController()  ;
          await relatedController!.create(parameters: user as Map<String, dynamic>);
          break;
      }
    } catch (e) {
      print("AuthUserController: Could not parse User. Error: $e");
    /*  if (kIsWeb) {
        LogSystemBDD()
            .error("AuthUserController: Could not parse User. Error: $e");
      } else {*/
        LogSystem()
            .error("AuthUserController: Could not parse User. Error: $e");
      //}*/
      rethrow;
    }

    //Creation et de token
    //this.createToken();

    //TODO Needed for Configuration du guard
    //AutoRouter.of(context).pop(true);
  }




  @override
  Future<bool> delete(int? id )async {
    bool exit=false;

    try {

      if((await ready) == false){await initRepository();}
      print(' Controller L239, childId Type:${id.runtimeType.toString()}, id: ${id}');


        exit= await repository!.delete(id:id);


    } catch (e) {
      print('Error deleting entity ${T.toString()}, id ${id.toString()}: $e');
    }
    return exit;
  }




  @override
  Future<EntityInterface?>? save(EntityInterface?  entity)async {

    EntityInterface? exit;
    try {

      if((await this.ready)==null){await this.initRepository();}

      exit= await repository?.persist(entity as a.AuthUser);


    } catch (e,stack) {
      print('AuthUserControler L264, Error creating entity: $e');
      print('stack: $stack');
    }
    exit != null? print("entity persisted !"):print("entity not persisted!");

    return exit;
  }

  @override
  Future<EntityInterface?> update({EntityInterface? entity,Map<String,dynamic>? parameters})async {
    EntityInterface? exit;
    if(entity!=null){parameters= entity.toJson();}
    try {
      exit=   await repository?.update( parameters: parameters!,whereClause:{'id':parameters['id']});  //TODO Check if it works

    } catch (e) {
      print('Controller L193: Error creating entity: $e');
    }
    return exit;
  }




  //FETCH Function

  @override
  Future<List<a.AuthUser?>?> getEntities() async {
    return    (repository as AuthUserRepository)?.findAll() as Future<List<a.AuthUser?>?>  ;
  }


  @override
  //Future<Map<String, dynamic>>
  Future<a.AuthUser?> getEntity(int id) async {
    return (repository as AuthUserRepository) ?.findById(id);
  }



  Future<List<a.AuthUser>?> findBy(Map<String,dynamic> parameters) async {

    return (repository as AuthUserRepository)?.findBy(parameters)! as  Future<List<a.AuthUser>?>;
  }



  Future<AuthUser?> findByFields(Map<String,dynamic> parameters) async {
    var ret;
    try{
      ret= (await repository?.findBy(parameters))?.first;
      print(' type of findByFields, retour type:${ret.runtimeType}');
    }catch(e){print("Controller L249, FindByFields error: ${e}");
    print("Controller L250 Parameters: ${parameters}");}

    return ret;
  }


  Future<a.AuthUser?> getLast()async{
    return (repository as AuthUserRepository)?.findLast() ;
  }

  @override
  Future<int?> getLastId() async {
    try {
      return await repository?.getLastId();
    }catch(e,stack){
      print("Controller, getLastId error:$e");
      print("Controller, getLastId stack:$stack");

    }}
/*
  void createToken() {
    tokenService.createToken(controller.entity!.toJson().toString());
    tokenService.persist();
  }
*/
  Map<String, Function> get functionMap => {'create': create, 'delete': delete, 'save': save, 'update': update, 'getEntities': getEntities, 'getEntity': getEntity, 'getLast': getLast, 'getLastId': getLastId,'findByFields':findByFields };

}
