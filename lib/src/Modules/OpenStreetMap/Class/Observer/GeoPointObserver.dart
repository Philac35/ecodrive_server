import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';


class GeoPointObserver {


  static List<GeoPoint> pointlist=List.filled(2, GeoPoint(latitude: 0, longitude: 0));
  // Initialize with a fixed-size List containing default GeoPoints
  final ValueNotifier<List<GeoPoint>> searchedGeopoints = ValueNotifier<List<GeoPoint>>(
   pointlist
  );



  void updateGeoPoint(int index, GeoPoint geoPoint) {
    if (index < 0 || index >= searchedGeopoints.value.length) {
     throw  IndexError. withLength(index,2,indexable:searchedGeopoints);

    }

    // Update the specific GeoPoint in the list
    final updatedList = List<GeoPoint>.from(searchedGeopoints.value);
    updatedList[index] = geoPoint;

    // Notify listeners of the change
    searchedGeopoints.value = updatedList;
  }

  GeoPoint getGeoPoint(int index) {
    if (index < 0 || index >= searchedGeopoints.value.length) {
      throw  IndexError. withLength(index,2,indexable:searchedGeopoints);

    }
    return searchedGeopoints.value[index];
  }
}
