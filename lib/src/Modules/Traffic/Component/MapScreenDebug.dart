import 'package:ecodrive_server/src/Modules/Traffic/Entities/TrafficEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';


/*
 * Class used to debug pointerInterceptor
 * Here the marker is set on the map and when you click on it the Geopoint is printed
 */
class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController.withPosition(
      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OSMFlutter with PointerInterceptor')),
      body: PointerInterceptor(
        child: OSMFlutter(
          controller: mapController,
          osmOption: OSMOption(
            userLocationMarker: UserLocationMaker(
              personMarker: MarkerIcon(
                icon: Icon(
                  Icons.location_history,
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
            roadConfiguration: RoadOption(
              roadColor: Colors.yellowAccent,
            ),
          ),
          onMapIsReady: (isReady) {
            if (isReady) {
              debugPrint('Map is ready');
              addMarkers();
            }
          },
          onGeoPointClicked: (geoPoint) {
            showMarkerDescription(context);
            debugPrint('GeoPoint clicked: $geoPoint');
          },
        ),
      ),
    );
  }

  void addMarkers() {
    mapController.addMarker(
      GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
      markerIcon: MarkerIcon(
        iconWidget: IgnorePointer(
          ignoring: false,
          child: PointerInterceptor(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                debugPrint('Marker tapped');
              //  showMarkerDescription(context); here it doesn't work, use onGeoPointClick(Geopoint) in OSMFlutter body instead
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
              child: Icon(
                Icons.location_on,
                color: Colors.orange,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void main() {
    runApp(MaterialApp(home: MapScreen()));
  }



  void showMarkerDescription(context) {
    TrafficEvent event = TrafficEvent(
        id:'1',
        type: "Roadwork",
        description: "Roadwork near Main Street",
        latitude: 48.8575, // Example latitude for the event
        longitude: 2.3233, // Example longitude for the event
        latitudeFrom: 48.8566, // Starting latitude
        longitudeFrom: 2.3522, // Starting longitude
        latitudeTo: 48.8584, // Ending latitude
        longitudeTo: 2.2945, // Ending longitude
        startDate: DateTime.parse("2025-04-02T08:00"), // Start date as DateTime
        endDate: DateTime.parse("2025-04-02T18:00"), // End date as DateTime
        situationVersionTime: DateTime.parse("2025-04-02T09:57"), // Version time as DateTime
        overallSeverity: "High", // Severity level
        situationRecordCreationTime: DateTime.parse("2025-04-02T07:00"), // Creation time as DateTime
        situationRecordObservationTime: DateTime.parse("2025-04-02T07:30"), // Observation time as DateTime
        situationRecordVersionTime: DateTime.parse("2025-04-02T08:30"), // Version time as DateTime
        probabilityOfOccurrence: "Likely", // Probability of occurrence
        sourceIdentification: "Traffic Sensor A1", // Source identifier
        sourceName: "City Traffic Monitoring", // Source name
        reliable: 'true', // Reliability flag (true or false)
        tpegDirection: "Northbound", // TPEG direction (e.g., Northbound)
        tpegLinearLocationType: "Segment", // Linear location type (e.g., Segment)
        toName: "Central Park Avenue", // Destination name
        fromName: "Main Street", // Origin name
        operatingMode: "Normal", // Operating mode (e.g., Normal)
        subscriptionStartTime: DateTime.parse("2025-04-01T12:00"), // Subscription start time as DateTime
        subscriptionState: "Active", // Subscription state (e.g., Active)
        subscriptionStopTime: DateTime.parse("2025-04-03T12:00"), // Subscription stop time as DateTime
        updateMethod: "Automatic" // Update method (e.g., Automatic)
    );


    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PointerInterceptor(
            child: AlertDialog(
              title: Text(event.type),
              content: Text(event.description),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
            ),
          );
        }
    );
  }


}

