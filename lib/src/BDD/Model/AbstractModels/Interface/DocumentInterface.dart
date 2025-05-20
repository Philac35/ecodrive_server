import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';



import '../../../../Entities/Interface/entityInterface.dart';
import '../Driver.dart';
import '../Photo.dart';
abstract interface class DocumentInterface implements EntityInterface{

  int? get  id_Int;
  String get  title;
  int  get  identificationNumber;
  Photo? get photo;
  Uint8List? documentPdf;
  Driver? get driver;

  void set (int idInt);
  void set  title(String title) ;
  void  set identificationNumber(int identificationNumber);
  void set photo(Photo? photo);

  void set driver(Driver? driver);

}