import 'dart:typed_data';



import 'package:angel3_framework/angel3_framework.dart';

import '../../../Interface/entityInterface.dart';
import '../DriverEntity.dart';
import '../PhotoEntity.dart';
abstract class Document extends Model implements EntityInterface{

  String? get  title;
  int?  get  identificationNumber;
  PhotoEntity? get photo;
  String? get path;
  Uint8List? get documentPdf;

  set  title(String? title) ;
  set identificationNumber(int? identificationNumber);
  set photo(PhotoEntity? photo);

}