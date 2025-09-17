import 'package:shared_package/BDD/Interface/entityInterface.dart';
import 'package:shared_package/BDD/ORM/Transformer/PersonTransformer.dart';
import 'package:shared_package/BDD/ORM/Transformer/Transformer.dart';
import 'package:shared_package/BDD/ORM/Transformer/UserToPersonTransformer.dart';
import 'package:shared_package/BDD/ORM/Transformer/UserFromAuthTransformer.dart';
import 'package:shared_package/BDD/ORM/Transformer/UserTransformer.dart';
import 'package:shared_package/BDD/ORM/Transformer/DriverToUserTransformer.dart';

import '../../../Model/Abstract/PersonEntity.dart';
import '../../../Model/AbstractModels/DriverEntity.dart';
import '../../../Model/AbstractModels/UserEntity.dart';
import '../Combinaison/AllOfTransformer.dart';
import '../Combinaison/OneOfTransformer.dart';
import '../Combinaison/AnyOfTransformer.dart';





final transformerIndex = {
  //User: UserTransformer(),
  "Driver": AllOfTransformer<Driver>([
   // DriverTransformer(),

  ]),


  "User": OneOfTransformer<User>([
               UserFromAuthTransformer(), // build user from person.authUser
               DriverToUserTransformer()  //build user from driver
          ]),

  "Person": AllOfTransformer<Person>([
             PersonTransformer(),  //get fields directly
             UserToPersonTransformer(),  //inherit User > Person

  ]),


};
