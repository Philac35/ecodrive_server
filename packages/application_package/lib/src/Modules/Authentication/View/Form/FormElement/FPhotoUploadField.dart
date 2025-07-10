import 'dart:io';
import 'package:camera/camera.dart';
import 'package:application_package/src/Modules/ImageCamera/Contoller/ImageCameraController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../ImageCamera/ImageCameraLite.dart';
import '../Controller/AccountCreationController.dart';
import '../Controller/ControllerFormInterface.dart';

class FPhotoUploadField extends StatefulWidget {

  @override
  Key key;
  FPhotoUploadField({required this.key}):super(key:key);
  @override
  State<StatefulWidget> createState() => FPhotoUploadFieldState();
}

class FPhotoUploadFieldState extends State<FPhotoUploadField> {
  File? _image;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();
  late ImageCameraController _imageCameraController ;
  late ImageCameraLite? imageCamera;
  late ControllerFormInterface  controller;

  FPhotoUploadFieldState(){
    controller = Get.find<AccountCreationController>();
  //  initState();
  }
  void _selectImage() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      Uint8List? imageBytes;
      if (kIsWeb) {
        // Use Image.memory or Image.network for Flutter Web but Uint8List is available for both
        // On web, read bytes asynchronously
        imageBytes = await photo.readAsBytes();
        (controller as AccountCreationController).updatePhoto(photo);
      } else {
        // On mobile/desktop, use the file path
        // For mobile/desktop, we can still read bytes if needed
        imageBytes = await photo.readAsBytes();
      }
      initState() {
      var cameraDescription = CameraDescription(name: "PhotoCam",lensDirection: CameraLensDirection.external, sensorOrientation: 0);
      _imageCameraController= Get.put(ImageCameraController(cameraDescription,ResolutionPreset.high));
        imageCamera = ImageCameraLite();
        _imageCameraController = ImageCameraController(_imageCameraController.description,_imageCameraController.cameraContParam['presetResolution']);
        _imageCameraController.initCameraController(_imageCameraController.cameraContParam as Map<String, dynamic>);
        debugPrint(_imageCameraController as String?);
      }
      setState(() {
        if (kIsWeb) {
          // Use Image.memory or Image.network for Flutter Web but Uint8List is available for both
          _imageBytes = imageBytes;
        } else {
          // Use Image.file for desktop platforms
          _imageBytes = File(photo.path) as Uint8List?;
        }
        // _image = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_image != null) Image.file(_image!),
        SizedBox(height: 20),
        if (_imageBytes != null)
          kIsWeb
              ? Image.memory(_imageBytes!) // Display image from bytes on web
              : Image.memory(
                  _imageBytes!) // Display image from bytes on mobile/desktop
        else
          Text('No image selected'),
    SizedBox(height: 20),
        //this._imageCameraController != null && this._imageCameraController!.isInitialized?  ImageCamera(): Center(child: CircularProgressIndicator()),

    SizedBox(height: 20),
        Padding(padding: EdgeInsets.only(top: 16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _selectImage,
              child: Text('Select from Gallery'),
            ),
           /*
           * ElevatedButton(

            *  onPressed: _imageCameraController?.
             * takePhoto,
              *child: Icon(Icons.camera_alt),
            *),

            */
          ],
        ),

      ],
    );
  }
}
