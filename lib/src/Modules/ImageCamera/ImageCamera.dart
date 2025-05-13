import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Services/LogSystem/LogSystem.dart';
import '../../Services/LogSystem/LogSystemBDD.dart';
import 'Contoller/ImageCameraController.dart';



//First goal : Developpement For android and IOS
//PB with web platform getDeviceList
class ImageCamera extends StatefulWidget {
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
   this. cameraDescription = CameraDescription(name: "PhotoCam",lensDirection: CameraLensDirection.external, sensorOrientation: 0);
    this._cameraController  = Get.put(ImageCameraController( this.cameraDescription!,ResolutionPreset.high));
   _cameraController.setCameraContParam({
     'enableAudio': false,
     'imageFormatGroup': ImageFormatGroup.jpeg
   });

   this.cameraContParam=  {'cameraDescription': cameraDescription, 'resolution': ResolutionPreset.high,  'enableAudio': false,  'imageFormatGroup': ImageFormatGroup.jpeg };
   this.initCameraController(cameraContParam) ;
  }

  ImageCameraState();


  Future<void> initCameraController(Map<String,dynamic> cameraContParam) async {
    // Request camera permission
    final status = await Permission.camera.request();
    if (status.isGranted) {
      print('status camera L57 : ' + status.isGranted.toString());
      //Initialize camera
      try {
        this._cameras = await availableCameras();
        if (this._cameras.isEmpty) {
          debugPrint('No cameras available');
        }
      } catch (e) {
        debugPrint("There is a pb with availableCameras()");
      }
      try {
        this._cameraController = ImageCameraController.init(
          description:cameraContParam['cameraDescription'],
          resolutionPreset: cameraContParam['resolution'],
          enableAudio:cameraContParam['enableAudio'],
          imageFormatGroup: cameraContParam['imageFormatGroup'],
        ); //    cameraDescription,

        await this._cameraController!.initialize();
        debugPrint('Camera intialized successfully');
      } catch (e) {
        if (kDebugMode) {
          debugPrint(
              "FPhotoUploadField L65 initCamera(): erreur d'initialisation de la camera :${e}");
          if (isSkiaWeb) {
            LogSystemBDD().log(
                "FPhotoUploadField L68 iniCamera(): erreur d'initialisation de la camera :${e}");
          } else {
            LogSystem().error(
                "FPhotoUploadField L71 iniCamera(): erreur d'initialisation de la camera :${e}");
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
    final CameraController? cameraController = this._cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
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
          return CameraPreview(this._cameraController!);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  CameraController? get cameraController => this._cameraController;
}

extension on Map<String, dynamic> {
  CameraDescription get cameraDescription => this.cameraDescription;


}
