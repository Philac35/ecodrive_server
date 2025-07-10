import 'dart:async';
import 'package:shared_package/Modules/Traffic/Component/Icones/VisualElement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import '../Entities/TrafficEvent.dart';
import '../Service/XMLTrafficParser.dart';

class MapWithTraffic extends StatefulWidget {
  final GeoPoint initialPoint = GeoPoint(latitude: 48.8566, longitude: 2.3522); // Paris Hôtel de Ville

  MapWithTraffic({Key? key}) : super(key: key);

  @override
  _MapWithTrafficState createState() => _MapWithTrafficState();
}

class _MapWithTrafficState extends State<MapWithTraffic> {
  late MapController mapController;
  List<TrafficEvent> trafficEvents = [];
  bool isLoading = true;
  bool isMapReady = false;
  Completer<void> mapReadyCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    mapController = MapController.withPosition(initPosition: widget.initialPoint);
    debugPrint("MapWithTraffic, mapController is initialized!");
    loadTrafficData();
  }

  Future<void> loadTrafficData() async {
    setState(() => isLoading = true);
    print("Loading traffic data...");

    XMLTrafficParser trafficInfo = XMLTrafficParser(isEncrypted: false);
    String request =
        "https://tipi.bison-fute.gouv.fr/bison-fute-ouvert/publicationsDIR/Evenementiel-DIR/grt/RRN/content.xml";

    await trafficInfo.fetchTrafficEvents(request);
    trafficEvents = await trafficInfo.parseResult() as List<TrafficEvent>;

    setState(() => isLoading = false);
    updateMarkers();
  }

  Future<void> updateMarkers() async {
    print("Traffic data loaded. Updating markers...");
    if (trafficEvents.isEmpty) {
      debugPrint('MapWithTraffic, trafficEvents is empty');
      return;
    }

    // Wait for the map to be ready
    await mapReadyCompleter.future;
    debugPrint("Map is ready. Proceeding with marker updates.");

    // Clear existing markers
    await mapController.clearStaticPositions();

    // Add markers for each event
    for (var event in trafficEvents) {
      debugPrint(event.type);
      debugPrint(event.description);

      if (event.startDate.isBefore(DateTime.now()) &&
          event.endDate.isAfter(DateTime.now())) {
        GeoPoint eventPoint = GeoPoint(latitude: event.latitude, longitude: event.longitude);
        MarkerIcon markerIcon = getMarkerForEventType(event, context);
        await mapController.addMarker(eventPoint, markerIcon: markerIcon);
      }
    }
    print("Markers updated.");
  }

  void checkType(TrafficEvent event) {
    if (event.description.contains(RegExp('[T-t]ravaux')) || event.description.contains(RegExp('[C-c]hantier'))) {
      event.type = 'Travaux';
    }
    if (event.description.contains(RegExp('[A-a]ccident'))) {
      event.type = 'Accident';
    }
  }

  MarkerIcon getMarkerForEventType(TrafficEvent event, BuildContext context) {
    VisualElement visualElement = VisualElement();
    checkType(event);  // Sometimes a detailed type is notified in description instead of event.type
    switch (event.type.toLowerCase()) {
      case 'accident':
        return visualElement.getRoadAccidentIcon();
      case 'travaux':
        return visualElement.getRoadConstructionIcon();
      case 'manifestation':
        return MarkerIcon(icon: Icon(Icons.event, color: Colors.blue, size: 48));
      case 'medium':
        return MarkerIcon(
          iconWidget: PointerInterceptor(
            child: GestureDetector(
              onTap: () {
                debugPrint('Marker tapped');
                showMarkerDescription(event);
              },
              onPanDown: (details) {
                debugPrint('Marker pan down: ${details.localPosition}');
              },
              onPanUpdate: (details) {
                debugPrint('Marker pan update: ${details.localPosition}');
              },
              onPanEnd: (details) {
                debugPrint('Marker pan end: ${details.velocity}');
              },
              child: Icon(Icons.location_on, color: Colors.blue, size: 48),
            ),
          ),
        );
      case 'high':
        return MarkerIcon(icon: Icon(Icons.location_on, color: Colors.red, size: 48));
      default:
        return MarkerIcon(
          iconWidget: PointerInterceptor(
            child: GestureDetector(
              onTap: () {
                debugPrint("i pass by here : default");
                showMarkerDescription(event);
              },
              child: Icon(Icons.location_on, color: Colors.green, size: 48),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Traffic Events Map')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : PointerInterceptor(
        child: OSMFlutter(
          controller: mapController,
          osmOption: OSMOption(
            zoomOption: ZoomOption(
              initZoom: 8,
              minZoomLevel: 3,
              maxZoomLevel: 19,
              stepZoom: 1.0,
            ),
            userLocationMarker: UserLocationMaker(
              personMarker: MarkerIcon(
                icon: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              directionArrowMarker: MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: 48,
                ),
              ),
            ),
            roadConfiguration: RoadOption(roadColor: Colors.yellowAccent),
          ),
          onMapIsReady: (isReady) async {
            if (isReady && !mapReadyCompleter.isCompleted) {
              print("Map is ready");
              isMapReady = true;
              mapReadyCompleter.complete();
              await mapController.setZoom(zoomLevel: 12); // Example zoom level
              debugPrint("MapWithTraffic, onMapIsReady, mapController is initialized!");
              mapController.clearStaticPositions();
              mapController.goToLocation(GeoPoint(latitude: 48.8566, longitude: 2.3522));
            }
          },
        ),
      ),
    );
  }

  void showMarkerDescription(TrafficEvent event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event.type),
          content: Text(event.description),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

extension MapControllerExtensions on MapController {

  /*
   * Function  addStaticPosition
   * @Param  List<GeoPoint> list,
   * @Param   String id,
   * @Param  {MarkerIcon? customMarker
   * @Return void
   */
  Future<void> addStaticPosition(List<GeoPoint> list, String id, {MarkerIcon? customMarker}) async {
    for (var position in list) {
      await this.addMarker(
        position,
        markerIcon: customMarker ??
            const MarkerIcon(
              icon: Icon(
                Icons.person_pin,
                color: Colors.red,
                size: 32,
              ),
            ),
      );
    }
  }

 /*
  * Function clearStaticPositions
  * @return Future <void>
  */
  Future<void> clearStaticPositions() async {
    List<GeoPoint> positions = await geopoints;
    for (var value in positions) {
      await removeMarker(value);
    }
  }

  /*
   * Function getLastGeoPoint
   * @return Future<GeoPoint?>
   */
  Future<GeoPoint?> getLastGeoPointTapped() async {
    Completer<GeoPoint?> completer = Completer<GeoPoint?>();

    listenerMapSingleTapping.addListener(() async {
      try {
        // Get the center of the map (approximation of tapped location)
        GeoPoint centerMap = await this.centerMap;
        if (!completer.isCompleted) {
          completer.complete(centerMap);
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      }
    });

    return completer.future;
  }
}
