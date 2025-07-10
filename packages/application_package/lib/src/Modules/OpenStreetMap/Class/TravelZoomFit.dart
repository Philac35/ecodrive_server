import 'dart:math';

import 'package:shared_package/Modules/OpenStreetMap/Class/FBoundingBox.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class TravelZoomFit {
  MapController controller;
  GeoPoint departure;
  GeoPoint arrival;

  TravelZoomFit(
      {required this.controller,
        required this.departure,
        required this.arrival});



  Future<void> fitMapToBounds(GeoPoint? departure, GeoPoint? arrival) async {
    departure = departure ?? this.departure;
    arrival = arrival ?? this.arrival;
    final bounds = FBoundingBox().calculateBounds(departure, arrival);
    await controller.zoomToBoundingBox(bounds, paddinInPixel: 50);
  }

  /*
  * Function calculateZoomLevel
   */
  double calculateZoomLevel(GeoPoint departure, GeoPoint arrival) {
    departure = departure ?? this.departure;
    arrival = arrival ?? this.arrival;
    // Example calculation based on distance (you can refine this formula)
    final double distance = haversineDistance(
      departure.latitude,
      departure.longitude,
      arrival.latitude,
      arrival.longitude,
    );

    if (distance < 5) {
      return 15; // Close proximity
    } else if (distance < 20) {
      return 12; // Moderate distance
    } else {
      return 10; // Far apart
    }
  }

/*
 * Function haversineDistance
 * @return the distance between 2 points of the huge circle of a sphere
 */
  double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth's radius in km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distance in km
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  /*
  * Function adjustMap
  */
  Future<void> adjustMap({GeoPoint? departure, GeoPoint? arrival}) async {
    departure = departure ?? this.departure;
    arrival = arrival ?? this.arrival;

    final zoomLevel = calculateZoomLevel(departure, arrival);
    final centerLatitude = (departure.latitude + arrival.latitude) / 2;
    final centerLongitude = (departure.longitude + arrival.longitude) / 2;

    await controller.setZoom(zoomLevel: zoomLevel);
    await controller.goToLocation(
        GeoPoint(latitude: centerLatitude, longitude: centerLongitude));
  }
}


