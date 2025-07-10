import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:osm_flutter_hooks/osm_flutter_hooks.dart';



class HookExample extends StatefulWidget {
  const HookExample({super.key});

  @override
  State<HookExample> createState() => _SimpleExampleState();
}

class _SimpleExampleState extends State<HookExample> {
  late PageController controller;
  late int indexPage;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 1);
    indexPage = controller.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("osm simple hook")),
      body: const SimpleOSM(),
    );
  }
}

class SimpleOSM extends HookWidget {
  const SimpleOSM({super.key});

  @override
  Widget build(BuildContext context) {
     final controller = MapController(
        initPosition: GeoPoint(
      latitude: 47.4358055,
      longitude: 8.4737324,
    ));
    /*  useMapIsReady(
      controller: controller,
      mapIsReady: () async {
        await controller.setZoom(zoomLevel: 15);
      },
    ); */

     return OSMFlutter(
      controller: MapController.withUserPosition(),
      osmOption: const OSMOption(),
    );
  }
}

/*
User Location:
It fetches the user's current location coordinates.
This is usually done using the plugin's location tracking capabilities.
Map Initialization:
It sets up the OpenStreetMap view centered on the user's location.
The map is typically initialized with a default zoom level.

Hooks Usage:
It utilizes flutter_hooks to manage state and side effects more efficiently.
Hooks can simplify state management and lifecycle methods in functional components.

Marker Placement:
It might place a marker on the map at the user's current location.

Map Controller:
It usually sets up a MapController to allow programmatic control of the map.

Reactive Updates:
The example likely demonstrates how to reactively update the map view or markers when the user's location changes.
Custom UI Elements:
It may include custom UI elements like buttons to interact with the map (e.g., zoom in/out, recenter on user location).
The main purpose of the hookExample is to showcase how to integrate flutter_osm_plugin with flutter_hooks for more efficient state management and reactive programming patterns in map-based applications.
*/
