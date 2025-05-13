import 'package:ecodrive_server/src/Modules/Traffic/Component/StreetMarker/StreetMarker.dart';
import 'package:ecodrive_server/src/Modules/Traffic/Class/QuadTree/BoundingBox.dart' as bd;
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../Component/StreetMarker/StreetMarker.dart';

class QuadTree {
  final bd.BoundingBox boundary;
  final int capacity;
  List<StreetMarker> markers = [];
  List<QuadTree?> children = [null, null, null, null];

  QuadTree(this.boundary, this.capacity);

  bool insert(StreetMarker marker) {
    if (!boundary.contains(marker.geoPoint)) return false;

    if (markers.length < capacity) {
      markers.add(marker);
      return true;
    }

    if (children[0] == null) subdivide();

    for (var child in children) {
      if (child!.insert(marker)) return true;
    }

    return false;
  }

  void subdivide() {
    double midLat = (boundary.minLat + boundary.maxLat) / 2;
    double midLon = (boundary.minLon + boundary.maxLon) / 2;

    children[0] = QuadTree(bd.BoundingBox(boundary.minLat, midLat, boundary.minLon, midLon), capacity);
    children[1] = QuadTree(bd.BoundingBox(boundary.minLat, midLat, midLon, boundary.maxLon), capacity);
    children[2] = QuadTree(bd.BoundingBox(midLat, boundary.maxLat, boundary.minLon, midLon), capacity);
    children[3] = QuadTree(bd.BoundingBox(midLat, boundary.maxLat, midLon, boundary.maxLon), capacity);
  }

  List<StreetMarker> query(bd.BoundingBox range) {
    if (!boundary.intersects(range)) return [];

    List<StreetMarker> found = [];
    for (var marker in markers) {
      if (range.contains(marker.geoPoint)) found.add(marker);
    }

    if (children[0] != null) {
      for (var child in children) {
        found.addAll(child!.query(range));
      }
    }

    return found;
  }
}
