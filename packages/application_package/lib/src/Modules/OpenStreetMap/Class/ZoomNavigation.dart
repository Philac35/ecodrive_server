/*
* ZoomNavigation
* This class provide and animate the 2 zoom buttons of the map
*/
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../Components/Elements/CustomButton.dart';
import 'package:application_package/src/Modules/OpenStreetMap/Controller/MapControllerInterface.dart' ;



class ZoomNavigation extends StatelessWidget {
  ZoomNavigation({
    super.key,
    required this.controller,
    required this.isMapReady,
  });

  final MapControllerInterface controller;
   bool isMapReady=false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      MouseRegion(
          cursor: isMapReady ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
          opaque:true,
          child: CustomButton(
           style: ElevatedButton.styleFrom(
              maximumSize: const Size(48, 48),
              minimumSize: const Size(24, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
              padding: EdgeInsets.zero,
            ),
            onPressed: isMapReady ? () =>
            debugPrint('Button ZoomIn Pressed'): (){_handleZoomIn();
             // debugPrint('Map is not ready neither Button!');  //TODO: Revoir isMapReady. Informations are not transmitted as preview.
                  },
            child: const Center(
              child: Icon(Icons.add),
            ),
          )),
      const SizedBox(
        height: 16,
      ),
      MouseRegion(
        cursor: isMapReady ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        opaque:true,
        child: CustomButton(
          style: ElevatedButton.styleFrom(
            maximumSize: const Size(48, 48),
            minimumSize: const Size(24, 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
            padding: EdgeInsets.zero,
          ),
          onPressed: isMapReady
              ?(){}
              : () async {
            _handleZoomOut();
          },
          child: const Center(
            child: Icon(Icons.remove),
          ),

        ),
      ),
    ]));
  }

  void _handleZoomIn()async {
    //if (isMapReady) {
      debugPrint('ZoomNavigation L84, Get controller Runtime Type${controller.runtimeType}');
      (  controller as MapController).zoomIn().then((_) {
        print("Zoom in successful");
      }).catchError((e) {
        print("Error zooming in: $e");
      })  as VoidCallback ;
  //  }
  }

  void _handleZoomOut()async {
    //if (isMapReady) {
    debugPrint('ZoomNavigation L95, Get controller Runtime Type${controller.runtimeType}');
    (  controller as MapController).zoomOut().then((_) {
      print("Zoom in successful");
    }).catchError((e) {
      print("Error zooming out: $e");
    })  as VoidCallback ;
    //  }
  }

}
