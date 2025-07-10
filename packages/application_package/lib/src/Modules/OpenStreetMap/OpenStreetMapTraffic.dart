import 'package:application_package/src/Modules/OpenStreetMap/Controller/MapControllerProvider.dart';
import 'package:application_package/src/Modules/Traffic/Class/Cluster/ClusterRender.dart';
import 'package:application_package/src/Modules/Traffic/Component/StreetMarker/StreetMarker.dart';
import 'package:application_package/src/Modules/Traffic/Component/StreetMarker/StreetMarkerRender.dart';
import 'package:application_package/src/Modules/Traffic/Entities/TrafficEvent.dart';
import 'package:application_package/src/Modules/Traffic/Service/XMLTrafficParser.dart';
import 'package:shared_package/Services/EmbededBdd/HiveService.dart';
import 'package:application_package/src/Modules/OpenStreetMap/Components/SearchInMap.dart';
import 'package:application_package/src/Modules/OpenStreetMap/Controller/MapControllerInterface.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

//import 'package:flutter_osm_plugin/src/controller/map_controller.dart';

import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:universal_html/html.dart' as html;
import 'package:intl/intl.dart';

import 'package:universal_html/js.dart' as js;
//import '../Traffic/Component/MapWithTraffic.dart';
import '../Traffic/Component/StreetMarker/StreetMarkerFactory.dart';

//It is possible to load 2 library with the same alias without conflict!!!


import 'package:application_package/src/Modules/OpenStreetMap/Class/TravelZoomFit.dart';
import 'package:application_package/src/Modules/OpenStreetMap/Class/ZoomNavigation.dart';
import 'package:application_package/src/Modules/OpenStreetMap/Class/Debouncer.dart'  as deb;

import 'dart:async';
import 'dart:convert';

import 'Controller/FMapController.dart';




/*
@js.JS('addEventListener')
external void addEventListener(JSObject object, String event, Function callback);
*/

/*
 * Class OopenStreetMapTraffic
 * Rq: implementing the StateClass from an other Component
 * We must redefined if there is pb with keyword w. We can temporary implements it to get the major part of the functions and delete it.
 */
class OpenStreetMapTraffic extends StatefulWidget {
  //Datex File that list traffic's events, Informations come from French State Services
  //TODO Uses differents files from differents sources
  //TODO Check redondant informations
  String file =
      "https://tipi.bison-fute.gouv.fr/bison-fute-ouvert/publicationsDIR/Evenementiel-DIR/grt/RRN/content.xml";

  @override
  OpenStreetMapTrafficState createState() {
    return OpenStreetMapTrafficState();
  }

  @override
  // TODO: implement initialPoint
  final GeoPoint initialPoint = GeoPoint(latitude: 48.8566, longitude: 2.3522);

  OpenStreetMapTraffic({super.key}); // Paris Hôtel de Ville
}

