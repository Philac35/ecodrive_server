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


  void set  title(String title) ;
  void  set identificationNumber(int identificationNumber);
  void set photo(PhotoEntity? photo);

  void set driver(DriverEntity? driver);

}