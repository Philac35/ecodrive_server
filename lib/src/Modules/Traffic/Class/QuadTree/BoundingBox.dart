import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class BoundingBox {
  final double minLat, maxLat, minLon, maxLon;

  BoundingBox(this.minLat, this.maxLat, this.minLon, this.maxLon);

  bool contains(GeoPoint point) {
    return point.latitude >= minLat &&
        point.latitude <= maxLat &&
        point.longitude >= minLon &&
        point.longitude <= maxLon;
  }

  bool intersects(BoundingBox other) {
    return !(other.minLon > maxLon ||
        other.maxLon < minLon ||
        other.minLat > maxLat ||
        other.maxLat < minLat);
  }
}

class QuadTree {
  final BoundingBox boundary;
  final int capacity;
  List<GeoPoint> points = [];
  List<QuadTree?> children = [null, null, null, null];

  QuadTree(this.boundary, this.capacity);

  bool insert(GeoPoint point) {
    if (!boundary.contains(point)) return false;

    if (points.length < capacity) {
      points.add(point);
      return true;
    }

    if (children[0] == null) subdivide();

    for (var child in children) {
      if (child!.insert(point)) return true;
    }

    return false;
  }

  void subdivide() {
    double midLat = (boundary.minLat + boundary.maxLat) / 2;
    double midLon = (boundary.minLon + boundary.maxLon) / 2;

    children[0] = QuadTree(BoundingBox(boundary.minLat, midLat, boundary.minLon, midLon), capacity);
    children[1] = QuadTree(BoundingBox(boundary.minLat, midLat, midLon, boundary.maxLon), capacity);
    children[2] = QuadTree(BoundingBox(midLat, boundary.maxLat, boundary.minLon, midLon), capacity);
    children[3] = QuadTree(BoundingBox(midLat, boundary.maxLat, midLon, boundary.maxLon), capacity);
  }

  List<GeoPoint> query(BoundingBox range) {
    if (!boundary.intersects(range)) return [];

    List<GeoPoint> found = [];
    for (var point in points) {
      if (range.contains(point)) found.add(point);
    }

    if (children[0] != null) {
      for (var child in children) {
        found.addAll(child!.query(range));
      }
    }

    return found;
  }
}
