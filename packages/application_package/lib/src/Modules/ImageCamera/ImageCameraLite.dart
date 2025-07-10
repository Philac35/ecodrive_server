import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_lite_camera/flutter_lite_camera.dart';
import 'dart:ui' as ui;


// Cross-Platform : W,L,M
// RGB888 Frame format: uncompressed frame

// API
// getDeviceList() explicit
// open(int index) open the camera at the specified index
// captureFrame() Captures a single fram as an RGB888 image
// release()  Releases the camera resources

//TODO Review PB of getDeviceList()
// Clues: fork my own Flutter_Camera_lite plugin, override getDeviceList cf. Library/FlutterLiteCameraReview
// flutter create --template=plugin my_camera_plugin
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageCameraLite(),
    );
  }
}

class ImageCameraLite extends StatefulWidget  {
  const ImageCameraLite({super.key});

  @override
  State<ImageCameraLite> createState() => _ImageCameraLiteState();
}

class _ImageCameraLiteState extends State<ImageCameraLite> {
  final FlutterLiteCamera _flutterLiteCameraPlugin = FlutterLiteCamera();
  bool _isCameraOpened = false;
  bool _isCapturing = false;
  //int _width = 640;
  //int _height = 480;
  final int _width = 106;
  final int _height = 80;
  ui.Image? _latestFrame;
  bool _shouldCapture = false;

  // In initState()
  @override
  void initState() {
    super.initState();
    _handleWindowClose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCamera();
    });
  }


  Future<void> _startCamera() async {
    try {
      List<String> devices = await _flutterLiteCameraPlugin.getDeviceList();
      if (devices.isNotEmpty) {
        print("Available Devices: $devices");
        print("Opening camera 0");
        bool opened = await _flutterLiteCameraPlugin.open(0);
        if (opened) {
          setState(() {
            _isCameraOpened = true;
            _shouldCapture = true;
          });

          // Start capturing frames or proceed with capturing a photo
        } else {
          print("Failed to open the camera.");
        }
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  //To capture video frames
  Future<void> _captureFrames() async {
    if (!_isCameraOpened || !_shouldCapture) return;

    try {
      Map<String, dynamic> frame =
      await _flutterLiteCameraPlugin.captureFrame();
      if (frame.containsKey('data')) {
        Uint8List rgbBuffer = frame['data'];
        await _convertBufferToImage(rgbBuffer, frame['width'], frame['height']);
      }
    } catch (e) {
       debugPrint("Error capturing frame: $e");
    }

    // Schedule the next frame
    if (_shouldCapture) {
      Future.delayed(const Duration(milliseconds: 30), _captureFrames);
    }
  }



  Future<void> _capturePhoto() async {
    if (!_isCameraOpened) {
      print('Camera is not opened');
      return;
    }

    try {
      final frame = await _captureSingleFrame();
      if (frame.containsKey('data')) {
        Uint8List rgbBuffer = frame['data'];
        await _convertBufferToImage(rgbBuffer, frame['width'], frame['height']);
      }
    } catch (e) {
      print("Error capturing photo: $e");
    }
  }


  /*
   * Function _captureSingleFrame()
   * used by _capturePhoto()
   */
  Future<Map<String, dynamic>> _captureSingleFrame() async {
    if (!_isCameraOpened) {
      throw Exception('Camera is not opened');
    }

    try {
      return await _flutterLiteCameraPlugin.captureFrame();
    } catch (e) {
      print("Error capturing single frame: $e");
      rethrow;
    }
  }




  Future<void> _saveImage(ui.Image image) async {
    // Convert the image to a byte buffer
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final buffer = byteData.buffer.asUint8List();
      // Save the buffer to a file or process it further
    }
  }

  Future<void> _convertBufferToImage(
      Uint8List rgbBuffer, int width, int height) async {
    final pixels = Uint8List(width * height * 4); // RGBA buffer

    for (int i = 0; i < width * height; i++) {
      int r = rgbBuffer[i * 3];
      int g = rgbBuffer[i * 3 + 1];
      int b = rgbBuffer[i * 3 + 2];

      // Populate RGBA buffer
      pixels[i * 4] = b;
      pixels[i * 4 + 1] = g;
      pixels[i * 4 + 2] = r;
      pixels[i * 4 + 3] = 255; // Alpha channel
    }

    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );

    final image = await completer.future;
    setState(() {
      _latestFrame = image;
    });
  }

  Future<void> _stopCamera() async {
    setState(() {
      _shouldCapture = false;
    });

    if (_isCameraOpened) {
      await _flutterLiteCameraPlugin.release();
      setState(() {
        _isCameraOpened = false;
        _latestFrame = null;
      });
    }

    _isCapturing = false;
  }

  void _handleWindowClose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChannels.lifecycle.setMessageHandler((message) async {
        if (message == AppLifecycleState.detached.toString()) {
          await _stopCamera();
        }
        return null;
      });
    });
  }

  @override
  void dispose() {
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_latestFrame != null)
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final screenHeight = constraints.maxHeight;
                final imageAspectRatio = _width / _height;
                final screenAspectRatio = screenWidth / screenHeight;

                double drawWidth, drawHeight;
                if (imageAspectRatio > screenAspectRatio) {
                  drawWidth = screenWidth;
                  drawHeight = screenWidth / imageAspectRatio;
                } else {
                  drawHeight = screenHeight;
                  drawWidth = screenHeight * imageAspectRatio;
                }

                return Center(
                  child: CustomPaint(
                    painter: FramePainter(_latestFrame!),
                    child: SizedBox(
                      width: drawWidth,
                      height: drawHeight,
                    ),
                  ),
                );
              },
            )
          else
            Center(
              child: Text('Camera not initialized or no frame captured'),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Start Button
                ElevatedButton(
                  onPressed: _isCapturing ? null : () => _startCamera(),
                  child: const Text('Start'),
                ),
                // Take Photo
                ElevatedButton(
                  onPressed: _isCameraOpened ? () => _capturePhoto() : null,
                  child: const Icon(Icons.camera_alt),
                ),
                // Stop Button
                ElevatedButton(
                  onPressed: !_isCapturing ? null : () => _stopCamera(),
                  child: const Text('Stop'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FramePainter extends CustomPainter {
  final ui.Image image;

  FramePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}