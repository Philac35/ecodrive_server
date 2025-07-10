import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:shared_package/Modules/OpenStreetMap/Components/DBClasses/SearchInMapSimplify.dart';

class OpenSMTraffic extends StatefulWidget {
  @override
  OpenSMTrafficState createState() => OpenSMTrafficState();
}

class OpenSMTrafficState extends State<OpenSMTraffic> {
  late FocusNode searchDepartureFocusNode;
  late FocusNode searchArrivalFocusNode;
  late TextEditingController searchDepartureController;
  late TextEditingController searchArrivalController;
  late MapController mapController;

  final GlobalKey searchInMapKeyDeparture = GlobalKey();
  final GlobalKey searchInMapKeyArrival = GlobalKey();

  @override
  void initState() {

    debugPrint("OpenSMTStateDebug  L23, initState");
    super.initState();
    searchDepartureFocusNode = FocusNode();
    searchDepartureController = TextEditingController();
    searchArrivalFocusNode = FocusNode();
    searchArrivalController = TextEditingController();

    mapController = MapController(
      initPosition: GeoPoint(latitude: 48.8566, longitude: 2.3522),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkSearchInMapExists();
    });
  }

  void checkSearchInMapExists() {
    if (searchInMapKeyDeparture.currentContext != null) {
      print('SearchInMap (Departure) exists in the widget tree.');
    } else {
      print('SearchInMap (Departure) does not exist in the widget tree.');
    }

    if (searchInMapKeyArrival.currentContext != null) {
      print('SearchInMap (Arrival) exists in the widget tree.');
    } else {
      print('SearchInMap (Arrival) does not exist in the widget tree.');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("OpenSMTDebug I pass on l 58");
    debugPrint ("Kay departure : "+searchInMapKeyDeparture.toString() );
    final topPadding = MediaQuery.maybeOf(context)?.viewPadding.top ?? 26.0;

    return Scaffold(
      appBar: AppBar(title: Text('Traffic Events Map')),
      body: Stack(
        children: [
          OSMFlutter(
            controller: mapController,
            osmOption: OSMOption(
              showDefaultInfoWindow: false,
              showZoomController: true,
              enableRotationByGesture: false,
              zoomOption: ZoomOption(
                initZoom: 12,
                minZoomLevel: 2,
                maxZoomLevel: 19,
                stepZoom: 1,
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
          ),
          // Departure SearchInMap
          Container(
            key: searchInMapKeyDeparture,
            color: Colors.red, // Temporary background color for debugging
            child: SearchInMap(
              searchFocusNode: searchDepartureFocusNode,
              controller: mapController,
              hintText: 'Departure',
              isDeparture: true,
              onSearch: (String query) {
                setState(() {
                  searchDepartureController.value =
                      TextEditingValue(text: query);
                });
                searchArrivalFocusNode.requestFocus();
              },
            ),
          ),
          // Arrival SearchInMap
          Positioned(
            top: topPadding + 60,
            // Adjust the top position to place it below the departure search
            left: 16,
            right: 16,
            child: Container(
              key: searchInMapKeyArrival,
              color: Colors.blue, // Temporary background color for debugging
              child: SearchInMap(
                searchFocusNode: searchArrivalFocusNode,
                controller: mapController,
                hintText: 'Arrival',
                isDeparture: false,
                onSearch: (String query) async {
                  setState(() {
                    searchArrivalController.value =
                        TextEditingValue(text: query);
                  });
                  var a = await mapController.geopoints;
                  if (a.length >= 2) {
                    // DirectionRouteLocation(
                    //   controller: mapController,
                    // ).createRoute();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
