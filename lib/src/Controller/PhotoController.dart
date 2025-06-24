import 'package:angel3_framework/angel3_framework.dart';
import 'package:angel3_orm/angel3_orm.dart';

import 'package:ecodrive_server/src/Controller/Controller.dart' as controller;

import '../BDD/Model/AbstractModels/PhotoEntity.dart'  ;

@Expose('/Photo')
class PhotoController extends controller.Controller<Photo>{


}