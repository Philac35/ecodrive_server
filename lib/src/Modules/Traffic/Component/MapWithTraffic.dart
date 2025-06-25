import 'dart:async';
import 'dart:convert';

import 'package:ecodrive_server/src/Modules/OpenStreetMap/Controller/MapControllerInterface.dart';
import 'package:ecodrive_server/src/Modules/Traffic/Class/Cluster/ClusterRender.dart';
import 'package:ecodrive_server/src/Modules/Traffic/Class/Listener/MapListener.dart';

import 'package:ecodrive_server/src/Modules/Traffic/Component/StreetMarker/StreetMarkerRender.dart';
import 'package:flutter/foundation.dart' ;
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'package:intl/intl.dart';

import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:universal_html/js.dart' as js;
import 'package:universal_html/js_util.dart';

import 'package:ecodrive_server/src/Services/EmbededBdd/HiveService.dart';

import 'package:ecodrive_server/src/Modules/Traffic/Class/Cluster/Cluster.dart';
import 'package:ecodrive_server/src/Modules/Traffic/Entities/TrafficEvent.dart';
import 'package:ecodrive_server/src/Modules/Traffic/Service/XMLTrafficParser.dart';
import 'MapWithTraffic.dart';
import 'StreetMarker/StreetMarker.dart';
import 'StreetMarker/StreetMarkerFactory.dart';

//TO Debug
import 'package:universal_html/html.dart' as html;
import 'dart:js_interop' as js;

/*
@js.JS('addEventListener')
external void addEventListener(JSObject object, String event, Function callback);
*/
@js.JS()
@js.staticInterop
class JSObject {
  external factory JSObject();
}

extension JSObjectExtension on JSObject {
  external js.JSObject operator [](String key);

  external void operator []=(String key, js.JSObject value);

  external js.JSObject callMethod(String method, [js.JSArray? args]);
}


@js.JS('document.querySelector')
external JSObject? querySelector(String selector);


// Correctly define addEventListener with valid JS types
@js.JS('addEventListener')
external void addEventListener(JSObject element, String event, js.JSFunction callback);

// Correctly define getContentDocument with valid JS types
@js.JS('iframe.contentDocument')
external JSObject? getContentDocument(JSObject iframe);


@js.JS('contentDocument.body')
external JSObject? getBody(JSObject contentDocument);

@js.JS('body.firstChild')
external JSObject? getFirstChild(JSObject body);


@js.JS('document.body')
external JSObject  getBody2(JSObject  document);

//TODO Improve speed of displaying markers
//TODO Use StreetMark that directly  call showMarkerDescription
 class MapWithTraffic extends StatefulWidget {

  //Datex File that list traffic's events, Informations come from French State Services
  //TODO Uses differents files from differents sources
  //TODO Check redondant informations
  String file = "https://tipi.bison-fute.gouv.fr/bison-fute-ouvert/publicationsDIR/Evenementiel-DIR/grt/RRN/content.xml";

  final GeoPoint initialPoint =
  GeoPoint(latitude: 48.8566, longitude: 2.3522); // Paris Hôtel de Ville

  MapWithTraffic({Key? key}) : super(key: key);

  @override
  MapWithTrafficState createState() => MapWithTrafficState();
}


/*
 * class MapWithTrafficState
 */
class MapWithTrafficState extends State<MapWithTraffic> {

  late MapController mapController;
  late Future<List<TrafficEvent>>? trafficEvents;
  late HiveService hiveStore = HiveService();

  bool isLoading = true;
  bool isMapReady = false;
  Completer<void> mapReadyCompleter = Completer<void>();
  final Map<GeoPoint, TrafficEvent> geoPointToEventMap = {};
  bool IsEmbededBddUsed = false;
  late List<StreetMarker> streetMarkerList = [];
  late StreetMarkerRender streetMarkerRender;
  late ClusterRender clusterRender;
  double initZoomLevel = 15;
  double stepZoom = 1.0;

  /*
  * Function addTraffic
  */
  Future<void> addTraffic() async {
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
    await mapController.clearStaticPositions();

    // Add markers for each event
    for (var event in trafficDatas!) {
      //   debugPrint(event.type);
      //  debugPrint(event.description);

      if (event.startDate.isBefore(DateTime.now()) &&
          event.endDate.isAfter(DateTime.now())) {
        //   GeoPoint eventPoint =
        //      GeoPoint(latitude: event.latitude, longitude: event.longitude);

        final geoPoint =
        GeoPoint(latitude: event.latitude, longitude: event.longitude);
        var a = geoPointToEventMap[geoPoint] = event;

        StreetMarker streetMarker =
        StreetMarkerFactory(event).createStreetMarker();

        streetMarkerList.add(streetMarker);

        //This work
        try {
          if (streetMarkerRender == null) {
            throw ("MapListener L41, streetMarkerRender is not initialized.");
          }
          streetMarkerRender.streetMarker = streetMarker;
          streetMarkerRender.addStreetMarker(streetMarker);
        } catch (e) {
          debugPrint(
              "MapWithTraffic L136 , addTraffic : Error lors de l'affichage des streetMarker avec StreetMarkerRender : ${e}");
        }
        materializeSections(event);
      }
    }

    /*
    debugPrint('MapWithTraffic zoomlevel : ${await mapController.getZoom()}');
    double maxDistance =
        clusterRender.calculateDistance(await mapController.getZoom());
    List<Cluster> clusterList =
        clusterRender.calculateClusters(streetMarkerList, maxDistance);
    clusterRender.renderClusters(clusterList);
    print("Markers updated."); */
  }

