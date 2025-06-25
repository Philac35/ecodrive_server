import 'dart:math';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import './PathSearch/ContractionHierachy/Class/Node.dart';

class GeoDistance{


/*
 * Function calculateDistance from GeoPoint's List
 * @return distance in km
 */
  Future<double> calculateDistancePoint(List<GeoPoint> points) async {
    double totalDistance = 0;
    for (int i = 0; i < points.length - 1; i++) {
      double arc = await distance2point(points[i], points[i + 1]);
      totalDistance += arc;
    }
    return totalDistance / 1000;
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  /*
   * Function calculateHaversinDistance
   * @return direct distance between 2 points of the surface of sphere
   */
  double calculateHaversineDistance(lat1, lon1, lat2, lon2) {
    const double earthRadius = 6371; // in kilometers
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // Distance in kilometers
  }


  double calculateHaversineDistanceNode(Node a, Node b){
    return  calculateHaversineDistance( a.latitude, a.longitude, b.latitude, b.longitude);
  }

}