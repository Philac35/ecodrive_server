/*
* ZoomNavigation
* This class provide and animate the 2 zoom buttons of the map
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter/rendering.dart';
import "package:hovering/hovering.dart";
import '../Components/Elements/CustomButton.dart';
import '../Components/Elements/CustomElevatedButton.dart';
import 'package:shared_package/Modules/OpenStreetMap/Controller/MapControllerInterface.dart' ;

import 'package:shared_package/Modules/OpenStreetMap/Controller/FBaseMapController.dart';


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
            child: const Center(
              child: Icon(Icons.add),
            ),
            onPressed: isMapReady ? () =>
            debugPrint('Button ZoomIn Pressed'): (){this._handleZoomIn();
             // debugPrint('Map is not ready neither Button!');  //TODO: Revoir isMapReady. Informations are not transmitted as preview.
                  },
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
          child: const Center(
            child: Icon(Icons.remove),
          ),
          onPressed: isMapReady
              ?(){}
              : () async {
            _handleZoomOut();
          },

        ),
      ),
    ]));
  }

  void _handleZoomIn()async {
    //if (isMapReady) {
      debugPrint('ZoomNavigation L84, Get controller Runtime Type'+controller.runtimeType.toString());
      (  await controller as MapController)!.zoomIn().then((_) {
        print("Zoom in successful");
      }).catchError((e) {
        print("Error zooming in: $e");
      })  as VoidCallback ;
  //  }
  }

  void _handleZoomOut()async {
    //if (isMapReady) {
    debugPrint('ZoomNavigation L95, Get controller Runtime Type'+controller.runtimeType.toString());
    (  await controller as MapController)!.zoomOut().then((_) {
      print("Zoom in successful");
    }).catchError((e) {
      print("Error zooming out: $e");
    })  as VoidCallback ;
    //  }
  }

}
