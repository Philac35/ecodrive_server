


import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';


import 'StreetMarker.dart';
import 'package:application_package/src/Modules/OpenStreetMap/Controller/MapControllerInterface.dart' ;


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
    await mapController.addMarker(
        streetMarker.geoPoint, // Use the non-null assertion operator (!)
        markerIcon: streetMarker.markerIcone);

    }



}