
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:ecodrive_server/src/Modules/OpenStreetMap/Controller/MapControllerInterface.dart' ;

class Map extends StatelessWidget {
  const Map({
    super.key,
    required this.controller,

  });

  final MapControllerInterface controller;

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: controller as MapController,

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
                child: Icon(Icons.directions, size: 48),
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
              //Paris Hôtel de Ville
              // GeoPoint(latitude:48.866669,longitude:2.3525 ),
              /* Defaults Points:
              GeoPoint( //Watterstrasse 91 , 8105 RegenDorff Suisse

                latitude: 47.4333594,
                longitude: 8.4680184,
              ),
              GeoPoint( //Justizvollzugsanstalt Pöschwies, Roosstrasse 49, 8105 Regensdorf, Suisse
                latitude: 47.4317782,
                longitude: 8.4716146,
              ),

              */
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