class OpenStreetMapTrafficState extends State<OpenStreetMapTraffic>
    with OSMMixinObserver {
  OpenStreetMapTrafficState();

  @override
  late bool IsEmbededBddUsed;

  @override
  late ClusterRender clusterRender;

  @override
  late HiveService hiveStore = HiveService();

  @override
  late double initZoomLevel;

  @override
  late bool isLoading;

  @override
  late bool isMapReady;

  @override
   MapControllerInterface? mapController;

  @override
  late Completer<void> mapReadyCompleter;

  //To display the geopoints in this class:
  final Map<GeoPoint, TrafficEvent> _geoPointToEventMap = {};

  @override
  late double stepZoom;

  @override
  late List<StreetMarker> streetMarkerList;

  @override
  late StreetMarkerRender streetMarkerRender;

  @override
  Future<List<TrafficEvent>>? trafficEvents;

  late FocusNode searchArrivalFocusNode;
  late FocusNode searchDepartureFocusNode;
  late TextEditingController searchDepartureController;
  late TextEditingController searchArrivalController;

  final GlobalKey searchInMapKeyDeparture = GlobalKey();
  final GlobalKey searchInMapKeyArrival = GlobalKey();

// To check initialization
// To check initialization
  final departureMapReady = Completer<void>();
  final arrivalMapReady = Completer<void>();
  bool _isMapReady = false;

  ValueNotifier<bool> trackingNotifier = ValueNotifier(false);
  ValueNotifier<bool> showFab = ValueNotifier(false);
  ValueNotifier<bool> disableMapControlUserTracking = ValueNotifier(true);
  ValueNotifier<IconData> userLocationIcon = ValueNotifier(Icons.near_me);
  ValueNotifier<GeoPoint?> lastGeoPoint = ValueNotifier(null);
  List<GeoPoint> geos = [];
  ValueNotifier<GeoPoint?> userLocationNotifier = ValueNotifier(null);
  final mapKey = GlobalKey();

  final debouncer = deb.Debouncer(delay: Duration(milliseconds: 300));
  String? _errorMessage;


  @override
  initState() {
    print('OpenStreetMapTrafficState initialized');
    super.initState();
    print("initState called");
    streetMarkerList = [];
    searchDepartureFocusNode = FocusNode();
    searchDepartureController = TextEditingController();
    searchArrivalController = TextEditingController();
    searchArrivalFocusNode = FocusNode();

    initZoomLevel = 15;
    stepZoom = 1;

    customTile:
    CustomTile(
      sourceName: "openstreetmap",
      tileExtension: ".png",
      urlsServers: [
        TileURLs(url: "https://a.tile.openstreetmap.org/"),
        TileURLs(url: "https://b.tile.openstreetmap.org/"),
        TileURLs(url: "https://c.tile.openstreetmap.org/"),
      ],
    );

    // Add observer
   // mapController.addObserver(this as OSMMixinObserver);
    mapReadyCompleter = Completer();

    print("Controller initialized and observer added");

    // Wait for both maps to be ready
    Future.wait([departureMapReady.future, arrivalMapReady.future]).then((_) {
      setState(() {
        print("Both maps are ready!");
        // Perform any actions needed after both maps are ready
      });
    });

    // Ensure showFab is set to true
    showFab.value = true;

    trafficEvents = Future.value([]);
    IsEmbededBddUsed = false;
    loadTrafficData();

    //initialize Listener
    /*
    MapListener(
        mapController: mapController,
        streetMarkerRender: streetMarkerRender,
        clusterRender: clusterRender)
        .addListenerMapZoom();
    debugPrint("MapWithTraffic, mapController is initialized!");

     */


   // _initializeMapController();
  }



  Future<void> _initializeMapController() async {
    try {
      var mapController = MapControllerProvider.of(context)?.controller;
      if (mapController == null) {
         throw('OpenStreetMapTraffic L249 - mapController was not initialized');
      }
      if (!mounted) return; // Ensure the widget is still mounted before calling setState
      setState(() {
        mapController = mapController;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return; // Ensure the widget is still mounted before calling setState
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }


  }
  /*
   * Fuction didChangeDependencies
   * This function is call just after initState
   */
  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkSearchInMapExists();
    });

    mapController= MapControllerProvider.of(context)?.controller!;
    streetMarkerRender = StreetMarkerRender(mapController: mapController!);
    clusterRender = ClusterRender(controller: mapController!);
  }




  /*
   *  Function build
   * @Param : BuildContext context
   */
  @override
  Widget build(BuildContext context){



    mapController=MapControllerProvider.of(context)!.controller;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (mapController == null) {
      return Center(child: Text('Error: MapController not found'));
    }


    final topPadding = MediaQuery.maybeOf(context)?.viewPadding.top ?? 26.0;
    print('Building OpenStreetMapTraffic');
    debugPrint('SearchInMap exists and the component takes care of it');
  

    return Scaffold(
      appBar: AppBar(title: Text('Traffic Events Map')),
      body: Stack(children: [
            OSMFlutter(
              controller: mapController as MapController,
              onGeoPointClicked: (GeoPoint geoPoint) {
                // Prevent automatic centering by moving the map slightly
                // When a marker is clicked, calculate a new position slightly offset from the marker's location.
                final newLat = geoPoint.latitude;
                final newLng = geoPoint.longitude -
                    0.001; // Adjust longitude slightly to prevent leftward movement
               mapController!.changeLocation(
                    GeoPoint(latitude: newLat, longitude: newLng));
                //    showMarkerDescription();
                debugPrint('GeoPoint clicked: $geoPoint');

                //System to display description (cause it doesn't work StreetMarker)
                final trafficEvent = geoPointToEventMap[geoPoint];
                if (trafficEvent != null) {
                  showMarkerDescription(context, trafficEvent);
                  debugPrint('GeoPoint clicked: $geoPoint');
                  debugPrint('Associated Traffic Event: ${trafficEvent.type}');
                  debugPrint(
                      "Event Numbers in GeoPointMap : ${geoPointToEventMap.length}");
                } else {
                  debugPrint('No Traffic Event found for GeoPoint: $geoPoint');
                }
              },
              osmOption: OSMOption(
                showDefaultInfoWindow: false,
                showZoomController: true,
                enableRotationByGesture: false,
                zoomOption: ZoomOption(
                  initZoom: initZoomLevel,
                  minZoomLevel: 2, // value 2 < minzoom <3
                  maxZoomLevel: 19, // values:  18 or 19.
                  stepZoom: stepZoom,
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

                  () => {
                        html.window.onLoad.listen((event) {
                          // Initialize the map and call mapIsReady when the map is ready
                          initializeMap().then((_) {
                            setMapReady(); //inner setMapReady

                          });
                        })
                      };
                  // Wait for a short delay to ensure iframe initialization
                  int delay = 500;
                  debugPrint('MapWithTraffic l205 delay: $delay ms');
                  await Future.delayed(Duration(milliseconds: 500));

                  try {
                    // Call the getIframe function to perform the necessary checks
                    getIframeContent();
                  
                    // Mark map as ready
                    isMapReady = true;
                    mapReadyCompleter.complete();

                    // Set initial zoom level
                    await mapController!.setZoom(
                        zoomLevel: initZoomLevel, stepZoom: stepZoom);
                    print("Zoom level set to $initZoomLevel");

                    // Zoom to a specific region (bounding box)
                    zoomToRegion( mapController!);
                    print("Zoomed to region");

                    // Clear static positions if any
                    await mapController!.clearStaticPositions();
                    print("Static positions cleared");

                    // Move to a specific location
                    await mapController!.goToLocation(
                      GeoPoint(latitude: 48.8566, longitude: 2.3522),
                    );
                    print("Moved to location: Paris (48.8566, 2.3522)");
                  } catch (e) {
                    print("Error during map initialization: $e");
                  }

                  debugPrint(
                      "MapWithTraffic, onMapIsReady, mapController is initialized!");
                }
              },
            ),
            //  if (!kReleaseMode || kIsWeb) ...[
            Positioned(
              bottom: 23.0,
              left: 15,
              child: ZoomNavigation(
                controller:  mapController!,
                isMapReady: _isMapReady,
              ),
            )
            //]
            ,
            //DirectionRouteLocation is use to implement the search action
           /*
            Positioned(
              bottom: 92,
              right: 15,
              child: DirectionRouteLocation(
                controller: mapController!,
              ),
            ),
           */
            // Departure SearchInMap
            Positioned(
                top: kIsWeb ? 26 : topPadding ?? 26.0,
                left: 64,
                right: 72,
                child: Container(
                    key: Key('departureSearchInMap'),
                    child: SearchInMap(
                        searchFocusNode: searchDepartureFocusNode,
                        controller: mapController!,
                        hintText: 'Departure',
                        isDeparture: true,
                        onSearch: (String query) {
                          setState(() {
                            searchDepartureController.value =
                                TextEditingValue(text: query);
                          });

                          searchArrivalFocusNode.requestFocus();
                        }))),
            // Arrival SearchInMap
            Positioned(
                top: kIsWeb ? 26 + 50 : topPadding + 50,
                left: 64,
                right: 72,
                child: Container(
                    key: Key('arrivalSearchInMap'),
                    child: SearchInMap(
                        searchFocusNode: searchArrivalFocusNode,
                        controller: mapController!,
                        hintText: 'Arrival',
                        isDeparture: false,
                        onSearch: (String query) async {
                          setState(() {
                            searchArrivalController.value =
                                TextEditingValue(text: query);
                          });
                        }))),

            FutureBuilder<List<TrafficEvent>>(
              future: trafficEvents,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error fetching traffic data"));
                } else if (snapshot.hasData) {
                  // Add traffic info to the map
                  for (var event in snapshot.data!) {
                    String data = "hello";

                    //Debounce avoid to load a too much number of time infoTraffic. It induces a delay between reloads.
                    debouncer.run(() {
                      //Use compute asynchronously to not freeze the map
                      compute(addTraffic as ComputeCallback, data).then((_) {
                        compute(materializeSections, event);
                      });
                    });
                  }
                  return SizedBox.shrink(); // No overlay needed after loading
                }
                return SizedBox.shrink();
              },
            ),
          ]
          )

    );
  }

  Future<void> _onMapReady() async {
    try {
      await MapControllerProvider.of(context)!.controller?.moveTo(
        widget.initialPoint,
        animate: true,
      );
    } catch (e) {
      print("Error moving to position: $e");
    }
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    print("mapIsReady called with isReady: $isReady");
    if (isReady) {
      setState(() {
        _isMapReady = true;
      });
      print("Map is ready!");
      await Future.delayed(Duration(seconds: 20)); // Add a delay
      // Now you can safely call methods on mapController
      try {
        MapControllerProvider.of(context)!.controller?.moveTo(
          widget.initialPoint,
          animate: true,
        );
      } catch (e) {
        print("Error moving to position: $e");
      }
    }

    //Add Listener
    trackingNotifier.addListener(() async {
      if (userLocationNotifier.value != null && !trackingNotifier.value) {
        await MapControllerProvider.of(context)!.controller?.removeMarker(userLocationNotifier.value!);
        MapControllerProvider.of(context)!.controller?.removeMarker(userLocationNotifier.value!);

        userLocationNotifier.value = null;
      }
    });
  }

  @override
  void dispose() {
    searchDepartureFocusNode.dispose();
    searchArrivalFocusNode.dispose();
    MapControllerProvider.of(context)!.controller!.removeObserver(this);
    MapControllerProvider.of(context)!.dispose();

    // ... other disposals ...
    super.dispose();
  }

  @override
  /*
   * Function showMarkerDescription
   * @Param TrafficEvent event
   */
  void showMarkerDescription(BuildContext context, TrafficEvent event) {
    var formate = DateFormat('dd-MM-yyyy HH:mm');

    showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: Text(event.toName),
          content: Text('Priorité: ' +
              event.type.substring(0, 1).toUpperCase() +
              event.type.substring(1, event.type.length) +
              " " +
              " \r " +
              event.description +
              " \r Du " +
              formate.format(event.startDate) +
              " au " +
              formate.format(event.endDate) +
              " \r Source : " +
              event.sourceName),
          actions: <Widget>[
            PointerInterceptor(
              intercepting: true,
              child: GestureDetector(
                onLongPress: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                  height: 24.0,
                  width: 100.0,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    //This doesn't work, Interceptor doesn't fetch mouse event
                    child: Text('Close'),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  manageRouteZoomDisplay(
      MapController controller, GeoPoint departure, GeoPoint arrival) async {
    var zoomNav = TravelZoomFit(
      controller: controller,
      departure: departure,
      arrival: arrival,
    );
    await zoomNav.adjustMap();

    await controller.addMarker(
      departure,
      markerIcon: MarkerIcon(
        icon: Icon(Icons.location_on, color: Colors.red),
      ),
    );

    await controller.addMarker(
      arrival,
      markerIcon: MarkerIcon(
        icon: Icon(Icons.location_on, color: Colors.blue),
      ),
    );
  }

  //Add markers on map on Single Tap and remove last one
  @override
  void onSingleTap(GeoPoint position) {
    super.onSingleTap(position);
    Future.microtask(() async {
      if (lastGeoPoint.value != null) {
        await MapControllerProvider.of(context)!.controller?.changeLocationMarker(
          oldLocation: lastGeoPoint.value!,
          newLocation: position,
          //iconAnchor: IconAnchor(anchor: Anchor.top),
        );
        MapControllerProvider.of(context)!.controller?.removeMarker(lastGeoPoint.value!);
        await MapControllerProvider.of(context)!.controller?.addMarker(
          position,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.person_pin,
              color: Colors.red,
              size: 32,
            ),
          ),
          //angle: userLocation.angle,
        );
      } else {
        await MapControllerProvider.of(context)!.controller?.addMarker(
          position,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.person_pin,
              color: Colors.red,
              size: 32,
            ),
          ),
          // iconAnchor: IconAnchor(
          //   anchor: Anchor.left,
          //   //offset: (x: 32.5, y: -32),
          // ),
          //angle: -pi / 4,
        );
      }
      //await controller.moveTo(position, animate: true);
      lastGeoPoint.value = position;
      geos.add(position);
    });
  }

  @override
  void onRegionChanged(Region region) {
    super.onRegionChanged(region);
    if (trackingNotifier.value) {
      final userLocation = userLocationNotifier.value;
      if (userLocation == null ||
          !region.center.isEqual(
            userLocation,
            precision: 1e4,
          )) {
        userLocationIcon.value = Icons.gps_not_fixed;
      } else {
        userLocationIcon.value = Icons.gps_fixed;
      }
    }
  }

  @override
  void onLocationChanged(UserLocation userLocation) async {
    super.onLocationChanged(userLocation);
    if (disableMapControlUserTracking.value && trackingNotifier.value) {
      await MapControllerProvider.of(context)!.controller!.moveTo(userLocation);
      if (userLocationNotifier.value == null) {
        await MapControllerProvider.of(context)!.controller!.addMarker(
          userLocation,
          markerIcon: const MarkerIcon(
            icon: Icon(Icons.navigation),
          ),
          angle: userLocation.angle,
        );
      } else {
        await MapControllerProvider.of(context)!.controller!.changeLocationMarker(
          oldLocation: userLocationNotifier.value!,
          newLocation: userLocation,
          angle: userLocation.angle,
        );
      }
      userLocationNotifier.value = userLocation;
    } else {
      if (userLocationNotifier.value != null && !trackingNotifier.value) {
        await MapControllerProvider.of(context)!.controller!.removeMarker(userLocationNotifier.value!);
        userLocationNotifier.value = null;
      }
    }
  }

  @override
  void didUpdateWidget(covariant OpenStreetMapTraffic oldWidget) {
    // Perform actions based on changes in oldWidget vs widget
    /*if (oldWidget.someProperty != widget.someProperty) {
      print('Property changed!');
    } */
  }

  /*
  * Function addTraffic
  * @Param dynamic a, is just here because compute need a dynamic afunction(dynamic parameter)
  */
  @override
  dynamic addTraffic(dynamic a) async {
    print("Traffic data loaded. Updating markers...");
    var trafficDatas = await trafficEvents;
    if (trafficDatas!.isEmpty) {
      debugPrint('MapWithTraffic, trafficEvents is empty');
      return;
    }

    // Wait for the map to be ready
    await mapReadyCompleter.future;
    debugPrint("Map is ready. Proceeding with marker updates.");

    // Clear existing markers
    //await mapController.clearStaticPositions();

    // Add markers for each event
    for (var event in trafficDatas) {
      //   debugPrint(event.type);
      //  debugPrint(event.description);

      if (event.startDate.isBefore(DateTime.now()) &&
          event.endDate.isAfter(DateTime.now())) {
        //   GeoPoint eventPoint =
        //      GeoPoint(latitude: event.latitude, longitude: event.longitude);

        final geoPoint = GeoPoint(latitude: event.latitude, longitude: event.longitude);
        var a = geoPointToEventMap[geoPoint] = event;

        StreetMarker streetMarker = StreetMarkerFactory(event).createStreetMarker();

        streetMarkerList.add(streetMarker);

        //This work
        try {
          streetMarkerRender.streetMarker = streetMarker;
          streetMarkerRender.addStreetMarker(streetMarker);
        } catch (e) {
          debugPrint(
              "MapWithTraffic L136 , addTraffic : Error lors de l'affichage des streetMarker avec StreetMarkerRender : $e");
        }
        // materializeSections(event);
      }
    }

    /*
    debugPrint('MapWithTraffic zoomlevel : ${await MapControllerProvider.of(context as BuildContext)!.getZoom()}');
    double maxDistance =
        clusterRender.calculateDistance(await MapControllerProvider.of(context as BuildContext)!.getZoom());
    List<Cluster> clusterList =
        clusterRender.calculateClusters(streetMarkerList, maxDistance);
    clusterRender.renderClusters(clusterList);
    print("Markers updated."); */
  }

  /*
   * function checkOnly1ParamNonNull
   * validate that only one parameter is being passed in MarkerIcon
   */
  @override
  bool checkOnly1ParamNonNull(MarkerIcon markerIcon) {
    if ((markerIcon.icon != null &&
            (markerIcon.assetMarker != null ||
                markerIcon.iconWidget != null)) ||
        (markerIcon.iconWidget != null &&
            (markerIcon.assetMarker != null || markerIcon.icon != null)) ||
        (markerIcon.assetMarker != null &&
            (markerIcon.icon != null || markerIcon.iconWidget != null))) {
      throw Exception(
          "Only one of 'icon', 'iconWidget', or 'assetMarker' can be non-null.");
    }
    return true;
  }

  /*
   * Function ensureMapIsReady
   */
  @override
  void ensureMapIsReady(Function callback) {
    if (isMapReady) {
      callback();
    } else {
      debugPrint("Map is not ready yet.");
    }
  }

  @override
  /*
    * Function fetchFromHive
    * @param : String keyEntry
    * @param : String boxName
    */
  Future<List<Map<String, dynamic>>> fetchFromHive(
      {required String keyEntry, required String boxName}) async {
    // Fetch the record from Hive
    Map<String, dynamic>? entry = await hiveStore.getRecord(
      entryKey: keyEntry,
      boxName: "trafficBox",
    );

    if (entry != null && entry.containsKey("data")) {
      // Extract the JSON string from the entry
      String jsonString = entry["data"];

      // Decode the JSON string into a Dart list
      List<Map<String, dynamic>> dartList =
          List<Map<String, dynamic>>.from(jsonDecode(jsonString));

      // Use the decoded Dart list as needed
      // debugPrint("Decoded traffic data: $dartList");
      return dartList;
    } else {
      debugPrint(
          "No record found for key: trafficData-$keyEntry or 'data' key missing.");
    }
    return [];
  }

  @override
  // TODO: implement geoPointToEventMap
  Map<GeoPoint, TrafficEvent> get geoPointToEventMap => _geoPointToEventMap;





  void getIframeContent3() {
    // Get the global window object
    final window = js.context;

    // Use JS to query the iframe element by its ID
    final iframe = window['document']
        .callMethod('querySelector', ['#frame_map_1']);

    if (iframe == null) {
      print('Iframe not found.');
      return;
    }

    // Access the contentDocument property of the iframe
    final contentDocument = iframe['contentDocument'];
    if (contentDocument != null) {
      print('Content document found.');
      final body = contentDocument['body'];
      if (body != null) {
        print('Body found: ${body.toString()}');
        // You can interact with the body JS object here
      } else {
        print('Body does not exist.');
      }
    } else {
      print('Content document is null.');
    }
  }

