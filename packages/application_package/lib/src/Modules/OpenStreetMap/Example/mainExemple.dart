import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:pointer_interceptor/pointer_interceptor.dart';


//Exemple with basic feature.
// An address bar, that search address but can only  be used with tabulation. Direct focus and edit are not available.
// You can set points on the map
class MainPageExample extends StatelessWidget {
  const MainPageExample({super.key});
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
  late MapController controller;
  late FocusNode searchFocusNode;
  late TextEditingController searchController;

  ValueNotifier<bool> trackingNotifier = ValueNotifier(false);
  ValueNotifier<bool> showFab = ValueNotifier(false);
  ValueNotifier<bool> disableMapControlUserTracking = ValueNotifier(true);
  ValueNotifier<IconData> userLocationIcon = ValueNotifier(Icons.near_me);
  ValueNotifier<GeoPoint?> lastGeoPoint = ValueNotifier(null);
  List<GeoPoint> geos = [];
  ValueNotifier<GeoPoint?> userLocationNotifier = ValueNotifier(null);
  final mapKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    searchFocusNode = FocusNode();
    searchController = TextEditingController();
    controller = MapController(
      initPosition: GeoPoint(
        latitude: 47.4358055,
        longitude: 8.4737324,
      ),
      // initMapWithUserPosition: UserTrackingOption(
      //   enableTracking: trackingNotifier.value,
      // ),
      useExternalTracking: disableMapControlUserTracking.value,
    );
    controller.addObserver(this);
    trackingNotifier.addListener(() async {
      if (userLocationNotifier.value != null && !trackingNotifier.value) {
        await controller.removeMarker(userLocationNotifier.value!);
        userLocationNotifier.value = null;
      }
    });
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      showFab.value = true;
    }
  }

  @override
  void onSingleTap(GeoPoint position) {
    super.onSingleTap(position);
    Future.microtask(() async {
      if (lastGeoPoint.value != null) {
        // await controller.changeLocationMarker(
        //   oldLocation: lastGeoPoint.value!,
        //   newLocation: position,
        //   //iconAnchor: IconAnchor(anchor: Anchor.top),
        // );
        //controller.removeMarker(lastGeoPoint.value!);
        await controller.addMarker(
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
        await controller.addMarker(
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
      await controller.moveTo(userLocation);
      if (userLocationNotifier.value == null) {
        await controller.addMarker(
          userLocation,
          markerIcon: const MarkerIcon(
            icon: Icon(Icons.navigation),
          ),
          angle: userLocation.angle,
        );
      } else {
        await controller.changeLocationMarker(
          oldLocation: userLocationNotifier.value!,
          newLocation: userLocation,
          angle: userLocation.angle,
        );
      }
      userLocationNotifier.value = userLocation;
    } else {
      if (userLocationNotifier.value != null && !trackingNotifier.value) {
        await controller.removeMarker(userLocationNotifier.value!);
        userLocationNotifier.value = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.maybeOf(context)?.viewPadding.top;
    print("Building main widget"); // Debug print
    return Stack(
      children: [
        Map(
          controller: controller,
        ),
        if (!kReleaseMode || kIsWeb) ...[
          Positioned(
            bottom: 23.0,
            left: 15,
            child: ZoomNavigation(
              controller: controller,
            ),
          )
        ],
        Positioned.fill(
          child: ValueListenableBuilder(
            valueListenable: showFab,
            builder: (context, isVisible, child) {
              if (!isVisible) {
                return const SizedBox.shrink();
              }
              return Stack(
                children: [
                  if (!kIsWeb) ...[
                    Positioned(
                      top: (topPadding ?? 26) + 48,
                      right: 15,
                      child: MapRotation(
                        controller: controller,
                      ),
                    )
                  ],
                  Positioned(
                    top: kIsWeb ? 26 : topPadding ?? 26.0,
                    left: 12,

                      child: const MainNavigation(),
                    ),

                  Positioned(
                    bottom: 32,
                    right: 15,
                    child: ActivationUserLocation(
                      controller: controller,
                      trackingNotifier: trackingNotifier,
                      userLocation: userLocationNotifier,
                      userLocationIcon: userLocationIcon,
                    ),
                  ),
                  Positioned(
                    bottom: 148,
                    right: 15,
                    child: IconButton(
                      onPressed: () async {
                        Future.forEach(geos, (element) async {
                          await controller.removeMarker(element);
                          await Future.delayed(
                              const Duration(milliseconds: 100));
                        });
                      },
                      icon: const Icon(Icons.clear_all),
                    ),
                  ),
                  Positioned(
                    bottom: 92,
                    right: 15,
                    child: DirectionRouteLocation(
                      controller: controller,
                    ),
                  ),
                  Positioned(
                    top: kIsWeb ? 26 : topPadding,
                    left: 64,
                    right: 72,
                    child: SearchInMap(
                      searchFocusNode: searchFocusNode,
                      controller: controller,
                      onSearch: (String query) {setState(() {
                      searchController.value=TextEditingValue(text:query);
                      });  },
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}

class ZoomNavigation extends StatelessWidget {
  const ZoomNavigation({
    super.key,
    required this.controller,
  });
  final MapController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            maximumSize: const Size(48, 48),
            minimumSize: const Size(24, 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
            padding: EdgeInsets.zero,
          ),
          child: const Center(
            child: Icon(Icons.add),
          ),
          onPressed: () async {
            controller.zoomIn();
          },
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            maximumSize: const Size(48, 48),
            minimumSize: const Size(24, 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
            padding: EdgeInsets.zero,
          ),
          child: const Center(
            child: Icon(Icons.remove),
          ),
          onPressed: () async {
            controller.zoomOut();
          },
        ),
      ],
    );
  }
}

class MapRotation extends HookWidget {
  const MapRotation({
    super.key,
    required this.controller,
  });
  final MapController controller;
  @override
  Widget build(BuildContext context) {
    final angle = useValueNotifier(0.0);
    return FloatingActionButton(
      key: UniqueKey(),
      onPressed: () async {
        angle.value += 30;
        if (angle.value > 360) {
          angle.value = 0;
        }
        await controller.rotateMapCamera(angle.value);
      },
      heroTag: "RotationMapFab",
      elevation: 1,
      mini: true,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ValueListenableBuilder(
          valueListenable: angle,
          builder: (ctx, angle, child) {
            return AnimatedRotation(
              turns: angle == 0 ? 0 : 360 / angle,
              duration: const Duration(milliseconds: 250),
              child: child!,
            );
          },
          child: Image.asset("asset/compass.png"),
        ),
      ),
    );
  }
}

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: UniqueKey(),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      heroTag: "MainMenuFab",
      mini: true,
      backgroundColor: Colors.white,
      child: const Icon(Icons.menu),
    );
  }
}

class DrawerMain extends StatelessWidget {
  const DrawerMain({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (_) {
        Scaffold.of(context).closeDrawer();
      },
      child: Drawer(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.viewPaddingOf(context).top),
            ListTile(
              onTap: () {},
              title: const Text("search example"),
            ),
            ListTile(
              onTap: () {},
              title: const Text("map with hook example"),
            ),
            ListTile(
              onTap: () async {
                Scaffold.of(context).closeDrawer();
                await Navigator.pushNamed(context, '/old-home');
              },
              title: const Text("old home example"),
            )
          ],
        ),
      ),
    );
  }
}

class Map extends StatelessWidget {
  const Map({
    super.key,
    required this.controller,
  });
  final MapController controller;
  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: controller,
      // mapIsLoading: Center(
      //   child: CircularProgressIndicator(),
      // ),
      onLocationChanged: (location) {
        debugPrint(location.toString());
      },
      osmOption: OSMOption(
        enableRotationByGesture: true,
        zoomOption: const ZoomOption(
          initZoom: 16,
          minZoomLevel: 3,
          maxZoomLevel: 19,
          stepZoom: 1.0,
        ),
        userLocationMarker: UserLocationMaker(
            personMarker: MarkerIcon(
              // icon: Icon(
              //   Icons.car_crash_sharp,
              //   color: Colors.red,
              //   size: 48,
              // ),
              // iconWidget: SizedBox.square(
              //   dimension: 56,
              //   child: Image.asset(
              //     "asset/taxi.png",
              //     scale: .3,
              //   ),
              // ),
              iconWidget: SizedBox(
                width: 32,
                height: 64,
                child:Icon(Icons.directions,size:48),

              ),
              // assetMarker: AssetMarker(
              //   image: AssetImage(
              //     "asset/taxi.png",
              //   ),
              //   scaleAssetImage: 0.3,
              // ),
            ),
            directionArrowMarker: const MarkerIcon(
              icon: Icon(
                Icons.navigation_rounded,
                size: 48,
              ),
              // iconWidget: SizedBox(
              //   width: 32,
              //   height: 64,
              //   child: Image.asset(
              //     "asset/directionIcon.png",
              //     scale: .3,
              //   ),
              // ),
            )
          // directionArrowMarker: MarkerIcon(
          //   assetMarker: AssetMarker(
          //     image: AssetImage(
          //       "asset/taxi.png",
          //     ),
          //     scaleAssetImage: 0.25,
          //   ),
          // ),
        ),
        staticPoints: [
          StaticPositionGeoPoint(
            "line 1",
            const MarkerIcon(
              icon: Icon(
                Icons.train,
                color: Colors.green,
                size: 32,
              ),
            ),
            [
              GeoPoint(
                latitude: 47.4333594,
                longitude: 8.4680184,
              ),
              GeoPoint(
                latitude: 47.4317782,
                longitude: 8.4716146,
              ),
            ],
          ),
        ],
        roadConfiguration: const RoadOption(
          roadColor: Colors.blueAccent,
        ),
        showContributorBadgeForOSM: true,
        //trackMyPosition: trackingNotifier.value,
        showDefaultInfoWindow: false,
      ),
    );
  }
}

class SearchLocation extends StatelessWidget {
  const SearchLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField();
  }
}

class ActivationUserLocation extends StatelessWidget {
  final ValueNotifier<bool> trackingNotifier;
  final MapController controller;
  final ValueNotifier<IconData> userLocationIcon;
  final ValueNotifier<GeoPoint?> userLocation;

  const ActivationUserLocation({
    super.key,
    required this.trackingNotifier,
    required this.controller,
    required this.userLocationIcon,
    required this.userLocation,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onLongPress: () async {
        //await controller.disabledTracking();
        await controller.stopLocationUpdating();
        trackingNotifier.value = false;
      },
      child: FloatingActionButton(
        key: UniqueKey(),
        onPressed: () async {
          if (!trackingNotifier.value) {
            /*await controller.currentLocation();
            await controller.enableTracking(
              enableStopFollow: true,
              disableUserMarkerRotation: false,
              anchor: Anchor.right,
              useDirectionMarker: true,
            );*/
            await controller.startLocationUpdating();
            trackingNotifier.value = true;

            //await controller.zoom(5.0);
          } else {
            if (userLocation.value != null) {
              await controller.moveTo(userLocation.value!);
            }

            /*await controller.enableTracking(
                enableStopFollow: false,
                disableUserMarkerRotation: true,
                anchor: Anchor.center,
                useDirectionMarker: true);*/
            // if (userLocationNotifier.value != null) {
            //   await controller
            //       .goToLocation(userLocationNotifier.value!);
            // }
          }
        },
        mini: true,
        heroTag: "UserLocationFab",
        child: ValueListenableBuilder<bool>(
          valueListenable: trackingNotifier,
          builder: (ctx, isTracking, _) {
            if (isTracking) {
              return ValueListenableBuilder<IconData>(
                valueListenable: userLocationIcon,
                builder: (context, icon, _) {
                  return Icon(icon);
                },
              );
            }
            return const Icon(Icons.near_me);
          },
        ),
      ),
    );
  }
}

class DirectionRouteLocation extends StatelessWidget {
  final MapController controller;

  const DirectionRouteLocation({
    super.key,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: UniqueKey(),
      onPressed: () async {},
      mini: true,
      heroTag: "directionFab",
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Icon(
        Icons.directions,
        color: Colors.white,
      ),
    );
  }
}


class SearchInMap extends StatefulWidget {
  final MapController controller;
  final FocusNode searchFocusNode;
  final Function(String) onSearch;

  const SearchInMap({
    super.key,
    required this.searchFocusNode,
    required this.onSearch,
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _SearchInMapState();
}

class _SearchInMapState extends State<SearchInMap> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textController.addListener(onTextChanged);
    widget.searchFocusNode.addListener(() {
      if (widget.searchFocusNode.hasFocus) {
        textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textController.text.length,
        );
      }
    });
  }

  void onTextChanged() {}

  Future<void> searchLocation(String query) async {
    final url = 'https://nominatim.openstreetmap.org/search?q=$query&format=json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final place = data.first;
        final lat = double.parse(place['lat']);
        final lon = double.parse(place['lon']);
        final position = GeoPoint(latitude: lat, longitude: lon);

        await widget.controller.moveTo(position, animate: true);
        await widget.controller.addMarker(
          position,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 48,
            ),
          ),
        );
      }
    } else {
      throw Exception('Failed to load location');
    }
  }

  @override
  void dispose() {
    textController.removeListener(onTextChanged);
    textController.dispose();
    widget.searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.searchFocusNode.hasFocus) {
      print("SearchInMap L625, focus is set on Searchbar");
    } else {
      print("SearchInMap L694, focus isn't set on Searchbar");
    }

    return PointerInterceptor(
      child: GestureDetector(
        onTap: () {
          print('SearchInMap GestureDetector tapped');
          FocusScope.of(context).requestFocus(widget.searchFocusNode);
        },
        child: SizedBox(
          height: 48,
          child: Card(
            color: Colors.white,
            elevation: 2,
            shape: const StadiumBorder(),
            child: TextField(
              controller: textController,
              focusNode: widget.searchFocusNode,
              onSubmitted: (query) {
                widget.onSearch(query);
                searchLocation(query);
              },
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                filled: false,
                isDense: true,
                hintText: "search",
                prefixIcon: Icon(
                  Icons.search,
                  size: 22,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/*
class SearchInMap extends StatefulWidget {
  final MapController controller;
  final FocusNode searchFocusNode;
  final Function(String) onSearch;

  const SearchInMap({
    super.key,
    required this.searchFocusNode,
    required this.onSearch,
    required this.controller,
  });
  @override
  State<StatefulWidget> createState() => _SearchInMapState();
}

class _SearchInMapState extends State<SearchInMap> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textController.addListener(onTextChanged);
    widget.searchFocusNode.addListener(() {
      if (widget.searchFocusNode.hasFocus) {
        textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textController.text.length,
        );
      }
    });
  }

  void onTextChanged() {}

  Future<void> searchLocation(String query) async {
    final url = 'https://nominatim.openstreetmap.org/search?q=$query&format=json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final place = data.first;
        final lat = double.parse(place['lat']);
        final lon = double.parse(place['lon']);
        final position = GeoPoint(latitude: lat, longitude: lon);

        await widget.controller.moveTo(position, animate: true);
        await widget.controller.addMarker(
          position,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 48,
            ),
          ),
        );
      }
    } else {
      throw Exception('Failed to load location');
    }
  }
  @override
  void dispose() {
    textController.removeListener(onTextChanged);
    textController.dispose();
    widget.searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.searchFocusNode.hasFocus) {print("SearchInMap L625, focus is set on Searchbar");}
    else{print ("SearchInMap L694, focus isn't set on Searchbar");}

    return GestureDetector(
      onTap: () {
        print('SearchInMap GestureDetector tapped');
        FocusScope.of(context).requestFocus(widget.searchFocusNode);

        widget.searchFocusNode.requestFocus();
      },
      child: SizedBox(
        height: 48,
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: const StadiumBorder(),
          child: TextField(
            controller: textController,
            focusNode: widget.searchFocusNode,

            onSubmitted: (query) {
              widget.onSearch(query);
              searchLocation(query);
            },
      
      
            maxLines: 1,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              filled: false,
              isDense: true,
              hintText: "search",
              prefixIcon: Icon(
                Icons.search,
                size: 22,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/