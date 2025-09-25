import 'package:shared_package/BDD/Interface/entityInterface.dart';
import 'package:shared_package/BDD/ORM/Transformer/PersonToEmployee.dart';
import 'package:shared_package/BDD/ORM/Transformer/PersonTransformer.dart';
import 'package:shared_package/BDD/ORM/Transformer/Transformer.dart';
import 'package:shared_package/BDD/ORM/Transformer/UserToPersonTransformer.dart';
import 'package:shared_package/BDD/ORM/Transformer/UserFromAuthTransformer.dart';
import 'package:shared_package/BDD/ORM/Transformer/UserTransformer.dart';
import 'package:shared_package/BDD/ORM/Transformer/DriverToUserTransformer.dart';
import 'package:shared_package/BDD/Model/AbstractModels/Modules/Authentication/Entities/AuthUserEntity.dart';

//import '../../../../Modules/Authentication/Entities/AuthUser.dart';
import '../../../Model/Abstract/PersonEntity.dart';
import '../../../Model/AbstractModels/DriverEntity.dart';
import '../../../Model/AbstractModels/EmployeeEntity.dart';
import '../../../Model/AbstractModels/UserEntity.dart';
import '../AdministratorToPersonTransformer.dart';
import '../Combinaison/AllOfTransformer.dart';
import '../Combinaison/OneOfTransformer.dart';
import '../Combinaison/AnyOfTransformer.dart';
import '../EmployeeToPersonTransformer.dart';
import '../Interface/TransformerAbstract.dart';
import '../PersonFromUserTransformer.dart';
import '../PersonToAdministrator.dart';
import '../PersonToAuthUserTransformer.dart';
import '../PersonFromEmployeeTransformer.dart';

/**
 * transformerIndex
 **/
 ///Usage: transformerInder[entityType][relatedType]
final Map<String, Map<String, TransformerAbstract>> transformerIndex = {
  "Driver": {
    "User": DriverToUserTransformer() ,  // map Driver → User
    "Person": AllOfTransformer<Driver>([
      DriverToUserTransformer(),    // first extract User from Driver
    ]),
  },

"Person": {
  "User": AllOfTransformer<Person>([
    PersonTransformer(),   //get fields directly
    //  UserToPersonTransformer(), //inherit User > Person
    ]),
   "AuthUser": PersonToAuthUserTransformer(),
   "Administrator": PersonToAdministrator(),
   "Employee": PersonToEmployee()
},

"User":{
    "Person":AllOfTransformer<User>([  //it returns a person not a user. /!\ if Transformers are not null safe, order is important
      PersonFromUserTransformer(),     //nested entity (must come first)
      UserToPersonTransformer(),       // direct/scalar fields (could be erease if you set if first, specially if there is null fields in other t)
    ])
  },

  /*other exemple : OneOfTransformer<User>([
                      UserFromAuthTransformer(), // build user from person.authUser
                      DriverToUserTransformer()  //build user from driver
                   ]),
  */
  "Administrator":{
    "Person":AdministratorToPersonTransformer(),
  },
  "AuthUser": {
    "User": UserFromAuthTransformer(),
    "Person": AllOfTransformer<AuthUser>([
      UserFromAuthTransformer(),  // first extract User
    ]),

  },
  "Employee":{
    "Person": AllOfTransformer<Employee>([
          EmployeeToPersonTransformer(),   // send common fields to Person
          PersonFromEmployeeTransformer(), // extract field person
  ])},




};
