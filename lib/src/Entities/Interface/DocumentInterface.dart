import 'dart:typed_data';


import 'entityInterface.dart';
import '../Photo.dart';
import '../Driver.dart';

abstract interface class DocumentInterface implements EntityInterface{

  String get  title;
  int  get  identificationNumber;
  Photo? get photo;
  Uint8List? documentPdf;
  Driver? get driver;

  void set  title(String title) ;
  void  set identificationNumber(int identificationNumber);
  void set photo(Photo? photo);

  void set driver(Driver? driver);

}