import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_package/Services/LogSystem/LogSystem.dart';
import 'package:shared_package/Services/LogSystem/LogSystemBDD.dart';
import 'Contoller/ImageCameraController.dart';



//First goal : Developpement For android and IOS
//PB with web platform getDeviceList
class ImageCamera extends StatefulWidget {
  const ImageCamera({super.key});

  @override
  State<StatefulWidget> createState() {
    return ImageCameraState();
  }
}





class ImageCameraState extends State<ImageCamera> {


  List<CameraDescription> _cameras = [];
  Uint8List? _imageBytes;
  CameraDescription? cameraDescription;
  late Map<String,dynamic> cameraContParam;
  late ImageCameraController _cameraController ;

 @override
  void initState() {

   super.initState();
    cameraDescription = CameraDescription(name: "PhotoCam",lensDirection: CameraLensDirection.external, sensorOrientation: 0);
    _cameraController  = Get.put(ImageCameraController( cameraDescription!,ResolutionPreset.high));
   _cameraController.setCameraContParam({
     'enableAudio': false,
     'imageFormatGroup': ImageFormatGroup.jpeg
   });

   cameraContParam=  {'cameraDescription': cameraDescription, 'resolution': ResolutionPreset.high,  'enableAudio': false,  'imageFormatGroup': ImageFormatGroup.jpeg };
   initCameraController(cameraContParam) ;
  }

  ImageCameraState();


  Future<void> initCameraController(Map<String,dynamic> cameraContParam) async {
    // Request camera permission
    final status = await Permission.camera.request();
    if (status.isGranted) {
      print('status camera L57 : ${status.isGranted}');
      //Initialize camera
      try {
        _cameras = await availableCameras();
        if (_cameras.isEmpty) {
          debugPrint('No cameras available');
        }
      } catch (e) {
        debugPrint("There is a pb with availableCameras()");
      }
      try {
        _cameraController = ImageCameraController.init(
          description:cameraContParam['cameraDescription'],
          resolutionPreset: cameraContParam['resolution'],
          enableAudio:cameraContParam['enableAudio'],
          imageFormatGroup: cameraContParam['imageFormatGroup'],
        ); //    cameraDescription,

        await _cameraController.initialize();
        debugPrint('Camera intialized successfully');
      } catch (e) {
        if (kDebugMode) {
          debugPrint(
              "FPhotoUploadField L65 initCamera(): erreur d'initialisation de la camera :$e");
          if (isSkiaWeb) {
            LogSystemBDD().log(
                "FPhotoUploadField L68 iniCamera(): erreur d'initialisation de la camera :$e");
          } else {
            LogSystem().error(
                "FPhotoUploadField L71 iniCamera(): erreur d'initialisation de la camera :$e");
          }
        }
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            "FPhotoUploadField L79 initCamera(): Camera permission not granted");
        if (isSkiaWeb) {
          LogSystemBDD().log(
              "FPhotoUploadField L81 iniCamera(): Camera permission not granted");
        } else {
          LogSystem().error(
              "FPhotoUploadField L83 iniCamera(): Camera permission not granted");
        }
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = _cameraController;
    if (!cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCameraController(cameraContParam);
    }
  }

  @override
  Widget build(BuildContext context) {
    CameraDescription cameraDescription = CameraDescription(
        name: "PhotoCam",
        lensDirection: CameraLensDirection.external,
        sensorOrientation: 0);

    return FutureBuilder<void>(
      future: initCameraController(cameraContParam),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_cameraController);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  CameraController? get cameraController => _cameraController;
}

extension on Map<String, dynamic> {
  CameraDescription get cameraDescription => cameraDescription;


}
