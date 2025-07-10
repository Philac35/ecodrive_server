import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../Component/StreetMarker/StreetMarker.dart';

class Cluster {
  final List<StreetMarker> streetMarkers;

  Cluster(this.streetMarkers);

  /// Calculate the centroid (average latitude and longitude) of the cluster.
  GeoPoint get centroid {
    double avgLat = streetMarkers.map((m) => m.geoPoint.latitude).reduce((a, b) => a + b) / streetMarkers.length;
    double avgLon = streetMarkers.map((m) => m.geoPoint.longitude).reduce((a, b) => a + b) / streetMarkers.length;
    return GeoPoint(latitude: avgLat, longitude: avgLon);
  }

  /// Get the size of the cluster (number of markers grouped).
  int get size => streetMarkers.length;
}