/*
  * Function getIframeContent
  */
  void getIframeContent() {
    // Find the iframe element
    var iframe = html.querySelector('#frame_map_1') as html.IFrameElement?;
    var contentDocument = js.context.callMethod(
        'eval', ['document.querySelector("#frame_map_1").contentDocument']);

    if (contentDocument != null) {
      print('Content document found.');

      // Access body element
      var body = contentDocument['body'];
      if (body != null) {
        print('Body found: ${body.toString()}');
        // Further processing...
      } else {
        print('Body does not exist.');
      }
    } else {
      print('Content document is null.');
    }
  }

  @override
  /*
   * Function initializeMap
   */
  Future<void> initializeMap() async {
    // Your map initialization code here
    // Ensure that mapController is set up correctly
    mapController =
        FMapController.withPosition(initPosition: widget.initialPoint)
            as MapControllerInterface; //
    print('Map initialized');
  }

  /*
   * Function setMapReady
   */
  void setMapReady() {
    // Ensure the map controller is initialized
    if (mapController != null) {
      // Call the getIframe function to perform if the Frame is well loaded with is content
      getIframeContent();
      setState(() {
        isMapReady = true;
        mapController!.setMapReady();
      });

    } else {
      print('Map controller is not initialized');
    }

    if (!mapReadyCompleter.isCompleted) {
      mapReadyCompleter.complete();
      debugPrint("Map is now ready!");
    }
  }

