import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';


/*
* Interface MapControllerInterface
* Create to manage FMapController and Flutter_osm_plugin MapController
*/

abstract interface class  MapControllerInterface<T>{


  late T controller;
  void dispose();

  Future<void> changeTileLayer({CustomTile? tileLayer});
  Future<void> limitAreaMap(BoundingBox boundingBox) ;
  Future<void> removeLimitAreaMap() ;

  Future<void> changeLocation(GeoPoint position) ;
  Future<void> goToLocation(GeoPoint position);
  Future<void> moveTo(GeoPoint position, {bool animate = false});
  Future<void> removeMarker(GeoPoint position);
  Future<void> removeMarkers(List<GeoPoint> geoPoints);
  Future setMarkerIcon(GeoPoint point, MarkerIcon icon);
  Future<void> setStaticPosition(List<GeoPoint> geoPoints, String id);
  Future<void> setMarkerOfStaticPoint({
    required String id,
    required MarkerIcon markerIcon,
  }) ;
  Future<double> getZoom() ;
  Future<void> setZoom({double? zoomLevel, double? stepZoom});
  Future<void> zoomIn();
  Future<void> zoomOut() ;
  Future<void> zoomToBoundingBox(
      BoundingBox box, {
        int paddinInPixel = 0,
      });


  Future<void> currentLocation() ;
  Future<GeoPoint> myLocation();
  Future<void> enableTracking({
    bool enableStopFollow = false,
    bool disableUserMarkerRotation = false,
    Anchor anchor = Anchor.center,
    bool useDirectionMarker = false,
  }) ;
  Future<void> startLocationUpdating({
    bool enableStopFollow = false,
    bool disableUserMarkerRotation = false,
    Anchor anchor = Anchor.center,
    bool useDirectionMarker = false,
  });
  Future<void> stopLocationUpdating();
  Future<void> disabledTracking();
  Future<RoadInfo> drawRoad(
      GeoPoint start,
      GeoPoint end, {
        RoadType roadType = RoadType.car,
        List<GeoPoint>? intersectPoint,
        RoadOption? roadOption,
      }) ;

  Future<void> clearStaticPositions();
  Future<List<RoadInfo>> drawMultipleRoad(
      List<MultiRoadConfiguration> configs, {
        MultiRoadOption commonRoadOption = const MultiRoadOption.empty(),
      });
  Future<void> removeLastRoad();
  Future<void> clearAllRoads();
  Future<void> drawCircle(CircleOSM circleOSM);
  Future<void> removeCircle(String keyCircle) ;
  Future<void> drawRect(RectOSM rectOSM) ;
  Future<void> removeRect(String keyRect);
  Future<void> removeAllRect() ;
  Future<void> removeAllCircle();
  Future<void> removeAllShapes();
  Future<void> rotateMapCamera(double degree) ;
  Future<String> drawRoadManually(
      List<GeoPoint> path,
      RoadOption roadOption,
      );
  Future<void> addMarker(
      GeoPoint p, {
        MarkerIcon? markerIcon,
        double? angle,
        IconAnchor? iconAnchor,
      });
  Future<void> changeLocationMarker({
    required GeoPoint oldLocation,
    required GeoPoint newLocation,
    MarkerIcon? markerIcon,
    double? angle,
    IconAnchor? iconAnchor,
  }) ;
  void setMapReady();
  bool isMapReady(Function(bool) callback);
  Future<BoundingBox> get bounds ;
  Future<GeoPoint> get centerMap;
  Future<List<GeoPoint>> get geopoints ;

  addObserver(OSMMixinObserver osmMixinObserver);
  removeObserver(OSMMixinObserver osmMixinObserver);
}