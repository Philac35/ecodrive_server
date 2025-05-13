import 'package:ecodrive_server/src/Modules/Traffic/Class/Cluster/ClusterRender.dart';
import 'package:ecodrive_server/src/Modules/Traffic/Component/StreetMarker/StreetMarkerRender.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter/foundation.dart';
import '../../Component/StreetMarker/StreetMarker.dart';
import '../../Component/StreetMarker/StreetMarkerRender.dart';
import '../Cluster/Cluster.dart';
import '../Cluster/ClusterRender.dart';

class MapListener {
  MapController mapController;
  StreetMarkerRender streetMarkerRender;
  ClusterRender clusterRender;

  MapListener(
      {required this.mapController,
      required this.streetMarkerRender,
      required this.clusterRender});


  /*
   * Function addListenerMapZoom
   */
  addListenerMapZoom() {
    // Set up zoom level listener
    mapController.listenerRegionIsChanging.addListener(() async {

      try {
        double? currentZoom = await mapController.getZoom();
        if (currentZoom == null) {
          throw ("MapListener L32, Error accessing zoom level: Zoom is null.");
        }
        debugPrint("Current Zoom Level: $currentZoom");


        List<StreetMarker> streetMarkerList = [];
        for (Cluster cluster in clusterRender.clusters!) {
          streetMarkerList.addAll(cluster.streetMarkers);
        }

        debugPrint("StreetMarkerRender initialized: ${streetMarkerRender != null}");
        debugPrint("ClusterRender initialized: ${clusterRender != null}");
        debugPrint("Clusters: ${clusterRender.clusters}");
        debugPrint("StreetMarkerList: $streetMarkerList");

        if (currentZoom < 15) {
          debugPrint("Zoom level < 15: Displaying individual markers.");
           try{
             if (streetMarkerRender == null) {
               throw ("MapListener L41, streetMarkerRender is not initialized.");
             }
             debugPrint("MapListener L45, addListenerMapZoom ,Render Individual Markers");
          streetMarkerRender.renderIndividualMarkers( streetMarkerList);
           }// Replace clusters with individual markers
          catch(e){throw("MapListener L36, StreetMarkerRender should be initialized or streetMarker are null : ${e}");} 
        } else {
          debugPrint("Zoom level > 15: addListenerMapZoom :Displaying clusters.");
          if (clusterRender == null || clusterRender.clusters == null) {
            throw ("MapListener L54, clusterRender or its clusters are not initialized.");
          }
          else{
            try {
              clusterRender.renderClusters(clusterRender.clusters!); // Render clusters
            }catch(e){  debugPrint("MapListener L54, Error rendering clusters: ${e}");
            return; // Exit early if rendering fails};
            }}
      } }catch (e, stack) {
        debugPrint("MapListener L63, addListenerMapZoom :  ${e}");
        debugPrint("Stack trace: $stack");
      }

  });}



  /*
  TODO improve this function
  void addListenerForMapMovment(MapController controller) {
    // Listen for region changes (map movement)
    controller.listenerRegionIsChanging.addListener(() async {
      // Get the current visible region
      GeoPointBounds visibleRegion = await controller.getBounds();
      double currentZoom = await controller.getZoom(); // Get current zoom level

      print("Current Zoom Level: $currentZoom");
      print("Visible Region: ${visibleRegion.toString()}");

      // Dynamically render clusters or individual markers based on zoom level
      if (currentZoom > 15) {
        print("Zoom level > 15: Displaying individual markers.");
        renderIndividualMarkers(controller, allMarkers); // Replace clusters with individual markers
      } else {
        print("Zoom level <= 15: Displaying clusters.");
        renderClusters(controller, clusters); // Render clusters
      }
    });
  }*/

}
