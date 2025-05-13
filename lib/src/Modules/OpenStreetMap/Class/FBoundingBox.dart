


import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
class FBoundingBox{

double maxLat=0.0;  //north
double maxLon=0.0;  //east
double minLat=0.0;  //south
double minLon=0.0;  //west

/*
 * hadBufferedBox
 * Create a larger box to get a larger frame than the 2 points
 */
BoundingBox hadBufferedBox( {required BoundingBox bbox,double buffer = 0.01} ) {
 // adjust as needed
  BoundingBox buffered = BoundingBox(
    north: bbox.north + buffer,
    east:  bbox.east + buffer,
    south:bbox.south - buffer,
    west: bbox.west - buffer,
  );
  return buffered;
}

/*
* Function calculateBounds
* @return List<Geopoints>  southWest, northEast
*/
  BoundingBox calculateBounds(GeoPoint? departure, GeoPoint? arrival) {
    departure = departure;
    arrival = arrival ;
     minLat = departure!.latitude < arrival!.latitude
        ? departure.latitude
        : arrival.latitude;
       maxLat = departure!.latitude > arrival!.latitude
        ? departure.latitude
        : arrival.latitude;
       minLon = departure!.longitude < arrival!.longitude
        ? departure.longitude
        : arrival.longitude;
        maxLon = departure!.longitude > arrival!.longitude
        ? departure!.longitude
        : arrival!.longitude;

    return BoundingBox(
        north: maxLat,
        east: maxLon, //northEast
        south: minLat,
        west: minLon //southWest
    );
  }
}