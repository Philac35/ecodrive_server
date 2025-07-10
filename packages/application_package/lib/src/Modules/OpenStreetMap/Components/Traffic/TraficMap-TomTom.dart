import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/*
* TrafficMap with Tomtom
* https://developer.tomtom.com/pricing
*/
class TrafficMap extends StatefulWidget {
  const TrafficMap({super.key});

  @override
  State<TrafficMap> createState() => _TrafficMapState();
}

class _TrafficMapState extends State<TrafficMap> {
  MapController controller = MapController.withPosition(
      initPosition: GeoPoint(
          latitude: 37.4220, longitude: -122.0841)); // Example: Google HQ

  List<GeoPoint> trafficPoints = []; // Store traffic data points

  @override
  void initState() {
    super.initState();
    _fetchTrafficData(); // Load traffic data when the widget initializes
  }

  Future<void> _fetchTrafficData() async {
    // Replace with your chosen API endpoint and API key
    //This is a placeholder, replace it with a valid endpoint

    //This is an example of how to call TomTom's incidents api, replace values with the real values
    const String apiKey = "YOUR_TOMTOM_API_KEY";
    const double topLeftLat = 37.5;
    const double topLeftLon = -122.2;
    const double bottomRightLat = 37.3;
    const double bottomRightLon = -121.9;

    final String url =
        'https://api.tomtom.com/traffic/services/4/incidentDetails?key=$apiKey&boundingBox=$topLeftLat,$topLeftLon,$bottomRightLat,$bottomRightLon&fields=description,location,magnitude';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        // Process the traffic data based on API response format
        // Example (adjust based on your API's response):

        List<GeoPoint> newTrafficPoints = [];
        // adapt this to your API
        for (var incident in decodedData['incidents']) {
          double lat = incident['location']['latitude'];
          double lon = incident['location']['longitude'];
          newTrafficPoints.add(GeoPoint(latitude: lat, longitude: lon));
        }

        setState(() {
          trafficPoints = newTrafficPoints;
        });
      } else {
        print('Failed to load traffic data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching traffic data: $e');
    }
  }

  addStaticPoint(List<GeoPoint> geopoints) async {
    await controller.setStaticPosition(geopoints, "static_points_id");
  }

  changeMarkerStaticPoints() async {
    await controller.setMarkerOfStaticPoint(
        id: "",
        markerIcon:
            MarkerIcon(icon: Icon(Icons.location_on, color: Colors.orange)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Traffic Map')),
      body: OSMFlutter(
        controller: controller,
        osmOption: OSMOption(
          zoomOption: const ZoomOption(
            initZoom: 12,
            minZoomLevel: 3,
            maxZoomLevel: 19,
            stepZoom: 1.0,
          ),
          userLocationMarker: UserLocationMaker(
            personMarker: const MarkerIcon(
              icon: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 48,
              ),
            ),
            directionArrowMarker: const MarkerIcon(
              icon: Icon(
                Icons.double_arrow,
                size: 48,
              ),
            ),
          ),
          roadConfiguration: const RoadOption(
            roadColor: Colors.yellowAccent,
          ),
        ),
        onMapIsReady: (bool isReady) {
          if (isReady) {
            print("Map is ready");
          }
        },
      ),
    );
  }
}
