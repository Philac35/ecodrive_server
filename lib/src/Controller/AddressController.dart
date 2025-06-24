
import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_orm/angel3_orm.dart';

import 'package:ecodrive_server/src/Controller/Controller.dart' as controller;

import '../BDD/Model/AbstractModels/AddressEntity.dart'  ;

@Expose('/Address')
class AddressController extends controller.Controller<Address>{


}