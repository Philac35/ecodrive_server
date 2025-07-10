


import 'package:shared_package/Modules/OpenStreetMap/OpenStreetMapTraffic.dart';
import 'package:shared_package/Modules/Traffic/Component/MapWithTraffic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' ;

import 'StreetMarker.dart';
import 'package:shared_package/Modules/OpenStreetMap/Controller/MapControllerInterface.dart' ;

import 'package:shared_package/Modules/OpenStreetMap/Controller/FBaseMapController.dart';

class StreetMarkerRender{
  late StreetMarker streetMarker;
  final MapControllerInterface mapController;

  StreetMarkerRender({required this.mapController});
  StreetMarkerRender.init({required this.mapController,required this.streetMarker});

  /*
   * Function renderIndividualMarkers
   * Clear all StreetMarkers and render just one.
   */
  void renderIndividualMarkers( List<StreetMarker> markers) {
    // Clear existing markers

    for (var streetMarker in markers) {
      print("Marker position: lat:${streetMarker.geoPoint.latitude} ; longitude:${streetMarker.geoPoint.longitude} ");


      mapController.isMapReady as bool?((_) async {
     await   addStreetMarker(streetMarker);
     LatLngBounds bounds = (await mapController.bounds) as LatLngBounds;
     print("Map bounds: $bounds");
      }): debugPrint("StreetMarkerRender, renderIndividualMarker, addStreetMarker impossible!");
    //  addStreetMarker(streetMarker); // Add each individual marker to the map

    }

  }


  Future<void> addStreetMarker(StreetMarker streetMarker) async {
    if (streetMarker!.geoPoint != null) {


      await mapController.addMarker(
          streetMarker.geoPoint!, // Use the non-null assertion operator (!)
          markerIcon: streetMarker.markerIcone);

    } else {
      // Handle the case where geoPoint is null
      print(
          "Warning: Cannot add marker for event with missing location: ${streetMarker.event.description}");
      // We might choose to:
      // - Skip adding the marker (as we're doing here)
      // - Add a marker at a default location
      // - Display the event information in a different way (e.g., a list)
    }
  }



}