/*
   * Function loadTrafficData
   */
  Future<void> loadTrafficData() async {
    setState(() => isLoading = true);
    print("Loading traffic data...");
    Future<List<Map<String, dynamic>>> trafficDataBddEntry;

    //Initialisation du Parser
    XMLTrafficParser trafficInfo = XMLTrafficParser(isEncrypted: false);

    if (IsEmbededBddUsed) {
      String ddate = DateFormat("dd-MM-yyyy").format(DateTime.now());
      try {
        trafficDataBddEntry = fetchFromHive(
          keyEntry: "trafficData-$ddate",
          boxName: 'trafficBox',
        );

        debugPrint('MapWithTraffic L634, Informations are fetched from BDD');
      } catch (error) {
        debugPrint("There is no entry of the day in HiveBDD $error");
      }
      try {
        // Print debug information
        debugPrint(
            "Traffic Data BDD Entry: ${trafficDataBddEntry.toString()}");

        // Decode the data safely
        if (trafficDataBddEntry.containsKey('data') &&
            trafficDataBddEntry['data'] != null) {
          List<Map<String, dynamic>> trafficData =
              jsonDecode(trafficDataBddEntry['data'])
                  as List<Map<String, dynamic>>;
          debugPrint("Decoded Traffic Data: $trafficData");
          List<TrafficEvent> eventList = [];
          for (Map<String, dynamic> event in trafficData) {
            eventList.add(TrafficEvent.fromJson(event));
          }
          trafficEvents = eventList as Future<List<TrafficEvent>>?;
        } else {
          debugPrint("Key 'data' does not exist or is null.");
        }
      } catch (e) {
        debugPrint("Error decoding traffic data: $e");
      }
    
    } else {
      debugPrint("Traffic Data BDD Entry is null fetch it from web.");
      await trafficInfo.fetchTrafficEvents(widget.file);
      //parse It

      trafficEvents = trafficInfo.parseResult() as Future<List<TrafficEvent>>?;
    }

    setState(() => isLoading = false);
    //addTraffic();
  }

  @override
  bool get mapReady => isMapReady;

  get initialPoint => widget.initialPoint;

