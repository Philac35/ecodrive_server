import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_package/Services/LogSystem/LogSystem.dart';
import 'package:shared_package/Services/LogSystem/LogSystemBDD.dart';

class ImageCameraController extends CameraController{

  late ImageCameraController _cameraController;
  Uint8List? _imageBytes;
  bool isInitialized = false;
  var cameraContParam = {}.obs;


  ImageCameraController(super.description, super.resolutionPreset);

  ImageCameraController.init({
      required CameraDescription description,
      required ResolutionPreset resolutionPreset,
        bool enableAudio = false, required ImageFormatGroup imageFormatGroup
      }) : super(description, resolutionPreset, enableAudio: enableAudio);


  List<CameraDescription> _cameras = [];




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
        isInitialized = true;
        debugPrint('Camera intialized successfully');
      } catch (e) {
        isInitialized = false;
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

  void takePhoto() async {

    if (_cameraController.value.isInitialized) {
      try {
        Uint8List? imageBytes;
        final XFile photo = await _cameraController.takePicture();
        imageBytes = await photo.readAsBytes();

          _imageBytes = imageBytes;
          //_image = File(photo.path);

            } catch (e) {
        if (kDebugMode) {
          debugPrint(
              "FPhotoUploadField L86 _takePhoto(): Error when photo was taken :$e");
          if (isSkiaWeb) {
            LogSystemBDD().log(
                "FPhotoUploadField L86 _takePhoto(): Error when photo was taken :$e");
          } else {
            LogSystem().error(
                "FPhotoUploadField L86 _takePhoto(): Error when photo was taken :$e");
          }
        }
      } finally {
        _cameraController.dispose();
      }
    } else {
      if (kDebugMode) {
        debugPrint(
            "FPhotoUploadField L114 _takePhoto():Camera controller not initialized");
        if (isSkiaWeb) {
          LogSystemBDD().log(
              "FPhotoUploadField L116 _takePhoto():Camera controller not initialized");
        } else {
          LogSystem().error(
              "FPhotoUploadField L118 _takePhoto(): Camera controller not initialized");
        }
      }
    }
  }

 @override
  Future <void> dispose() async {
    _cameraController.dispose();
    super.dispose();
  }
  void setCameraContParam(Map<String, dynamic> params) {
    cameraContParam.value = params;
  }

}