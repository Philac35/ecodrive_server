import 'dart:math';

import 'package:shared_package/Services/HTMLService/HTMLService.dart';
import 'package:shared_package/Services/Interface/Service.dart';

import '../../BDD/Model/AbstractModels/PhotoEntity.dart';


class HTMLSendPhotoService implements Service{


  late Photo photo;
  late HTMLService htmlService;

  HTMLSendPhotoService(){
    htmlService=  HTMLService();

  }


  @override
  int getId() {
    var random = Random();
    int randomNumber = random.nextInt(10 ^ 15);
    return randomNumber;
  }


  void _sendImage() async {
   var  data=photo.toJson();
    htmlService.send(htmlRequest:'api/photo/upload',method:'POST',data:data);


    }

}

/* Other method
      var request = http.MultipartRequest('POST', Uri.parse('api/photo/upload'));
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          await photo!.readAsBytes(),
          filename: photo!.path.split('/').last,
          contentType: MediaType.parse('image/jpeg'),
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image');
      }*/