/*
   * Function materializeSections
   * @Param TrafficEvent event
   */
  materializeSections(TrafficEvent event) {
    try {
      var roadInfo = MapControllerProvider.of(context)!.controller!.drawRoad(
          GeoPoint(
              latitude: event.latitudeFrom, longitude: event.longitudeFrom),
          GeoPoint(latitude: event.latitudeTo, longitude: event.longitudeTo),
          roadType: RoadType.car, //RoadType.bike, .foot
          //intersectPoint:
          roadOption: RoadOption(
              roadWidth: 10,
              roadColor: const Color(0xFFFFF2CC),
              zoomInto: false));

      roadInfo.ignore();
    } catch (e) {
      debugPrint(
          "MapWithTraffic L180, Materialize Traffic Wedge , error: $e");
    }
  }

  @override
  /*
   * Function persistBddTrafficInfoDatas
   * @Return Future<List<TrafficEvent>>?
   */
  Future<bool> persistBddTrafficInfoDatas(
      String request, List<TrafficEvent>? trafficEventsList) async {
    //This function must be place before loadTrafficData
    bool isPersisted = false;
    var trafficDataBddEntry;
    List<Map<String, dynamic>> trafficEventlistJson = [];
    String ddate = DateFormat('yyy-dd-MM').format(DateTime.now());

    //Manage Persistance Traffic Data in Embeded BDD

    //Translation of trafficEvent contained in trafficEvent in Json Map<String, dynamic>
    for (TrafficEvent trafficEvent in trafficEventsList!) {
      trafficEventlistJson.add(trafficEvent.toJson());
    }
// Get a Dart List from  trafficEventlistJson
    List<Map<String, dynamic>> dartList =
        List<Map<String, dynamic>>.from(trafficEventlistJson);

// Convert the Dart list to a JSON string
    String jsonString = jsonEncode(dartList);

// Wrap the JSON string inside a Map<String, dynamic> if required by Hive
    Map<String, dynamic> entry = {"data": jsonString};
    isPersisted = await hiveStore.record(
        entryKey: "trafficData-$ddate", boxName: "trafficBox", entry: entry);
    if (isPersisted) {
      debugPrint(
          "MapWithTraffic L554, persistBddTrafficInfoDatas , Traffic data recorded in Hive");
    } else {
      debugPrint(
          "MapWithTraffic L555, persistBddTrafficInfoDatas , Traffic data was not recorded in Hive");
    }
    return isPersisted;
  }

  /*
   * setupIframeListener
   */
  void setupIframeListener() {
    var iframe =
        html.document.querySelector('#frame_map_1') as html.IFrameElement?;
    if (iframe != null) {
      print('Iframe found.');

      iframe.onLoad.listen((event) {
        print('Iframe loaded.');

        var contentDocument = iframe.contentDocument;
        if (contentDocument != null) {
          print('Content document found.');
          // Process contentDocument here
        } else {
          print('Content document is null.');
        }
      });
    } else {
      print('Iframe not found.');
    }
  }

