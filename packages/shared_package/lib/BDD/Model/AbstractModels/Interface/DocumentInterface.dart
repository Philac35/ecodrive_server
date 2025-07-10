import 'dart:typed_data';



import '../../../Interface/entityInterface.dart';
import '../DriverEntity.dart';
import '../PhotoEntity.dart';
abstract interface class DocumentInterface implements EntityInterface{


  String get  title;
  int  get  identificationNumber;
  PhotoEntity? get photo;
  Uint8List? documentPdf;
  DriverEntity? get driver;


  set  title(String title) ;
  set identificationNumber(int identificationNumber);
  set photo(PhotoEntity? photo);

  set driver(DriverEntity? driver);

}