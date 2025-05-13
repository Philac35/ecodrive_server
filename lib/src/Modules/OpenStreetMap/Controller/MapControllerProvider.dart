import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'FMapController.dart';
import 'MapControllerInterface.dart';




 /*
 * Class MapControllerProvider
 */
class MapControllerProvider extends StatefulWidget {
  final Widget child; 

  final MapControllerInterface? controller;
  final bool? isInitialized;
  final String? errorMessage;
  final MapControllerProviderState _state;

   MapControllerProvider({ super. key, this.controller,

    this.errorMessage, required this.child,}) :_state=  MapControllerProviderState(),isInitialized=false;

  MapControllerProviderState? get state=> _state;

  static MapControllerProviderState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedMapController>()?.data;
  }

  @override
  MapControllerProviderState createState() {
    return _state; 
  }

}





/*
* Class MapControllerProviderState
*/
class MapControllerProviderState extends State<MapControllerProvider> {

  MapControllerInterface<dynamic>? _controller;
  static GeoPoint initialPoint = GeoPoint(latitude: 48.8566, longitude: 2.3522);
  late ValueNotifier<bool> disableMapControlUserTracking;
  bool _isInitialized = false;
  String? _errorMessage;
  int retryCount =0;

  MapControllerInterface<dynamic>? get controller => _controller;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;

  @override
  void initState() {
    super.initState();
    disableMapControlUserTracking = ValueNotifier(false);
    _initializeController();
  }


  Future<MapControllerInterface<dynamic>?> createMapController()async{
    try {
      _controller = await FMapController(
        initPosition: initialPoint,
        useExternalTracking: disableMapControlUserTracking.value,
      );

      if (_controller != null) {
        debugPrint("MapContollerProvider ${_controller} was  instanciated !");
        return _controller;
      } else {
        debugPrint(
            "MapContollerProvider  ${_controller} was not instanciated !");
        return null;
      };
    } catch(error,stack){
            debugPrint("MapControllerProvider error: $error\n$stack");
             return null;
    }

  }


  Future<void> _initializeController() async {
    final controller = await createMapController();
    if (controller != null) {
      setState(() {
        _controller = controller;
        _isInitialized = true;
        _errorMessage = null;
      });
    } else {
      setState(() {
        _isInitialized = false;
        _errorMessage = "Failed to initialize MapController";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedMapController(
      data: this,
      child: widget.child,
    );
  }


}

class _InheritedMapController extends InheritedWidget {
  final MapControllerProviderState data;

  const _InheritedMapController({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedMapController oldWidget) {
    return oldWidget.data.controller != data.controller ||
        oldWidget.data.isInitialized != data.isInitialized ||
        oldWidget.data.errorMessage != data.errorMessage;
  }
}


/*
class MapControllerProvider extends InheritedWidget {
   FMapController? controller;
  static GeoPoint initialPoint = GeoPoint(latitude: 48.8566, longitude: 2.3522);
  ValueNotifier<bool>? disableMapControlUserTracking ;


  MapControllerProvider({super.key,
        this.controller,
        required Widget child,
        this. disableMapControlUserTracking
  }) : super(child: child) {
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      controller = await FMapController(
        initPosition: initialPoint,
        useExternalTracking: disableMapControlUserTracking!.value,
      );
    } catch (e) {
      // Handle initialization error
      print('Error initializing FMapController: $e');
    }
  }

  static FMapController? of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<MapControllerProvider>();
    return provider?.controller;
  }

  @override
  bool updateShouldNotify(MapControllerProvider oldWidget) {
    return oldWidget.controller != controller;
  }
}
*/