/*
 * Function waitForMapReady
 * Use Completer
 */
  @override
  Future<void> waitForMapReady() async {
    await mapReadyCompleter.future;
  }

  //TODO Implement localizeRoute that avoid trafficData PBs.
  /*
   * Function zoomToRegion
   */
  @override
  void zoomToRegion(MapControllerInterface controller) async {
    MapControllerInterface mcontroller;
    try {
      // Define a bounding box using north-east and south-west coordinates
      BoundingBox bounds = BoundingBox(
        north: widget.initialPoint.latitude + 1.5, // Northern latitude
        east: widget.initialPoint.longitude + 1.5, // Eastern longitude
        south: widget.initialPoint.latitude, // Southern latitude
        west: widget.initialPoint.longitude, // Western longitude
      );
      mcontroller = MapControllerProvider.of(context)!.controller!;
      // Zoom to bounding box with padding
      try {
        // Add delay to ensure initialization
        await Future.delayed(Duration(milliseconds: 500));
        debugPrint(
            "zoomToRegion : Delay set to 500ms need for the mapController be ready");

        // Zoom to the specified bounding box with optional padding
        mcontroller.zoomToBoundingBox(bounds, paddinInPixel: 50);

        //print("Zoomed to bounding box");
      } catch (e) {
        print("Error during zoomToBoundingBox: $e");
      }
    } catch (e) {
      print("Error during zoom operation or bounding box adjustment  : $e");
    }
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
}

