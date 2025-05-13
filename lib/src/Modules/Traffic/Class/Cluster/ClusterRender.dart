//import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'package:ecodrive_server/src/Modules/Traffic/Class/QuadTree/BoundingBox.dart'
    as myBond;
import 'package:ecodrive_server/src/Modules/Traffic/Class/QuadTree/QuadTree.dart';
import 'package:ecodrive_server/src/Modules/Traffic/Component/MapWithTraffic.dart';
import 'package:ecodrive_server/src/Modules/Traffic/Component/StreetMarker/StreetMarkerRender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'package:ecodrive_server/src/Modules/Traffic/Component/StreetMarker/StreetMarker.dart';
import 'package:ecodrive_server/src/Modules/Traffic/Class/Cluster/Cluster.dart';
import '../../../OpenStreetMap/Controller/MapControllerInterface.dart';
import '../../Component/StreetMarker/StreetMarkerRender.dart';
import '../QuadTree/BoundingBox.dart';
import '../TrafficGeolocator.dart';
import 'package:ecodrive_server/src/Modules/OpenStreetMap/Controller/MapControllerInterface.dart' ;
import 'package:ecodrive_server/src/Modules/Traffic/Class/QuadTree/QuadTree.dart' as quadtree;
import 'Cluster.dart';

class ClusterRender {
  late quadtree.QuadTree quadTree;
  final MapControllerInterface controller;
  late List<Cluster> clusters;
  late StreetMarkerRender streetMarkerRender;
  // Set the capacity based on expected marker density by cluster
  final int capacity = 10;


  ClusterRender({required this.controller});
  ClusterRender.init({required this.controller, required this.clusters, required this.streetMarkerRender});

  double calculateDistance(double zoomLevel) {
    if (zoomLevel > 15) {
      return 50; // High zoom: small clusters (50 meters)
    } else if (zoomLevel > 10) {
      return 200; // Medium zoom: medium clusters (200 meters)
    } else {
      return 1000; // Low zoom: large clusters (1000 meters)
    }
  }

  /*
   * Function setReleventClusterToRegion
   * TODO Test with different zoom Level 4/04/2025
   */
  setReleventClusterToRegion(double minLat, double maxLat, double minLon,
      double maxLon, double zoomLevel) {
    myBond.BoundingBox visibleRegion =
        myBond.BoundingBox(minLat, maxLat, minLon, maxLon);
    quadTree = new quadtree.QuadTree(visibleRegion, capacity);
    List<StreetMarker> visibleMarkers = quadTree.query(visibleRegion);
    double distance = calculateDistance(zoomLevel);
    List<Cluster> clusters = calculateClusters(visibleMarkers, distance);
  }

  void renderClusters(List<Cluster> clustersList) async {


    for (var cluster in clustersList) {
      if (cluster.size > 1) {
        addStreetCluster(cluster);
      } else {
        // Add individual StreetMarker
        var streetMarker = cluster.streetMarkers.first;
         streetMarkerRender?.addStreetMarker(streetMarker);
      }
    }
  }


    void renderClusters2(List<Cluster> clustersList) async {
//Clear existing markeers

      for (var cluster in clustersList) {
        if (cluster.size > 1) {
          // Add a cluster marker
          controller.addMarker(cluster.centroid,
              markerIcon: MarkerIcon(
                icon: Icon(Icons.group,
                    size: cluster.size * 10), // Customize icon for clusters
              ));
        } else {
          // Add individual StreetMarker
          var streetMarker = cluster.streetMarkers.first;
          controller.addMarker(streetMarker.geoPoint,
              markerIcon: streetMarker.markerIcone ??
                  MarkerIcon(iconWidget: Icon(Icons.location_on)));
        }
      }
    }


  List<Cluster> calculateClusters(
      List<StreetMarker> markersList, double maxDistance) {
    List<Cluster> clusters = [];

    for (var marker in markersList) {
      bool addedToCluster = false;

      for (var cluster in clusters) {
        // Check if the marker is close enough to be added to an existing cluster
        if (TrafficGeolocator.distanceBetween(
                marker.geoPoint.latitude,
                marker.geoPoint.longitude,
                cluster.centroid.latitude,
                cluster.centroid.longitude) <=
            maxDistance) {
          cluster.streetMarkers.add(marker);
          addedToCluster = true;
          break;
        }
      }

      // If not added to any cluster, create a new one
      if (!addedToCluster) {
        clusters.add(Cluster([marker]));
      }
    }

    return clusters;
  }

  void updateMapWithClusters(List<StreetMarker> allMarkers) async {
    double zoomLevel = await controller.getZoom();
    double maxDistance =
        zoomLevel < 10 ? 1000 : 200; // Adjust distance threshold

    List<Cluster> clusteredMarkersCluster =
        await calculateClusters(allMarkers, maxDistance);

   // controller.clearMarkers(); // Clear existing markers

    for (Cluster streetMarker in clusteredMarkersCluster) {
        addStreetCluster(streetMarker);
    }
  }


  /*
  * Function addStreetCluster
  * Regroup all markers of a Cluster on the same markerIcone with the number of markers that are containing.
  */void addStreetCluster( Cluster cluster) {
    GeoPoint centroid = cluster.centroid;

    // Create a custom marker icon with gesture detection
    MarkerIcon clusterIcon = MarkerIcon(
      iconWidget: GestureDetector(
        onTap: () {
          // Handle tap on the cluster marker
          print("Cluster tapped! Contains ${cluster.size} markers.");
          _showClusterDetails(cluster);
        },
        onLongPress: () {
          // Handle long press (e.g., zoom into the cluster)
          controller.setZoom(zoomLevel: 16); // Zoom into the map
          controller.goToLocation(centroid); // Center map on the cluster's location
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${cluster.size}', // Display number of markers in the cluster
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );

    // Add the cluster marker to the map
    controller.addMarker(centroid, markerIcon: clusterIcon);
  }


  /*
   * Function addStreetCluster
   * @Param : Cluster cluster
   * It have all markers on the map Individually. The logic of regrouping markers isn't implemented here
   */
  void addStreetMarkerCluster(Cluster cluster) {

    GeoPoint centroid = cluster.centroid;
    for(StreetMarker streetMarker in cluster.streetMarkers)
     streetMarkerRender?. addStreetMarker( streetMarker);
    // this.addMarker(centroid,markerIcon: cluster.streetMarkers.markerIcon)

  }

  void _showClusterDetails(Cluster cluster) {
    showDialog(
      context: GlobalKey<NavigatorState>().currentContext!, // Use your app's context here
      builder: (context) {
        return AlertDialog(
          title: Text('Cluster Details'),
          content: SingleChildScrollView(
            child: Column(
              children: cluster.streetMarkers.map((streetMarker) {
                return ListTile(
                  leading:
                  streetMarker.markerIcone?.iconWidget ?? Icon(Icons.location_on),
                  title: Text(streetMarker.event.type),
                  subtitle: Text(streetMarker.event.description),
                );
              }).toList(),
            ),
          ),
          actions: [
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