  /*
   * Function zoomToRegion
   */
  void zoomToRegion(MapController controller) async {
    MapController mcontroller;
    try {
      // Define a bounding box using north-east and south-west coordinates
      BoundingBox bounds = BoundingBox(
        north: widget.initialPoint.latitude + 1.5, // Northern latitude
        east: widget.initialPoint.longitude + 1.5, // Eastern longitude
        south: widget.initialPoint.latitude, // Southern latitude
        west: widget.initialPoint.longitude, // Western longitude
      );
      mcontroller=await mapController;
      // Zoom to bounding box with padding
      try {


        // Add delay to ensure initialization
        await Future.delayed(Duration(milliseconds: 500));
        debugPrint("zoomToRegion : Delay set to 500ms need for the mapController be ready");

        // Zoom to the specified bounding box with optional padding
          mcontroller.zoomToBoundingBox(bounds, paddinInPixel: 50);

        //print("Zoomed to bounding box");
      } catch (e) {
        print("Error during zoomToBoundingBox: $e");
      }


    } catch (e) {
      print("Error during zoom operation or bounding box adjustment Coucou : $e");
    }
  }



/*
  dynamic getIframeContent() {

       return setupIframeListener();

  }
*/



 /*
  * Function getIframeContent
  */
  void getIframeContent() {
    // Find the iframe element
    var iframe = html.querySelector('#frame_map_1') as html.IFrameElement?;
    var contentDocument = js.context.callMethod('eval', ['document.querySelector("#frame_map_1").contentDocument']);

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

  /*
   * setupIframeListener
   */
  void setupIframeListener() {
    var iframe = html.document.querySelector('#frame_map_1') as html.IFrameElement?;
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
   * Function getIframe
   */
  void getIframe2() {
    // Log the current state of the DOM
    print('Checking for iframe in the DOM...');

    // Use the correct selector for your iframe
    var iframe = html.document.querySelector('#frame_map_1') as html
        .IFrameElement?; // Replace with your actual iframe ID or selector

    if (iframe != null) {
      print('Iframe found: $iframe');

      // Add an event listener to ensure the iframe content is fully loaded
      iframe.onLoad.listen((event) {
        // Use JavaScript interop to access the iframe's content
        var contentDocument = getContentDocument(iframe as JSObject);
        if (contentDocument != null) {
          var body = querySelector((contentDocument as String) + 'body');
          var firstChild = getProperty(body as Object, 'firstChild');
          if (firstChild != null) {
            // Proceed with your logic
            print('First child found: $firstChild');
          } else {
            print('MapWithTraffic L275, First child not found');
          }
        } else {
          print('Content document is null');
        }
      });

      // Check if the iframe content is already loaded
      var contentDocument = getContentDocument(iframe as JSObject);
      if (contentDocument != null) {
        var body = querySelector((contentDocument as String) + ' body');
        var firstChild = getProperty(body as Object, 'firstChild');
        if (firstChild != null) {
          // Proceed with your logic
          print('First child found: $firstChild');
        } else {
          print('First child not found');
        }
      } else {
        print('Content document is null');
      }
    } else {
      print('Iframe not found');
    }
  }

  /*
   * Function initializeMap
   */
  Future<void> initializeMap() async {
    // Your map initialization code here
    // Ensure that mapController is set up correctly
    mapController =
        MapController.withPosition(initPosition: widget.initialPoint);
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
      isMapReady=true;
    } else {
      print('Map controller is not initialized');
    }

    if (!mapReadyCompleter.isCompleted) {
      mapReadyCompleter.complete();
      debugPrint("Map is now ready!");
    }
  }


/*
 * Function waitForMapReady
 * Use Completer
 */
  Future<void> waitForMapReady() async {
    await mapReadyCompleter.future;
  }
  /*
   *  Function build
   * @Param : BuildContext context
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Traffic Events Map')),
        body: Stack(children: [
          OSMFlutter(
            controller: mapController,
            onGeoPointClicked: (GeoPoint geoPoint) {
              // Prevent automatic centering by moving the map slightly
              // When a marker is clicked, calculate a new position slightly offset from the marker's location.
              final newLat = geoPoint.latitude;
              final newLng = geoPoint.longitude -
                  0.001; // Adjust longitude slightly to prevent leftward movement
              mapController.changeLocation(
                  GeoPoint(latitude: newLat, longitude: newLng));
              //    showMarkerDescription();
              debugPrint('GeoPoint clicked: $geoPoint');

              //System to display description (cause it doesn't work StreetMarker)
              final trafficEvent = geoPointToEventMap[geoPoint];
              if (trafficEvent != null) {
                showMarkerDescription(trafficEvent);
                debugPrint('GeoPoint clicked: $geoPoint');
                debugPrint('Associated Traffic Event: ${trafficEvent.type}');
                debugPrint(
                    "Event Numbers in GeoPointMap : ${geoPointToEventMap
                        .length}");
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

                    () =>
                { html.window.onLoad.listen((event) {
                  // Initialize the map and call mapIsReady when the map is ready
                  initializeMap().then((_) {
                    setMapReady(); //inner setMapReady
                    mapController.setMapReady();
                  });
                })};
                // Wait for a short delay to ensure iframe initialization
                int delay = 500;
                debugPrint('MapWithTraffic l205 delay: $delay ms');
                await Future.delayed(Duration(milliseconds: 500));

                try {
                  if (mapController != null) {
                    // Call the getIframe function to perform the necessary checks
                    getIframeContent();
                  } else {
                    print(
                        'MapWithTraffic L234 : Map controller is not initialized');
                  }

                  // Mark map as ready
                  isMapReady = true;
                  mapReadyCompleter.complete();

                  // Set initial zoom level
                  await mapController.setZoom(
                      zoomLevel: initZoomLevel, stepZoom: stepZoom);
                  print("Zoom level set to $initZoomLevel");

                  // Zoom to a specific region (bounding box)
                  zoomToRegion(mapController);
                  print("Zoomed to region");

                  // Clear static positions if any
                  await mapController.clearStaticPositions();
                  print("Static positions cleared");

                  // Move to a specific location
                  await mapController.goToLocation(
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
          FutureBuilder<List<TrafficEvent>>(
            future: trafficEvents,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Error fetching traffic data"));
              } else if (snapshot.hasData) {
                // Add traffic info to the map
                for (var event in snapshot.data!) {
                  addTraffic();
                  compute(materializeSections, event);
                }
                return SizedBox.shrink(); // No overlay needed after loading
              }
              return SizedBox.shrink();
            },
          ),
        ]));
  }

  /*
   * function checkOnly1ParamNonNull
   * validate that only one parameter is being passed in MarkerIcon
   */
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
    * Function fetchFromHive
    * @param : String keyEntry
    * @param : String boxName
    */
  Future<List<Map<String, dynamic>>> fetchFromHive(
      {required String keyEntry, required String boxName}) async {
    // Fetch the record from Hive
    Map<String, dynamic>? entry = await this.hiveStore.getRecord(
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
  initState() {
    super.initState();

    mapController =
        MapController.withPosition(initPosition: widget.initialPoint);

    trafficEvents = Future.value([]);
    loadTrafficData();

    //initialize Render
    // Caution to be used elsewhere, inner properties of these class must be instanciated
    streetMarkerRender = StreetMarkerRender(mapController: mapController as MapControllerInterface);
    clusterRender = ClusterRender(controller: mapController as MapControllerInterface);

    //initialize Listener
    /*
    MapListener(
        mapController: mapController,
        streetMarkerRender: streetMarkerRender,
        clusterRender: clusterRender)
        .addListenerMapZoom();
    debugPrint("MapWithTraffic, mapController is initialized!");

     */
  }


  /*
   * Function persistBddTrafficInfoDatas
   * @Return Future<List<TrafficEvent>>?
   */
  Future<bool> persistBddTrafficInfoDatas(String request,
      List<TrafficEvent>? trafficEventsList) async {
    //This function must be place before loadTrafficData
    bool isPersisted = false;
    var trafficDataBddEntry;
    List<Map<String, dynamic>> trafficEventlistJson = [];
    String ddate = DateFormat('yyy-dd-MM').format(DateTime.now());

    //Manage Persistance Traffic Data in Embeded BDD

    //Translation of trafficEvent contained in trafficEvent in Json Map<String, dynamic>
    for (TrafficEvent trafficEvent in await trafficEventsList!) {
      trafficEventlistJson.add(trafficEvent.toJson());
    }
// Get a Dart List from  trafficEventlistJson
    List<Map<String, dynamic>> dartList = List<Map<String, dynamic>>.from(
        trafficEventlistJson);

// Convert the Dart list to a JSON string
    String jsonString = jsonEncode(dartList);

// Wrap the JSON string inside a Map<String, dynamic> if required by Hive
    Map<String, dynamic> entry = {"data": jsonString};
    isPersisted = await hiveStore.record(
        entryKey: "trafficData-${ddate}", boxName: "trafficBox", entry: entry);
    if (isPersisted) {
      debugPrint(
          "MapWithTraffic L554, persistBddTrafficInfoDatas , Traffic data recorded in Hive");
    }
    else {
      debugPrint(
          "MapWithTraffic L555, persistBddTrafficInfoDatas , Traffic data was not recorded in Hive");
    }
    return isPersisted;
  }


  /*
   * Function loadTrafficData
   */
  Future<void> loadTrafficData() async {
    setState(() => isLoading = true);
    print("Loading traffic data...");
    var trafficDataBddEntry;

   //Initialisation du Parser
    XMLTrafficParser trafficInfo = XMLTrafficParser(isEncrypted: false);

    if (IsEmbededBddUsed){

        String ddate = DateFormat("dd-MM-yyyy").format(DateTime.now());
        try {
          trafficDataBddEntry = fetchFromHive(
            keyEntry: "trafficData-${ddate}", boxName: 'trafficBox',);

          debugPrint('MapWithTraffic L634, Informations are fetched from BDD');

        } catch (error) {
          debugPrint("There is no entry of the day in HiveBDD ${error}");
        }
      if (trafficDataBddEntry != null) {
        try {
          // Print debug information
          debugPrint(
              "Traffic Data BDD Entry: ${trafficDataBddEntry.toString()}");

          // Decode the data safely
          if (trafficDataBddEntry.containsKey('data') &&
              trafficDataBddEntry['data'] != null) {
            List<Map<String, dynamic>> trafficData = jsonDecode(
                trafficDataBddEntry['data']) as List<Map<String, dynamic>>;
            debugPrint("Decoded Traffic Data: $trafficData");
            List<TrafficEvent> eventList = [];
            for (Map<String, dynamic> event in trafficData) {
              eventList?.add(TrafficEvent.fromJson(event));
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
        trafficEvents =
        trafficInfo.parseResult() as Future<List<TrafficEvent>>?;
        //Persist in BDD
        persistBddTrafficInfoDatas(widget.file, await trafficEvents);
      }
  }else{

  debugPrint("Traffic Data BDD Entry is null fetch it from web.");
  await trafficInfo.fetchTrafficEvents(widget.file);
  //parse It

  trafficEvents = trafficInfo.parseResult() as Future<List<TrafficEvent>>?;


  }

      setState(() => isLoading = false);
      //addTraffic();

  }
    /*
   * Function materializeSections
   * @Param TrafficEvent event
   */
    materializeSections(TrafficEvent event) {
      try {
        var roadInfo = mapController.drawRoad(
            GeoPoint(
                latitude: event.latitudeFrom, longitude: event.longitudeFrom),
            GeoPoint(latitude: event.latitudeTo, longitude: event.longitudeTo),
            roadType: RoadType.car, //RoadType.bike, .foot
            //intersectPoint:
            roadOption: RoadOption(
                roadWidth: 10,
                roadColor: const Color(0xFFFFF2CC),
                zoomInto: false));
      } catch (e) {
        debugPrint(
            "MapWithTraffic L180, Materialize Traffic Wedge , error: ${e}");
      }
    }


    /*
   * Function showMarkerDescription
   * @Param TrafficEvent event
   */
    void showMarkerDescription(TrafficEvent event) {
      var formate = DateFormat('dd-MM-yyyy HH:mm');

      showDialog(
        context: context,
        builder: (BuildContext context,) {
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
                    padding: EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 2.0),
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

  /*
   * Function ensureMapIsReady
   */
  void ensureMapIsReady(Function callback) {
    if (isMapReady) {
      callback();
    } else {
      debugPrint("Map is not ready yet.");
    }
  }

  bool get mapReady => isMapReady;
  }



 /*
  * Extensions
  */
extension on html.IFrameElement {
   get contentDocument => contentDocument;
}


  extension MapControllerExtensions  on MapController  {

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

    // Static map to store readiness state for each MapController instance
    static final Map<MapController, bool> _mapReadyState = {};

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
        if (!this.isMapReady) {
          print("MapController is not ready.");
          return;
        }

        // Add delay to ensure initialization
        await Future.delayed(Duration(milliseconds: 500));

        // Perform zoom operation
        await this.zoomToBoundingBox(box, paddinInPixel: paddinInPixel);
        print("Zoomed to bounding box.");

        // Get current zoom level for debugging purposes
        double currentZoom = await this.getZoom();
        print("Current Zoom Level after adjustment: $currentZoom");
      } catch (e, stack) {
        print("Error during zoom operation: $e");
        print("Stack trace: $stack");
      }
    }
}