/*
  * Extensions
  */
extension on html.IFrameElement {
  get contentDocument => contentDocument;
}

// /!\ If import of MapWithTraffic it could have conflict cause MapControllerExtension is define in both
extension MapControllerExtensions on FMapController {
  /*
   * Function  addStaticPosition
   * @Param  List<GeoPoint> list,
   * @Param   String id,
   * @Param  {MarkerIcon? customMarker
   * @Return void
   */
  Future<void> addStaticPosition(List<GeoPoint> list, String id,
      {MarkerIcon? customMarker}) async {
    for (var position in list) {
      await addMarker(
        position,
        markerIcon: customMarker ??
            const MarkerIcon(
              icon: Icon(
                Icons.location_on, //person_pin,
                color: Colors.orange,
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

  // Static map to store readiness state for each MapController instance
  static final Map<FMapController, bool> _mapReadyState = {};

  // Getter to check if the map is ready
  bool get isMapReady => _mapReadyState[this] ?? false;

  // Method to set the map as ready
  void setMapReady() {
    _mapReadyState[this] = true;
    debugPrint("MapControllerExtension: Map is now ready!");
  }

  // Method to reset the readiness state (if needed)
  void resetMapReady() {
    _mapReadyState[this] = false;
    debugPrint("MapControllerExtension: Map readiness reset.");
  }

  Future<void> zoomToBoundingBox(
    BoundingBox box, {
    int paddinInPixel = 0,
  }) async {
    try {
      // Ensure map is ready
      if (this.isMapReady != true) {
        print("MapController is not ready.");
        return;
      }

      // Add delay to ensure initialization
      await Future.delayed(Duration(milliseconds: 500));

      // Perform zoom operation
      await this.zoomToBoundingBox(box, paddinInPixel: paddinInPixel);
      print("Zoomed to bounding box.");

      // Get current zoom level for debugging purposes
      double currentZoom = await getZoom();
      print("Current Zoom Level after adjustment: $currentZoom");
    } catch (e, stack) {
      print("Error during zoom operation: $e");
      print("Stack trace: $stack");
    }
  }
}
