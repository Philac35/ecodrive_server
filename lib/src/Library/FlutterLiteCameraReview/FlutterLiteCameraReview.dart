import 'package:flutter_lite_camera/flutter_lite_camera.dart';


//TODO Continue to implement
class FlutterLiteCameraReview extends FlutterLiteCamera{

FlutterLiteCameraReview():super();


  @override
  Future<List<String>> getDeviceList() async {
  // Custom implementation to list devices
  // For example, you might manually list devices or handle errors differently
  try {
  // Your logic here
  List<String> devices = await super.getDeviceList();
  return devices;
  } catch (e) {
  print("Error getting device list: $e");
  return []; // Return an empty list or handle the error as needed
  }
  }
  }

/* Use the custom class in _ImageCameraLiteState
  class _ImageCameraLiteState extends State<ImageCameraLite> {
  final CustomFlutterLiteCamera _flutterLiteCameraPlugin = CustomFlutterLiteCamera();
  */


// In FlutterLiteCameraPlugin.swift
/*
func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
switch call.method {
case "getDeviceList":
let devices = AVCaptureDevice.devices(for: .video)
let deviceNames = devices.map { $0.localizedName }
result(deviceNames)
default:
result(FlutterMethodNotImplemented)
}
}
*/

// In CameraWindows.cpp
/*void FlutterLiteCameraPlugin::HandleMethodCall(
const flutter::MethodCall<flutter::EncodableValue> &method_call,
std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
if (method_call.method_name().compare("getDeviceList") == 0) {
std::vector<CaptureDeviceInfo> devices = ListCaptureDevices();
flutter::EncodableList deviceList;
for (size_t i = 0; i < devices.size(); i++) {
CaptureDeviceInfo &device = devices[i];
std::wstring wstr(device.friendlyName);
int size_needed = WideCharToMultiByte(CP_UTF8, 0, wstr.c_str(), (int)wstr.size(), NULL, 0, NULL, NULL);
std::string utf8Str(size_needed, 0);
WideCharToMultiByte(CP_UTF8, 0, wstr.c_str(), (int)wstr.size(), &utf8Str, size_needed, NULL, NULL);
deviceList.push_back(flutter::EncodableValue(utf8Str));
}
result->Success(flutter::EncodableValue(deviceList));
}
// ...
}
*/