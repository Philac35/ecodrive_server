import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_orm/angel3_orm.dart';

import 'package:ecodrive_server/src/Controller/Controller.dart' as controller;

import '../BDD/Model/AbstractModels/TravelEntity.dart'  ;

@Expose('/Travel')
class TravelController extends controller.Controller<Travel>{


}