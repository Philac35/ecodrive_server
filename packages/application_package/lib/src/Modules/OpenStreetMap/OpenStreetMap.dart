import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:application_package/src/Modules/OpenStreetMap/Controller/MapControllerInterface.dart' ;


import 'package:application_package/src/Modules/OpenStreetMap/Components/SearchInMap.dart';
import 'package:application_package/src/Modules/OpenStreetMap/Components/Map.dart';
import 'Class/ActivationUserLocation.dart';
import 'Class/DirectionRouteLocation.dart';
import 'Class/DrawerMain.dart';
import 'Class/MapRotation.dart';
import 'Class/TravelZoomFit.dart';
import 'Class/ZoomNavigation.dart';




class OpenStreetMap extends StatelessWidget {
  const OpenStreetMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Main(),
      drawer: const DrawerMain(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<Main> with OSMMixinObserver {
  late MapControllerInterface  mapController;

  late FocusNode searchArrivalFocusNode;
  late FocusNode searchDepartureFocusNode;
  late TextEditingController searchDepartureController;
  late TextEditingController searchArrivalController;

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
  GeoPoint initialPoint=GeoPoint(latitude: 48.8566, longitude: 2.3522);  //Paris Hôtel de Ville

  @override
  void initState() {
    super.initState();
    print("initState called");

    searchDepartureFocusNode = FocusNode();
    searchDepartureController = TextEditingController();
    searchArrivalController = TextEditingController();
    searchArrivalFocusNode = FocusNode();

    // Initialization of controllers
    mapController = MapController(
      initPosition: initialPoint,
      useExternalTracking: disableMapControlUserTracking.value,
    ) as MapControllerInterface;

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
    mapController.addObserver(this);

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
  }

  Future<void> _onMapReady() async {
    try {
      await mapController.moveTo(
    initialPoint,
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
        await mapController.moveTo(
         initialPoint,
          animate: true,
        );
      } catch (e) {
        print("Error moving to position: $e");
      }
    }

    //Add Listener
    trackingNotifier.addListener(() async {
      if (userLocationNotifier.value != null && !trackingNotifier.value) {
        await mapController.removeMarker(userLocationNotifier.value!);
        await mapController.removeMarker(userLocationNotifier.value!);

        userLocationNotifier.value = null;
      }
    });
  }

  @override
  void dispose() {
    searchDepartureFocusNode.dispose();
    searchArrivalFocusNode.dispose();
    mapController.removeObserver(this);
    mapController.dispose();
    mapController.removeObserver(this);
    mapController.dispose();
    // ... other disposals ...
    super.dispose();
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
        await mapController.changeLocationMarker(
          oldLocation: lastGeoPoint.value!,
          newLocation: position,
          //iconAnchor: IconAnchor(anchor: Anchor.top),
        );
       mapController.removeMarker(lastGeoPoint.value!);
        await mapController.addMarker(
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
        await mapController.addMarker(
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
      await mapController.moveTo(userLocation);
      if (userLocationNotifier.value == null) {
        await mapController.addMarker(
          userLocation,
          markerIcon: const MarkerIcon(
            icon: Icon(Icons.navigation),
          ),
          angle: userLocation.angle,
        );
      } else {
        await mapController.changeLocationMarker(
          oldLocation: userLocationNotifier.value!,
          newLocation: userLocation,
          angle: userLocation.angle,
        );
      }
      userLocationNotifier.value = userLocation;
    } else {
      if (userLocationNotifier.value != null && !trackingNotifier.value) {
        await mapController.removeMarker(userLocationNotifier.value!);
        userLocationNotifier.value = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.maybeOf(context)?.viewPadding.top;
    return Scaffold(
                body: Stack(
                  children: [
                    Map(
                      controller: mapController,
                      key: mapKey,
                    ),
                    if (!kReleaseMode || kIsWeb) ...[
                      Positioned(
                        bottom: 23.0,
                        left: 15,
                        child: ZoomNavigation(
                          controller: mapController,
                          isMapReady:_isMapReady,
                        ),
                      )
                    ],
                    ValueListenableBuilder(
                      valueListenable: showFab,
                      builder: (context, isVisible, child) {
                        if (!isVisible) {
                          return const SizedBox.shrink();
                        }
                        return Stack(
                          children: [
                            if (!kIsWeb)

                              //Button to implement function of map rotation and initialize the map position
                              Positioned(
                                top: (topPadding ?? 26) + 48,
                                right: 15,
                                child: MapRotation(
                                  controller: mapController as MapController,
                                ),
                              ),
                           /*
                              Uncomment and implement MainNavigation class to has a menu for the map
                              Positioned(
                              top: kIsWeb ? 26 : topPadding ?? 26.0,
                              left: 12,
                              child: const MainNavigation(),
                            ),*/

                            // Display the current location of user
                            Positioned(
                              bottom: 32,
                              right: 15,
                              child: ActivationUserLocation(
                                controller: mapController as MapController,
                                trackingNotifier: trackingNotifier,
                                userLocation: userLocationNotifier,
                                userLocationIcon: userLocationIcon,
                              ),
                            ),

                            //Display Geopoint that will be added further
                            Positioned(
                              bottom: 148,
                              right: 15,
                              child: IconButton(
                                onPressed: () async {
                                  Future.forEach(geos, (element) async {
                                    await mapController
                                        .removeMarker(element);
                                    await Future.delayed(
                                        const Duration(milliseconds: 100));
                                  });
                                },
                                icon: const Icon(Icons.clear_all),
                              ),
                            ),

                            //DirectionRouteLocation is use to implement the search acction
                            Positioned(
                              bottom: 92,
                              right: 15,
                              child: DirectionRouteLocation(
                                controller: mapController ,
                              ),
                            ),

                            // Departure SearchInMap
                            Positioned(
                              top: kIsWeb ? 26 : topPadding ?? 26.0,
                              left: 64,
                              right: 72,
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
                              top: (kIsWeb ? 26 : topPadding ?? 26.0) + 50,
                              left: 64,
                              right: 72,
                              child: Container(

                                child: SearchInMap(
                                  searchFocusNode: searchArrivalFocusNode,
                                  controller: mapController,
                                  hintText: 'Arrival',
                                  isDeparture:false,
                                  onSearch: (String query) async {
                                    setState(() {
                                      searchArrivalController.value =
                                          TextEditingValue(text: query);
                                    });
                                    var a= await mapController.geopoints;
                                   if( a.length >= 2){
                                     DirectionRouteLocation(controller: mapController,).createRoute();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                )

            );
  }

}




