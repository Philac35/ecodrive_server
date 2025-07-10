
import 'package:application_package/src/Modules/OpenStreetMap/Class/Observer/GeoPointObserver.dart';
import 'package:application_package/src/Modules/OpenStreetMap/Class/PathSearch/BellmanFord/BellmanFord.dart';
import 'package:application_package/src/Modules/OpenStreetMap/Class/PathSearch/ContractionHierachy/CHMainv2.dart';
import 'package:application_package/src/Modules/OpenStreetMap/Class/PathSearch/MapDataFromOverpass.dart';
import 'package:application_package/src/Modules/OpenStreetMap/Controller/FMapController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:application_package/src/Modules/OpenStreetMap/Controller/MapControllerInterface.dart';


import 'GeoDistance.dart';
import 'PathSearch/AStarAlgo/Class/Node.dart' as astar;
import 'PathSearch/ContractionHierachy/Class/GraphBuilder.dart';
import 'PathSearch/ContractionHierachy/Class/Node.dart' as chnode;
import 'PathSearch/ContractionHierachy/Class/PathResult.dart';
import 'PathSearch/ContractionHierachy/Class/Way.dart';
import 'PathSearch/Interface/NodeInterface.dart';

//Manage Route Creation
class DirectionRouteLocation extends StatelessWidget {
  final MapControllerInterface controller;
  RoadInfo? roadInfo;
  double? _duration;
  late NodeInterface node;

  DirectionRouteLocation({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: FloatingActionButton(
        key: UniqueKey(),
        onPressed: () async {
          controller.clearAllRoads();
          createRoute();
          print("I pressed Direction route location");
        },
        mini: true,
        heroTag: "directionFab",
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Icon(
          Icons.directions,
          color: Colors.white,
        ),
      ),
    );
  }

  createRouteMultiple() async {
    final configs = [
      MultiRoadConfiguration(
        startPoint: GeoPoint(latitude: 47.4834379430, longitude: 8.4638911095),
        destinationPoint:
            GeoPoint(latitude: 47.4046149269, longitude: 8.5046595453),
      ),
      MultiRoadConfiguration(
        startPoint: GeoPoint(latitude: 47.4814981476, longitude: 8.5244329867),
        destinationPoint:
            GeoPoint(latitude: 47.3982152237, longitude: 8.4129691189),
        roadOptionConfiguration: MultiRoadOption(roadColor: Colors.orange),
      ),
      // Add more configurations as needed
    ];

    List<RoadInfo> roadsInfo = await controller.drawMultipleRoad(
      [
        MultiRoadConfiguration(
          startPoint: GeoPoint(latitude: 48.8566, longitude: 2.3522),
          destinationPoint: GeoPoint(latitude: 51.5074, longitude: -0.1278),
        ),
        // Add more configurations as needed
      ],
    );

    for (int i = 0; i < roadsInfo.length; i++) {
      print("Route ${i + 1}:");
      print("Distance: ${roadsInfo[i].distance} km");
      print("Duration: ${roadsInfo[i].duration} minutes");
      print("Insructions: ${roadsInfo[i].instructions} ");
    }
  }

  void createRouteWithAStarMS() async {
    debugPrint("Direction Route L88 - It passes by createRouteWithInnerAlgo");
    GeoPointObserver observer =
        (controller as FMapController).searchGeopointsObs;
    print("Existance Controller L91: ${controller.toString()}");
    observer.searchedGeopoints.addListener(() async {
      print("Updated GeoPoints: ${observer.searchedGeopoints.value}");

      debugPrint("DirectionRouteLocation: createRoute");

      if (observer.getGeoPoint(0) != GeoPoint(latitude: 0, longitude: 0) &&
          observer.getGeoPoint(1) != GeoPoint(latitude: 0, longitude: 0)) {
        GeoPoint start = observer.getGeoPoint(0);
        GeoPoint end = observer.getGeoPoint(1);
        debugPrint("DirectionRouteLocation : $start");
        debugPrint('DirectionRouteLocation : $end');

        // TODO implement avoide GoePoints when ways are blocked.
        // We need to preview geopoints before making call to the api.
        // Most of the time, signaled routes are not obstructed.

        List<GeoPoint> geoPointList = [];
        MapDataFromOverpass mapData =
            MapDataFromOverpass<astar.Node>(controller, astar.Node.new);
        debugPrint("Call to fetchNodesFromOverpass()");
        List node = (await mapData.fetchNodes(start, end)) as List;

        // SMAStar smaStar = SMAStar(memoryLimit: 10, start: Node(start), goal: end);
        //smaStar.search();

        if (node.isNotEmpty) {
          for (var n in node) {
            geoPointList
                .add(GeoPoint(latitude: n.latitude, longitude: n.longitude));
          }
        } else {
          debugPrint("L115 Node is empty");
          geoPointList.add(start);
          geoPointList.add(end);
        }
        //change these node to GeoPoint

        debugPrint('Geopoints List L139, DirectionRouteLocation : $geoPointList');
        if (geoPointList.isNotEmpty) {
          //DrawRoad
          roadInfo = await (controller as FMapController).drawRoad(start, end,
              roadType: RoadType.car, //RoadType.bike, .foot
              intersectPoint: geoPointList.sublist(1, geoPointList.length - 1),
              roadOption: RoadOption(
                  roadWidth: 10, roadColor: Colors.deepPurple, zoomInto: true));

          duration = roadInfo!.duration! / 3600;
          durationToString();
          distanceToString();
          instructionToString();
        } else {
          debugPrint("DirectionRouteLocation L137, GeoPointList is empty");
        }
      }
    });
  }

  int findNearestNodeId(GeoPoint geopoint, Map<int, NodeInterface> nodelist) {
    double minDistance = double.infinity;
    int? nearestNodeId;

    for (var entry in nodelist.entries) {
      final node = entry.value;
      double dLat = geopoint.latitude - node.latitude;
      double dLon = geopoint.longitude - node.longitude;
      double distance = dLat * dLat + dLon * dLon; // Use Euclidean distance

      if (distance < minDistance) {
        minDistance = distance;
        nearestNodeId = entry.key;
      }
    }

    if (nearestNodeId == null) {
      throw Exception('No nodes found in the nodelist');
    }
    return nearestNodeId;
  }

  void createRouteWithContractionHierarchy() async {
    debugPrint(
        "Direction Route L160 - It passes by createRouteWithContractionHierarchy");
    GeoPointObserver observer =
        (controller as FMapController).searchGeopointsObs;
    print("Existance Controller L91: ${controller.toString()}");
    observer.searchedGeopoints.addListener(() async {
      print("Updated GeoPoints: ${observer.searchedGeopoints.value}");

      debugPrint("DirectionRouteLocation: createRoute");

      if (observer.getGeoPoint(0) != GeoPoint(latitude: 0, longitude: 0) &&
          observer.getGeoPoint(1) != GeoPoint(latitude: 0, longitude: 0)) {
        GeoPoint start = observer.getGeoPoint(0);
        GeoPoint end = observer.getGeoPoint(1);
        debugPrint("DirectionRouteLocation : $start");
        debugPrint('DirectionRouteLocation : $end');

        // TODO implement avoide GoePoints when ways are blocked.
        // We need to preview geopoints before making call to the api.
        // Most of the time, signaled routes are not obstructed.

        List<GeoPoint> geoPointList = [];
        MapDataFromOverpass mapData =
            MapDataFromOverpass<chnode.Node>(controller, chnode.Node.new);

        debugPrint("Call to fetchNodesFromOverpass()");
        final result = await mapData.fetchNodes(start, end);
        // print("DirectionRouteLocation L211 Overpass response: ${result.toString()}");
        Map<int, NodeInterface> rawNodeMap = {};

        try {
          rawNodeMap = result['nodes'] as Map<int, NodeInterface>;

          debugPrint(
              "DirectionRouteLocation L218,createRouteWithContractionHierarchy() : Nb nodes Parsed ${rawNodeMap.length} nodes from Overpass.");
          if (rawNodeMap.isEmpty) {
            throw ("ERROR: No nodes parsed. Check Overpass response and parsing code.");
          }

          final rawEdgesMap = result['edges'] as Map<int, Edge>? ?? {};
        } catch (error) {
          debugPrint("DirectionRouteLocation L226, Error: $error");
        }

        //Cast Node to chnode.Node
        final nodeMap2 =
            rawNodeMap.map((k, v) => MapEntry(k, v as chnode.Node));

        //Get the ways
        final ways = result['ways'] as List<Way>;



        //Build the Graph


        /* var bf= BellmanFord(nodeMap2.length);
        bf.edges.addAll(rawEdgesMap as Iterable<Edge>);
        bf.bellmanFord(0);
        */

        var builder=GraphBuilder();
        final edges = builder.buildGraph(nodeMap2, ways);

        var ch = CHMainV2();
        ch.nodes.addAll(nodeMap2); // Add all nodes

        if(edges.isEmpty){debugPrint('DirectionRouteLocation L252, edges is empty');}
        else{debugPrint(
            'DirectionRouteLocation L253, edges is not empty');
            debugPrint("Number of edges built: ${edges.length}");
        }
        ch.edges=edges;


        ch.preprocess();

// Find nearest node IDs to your start/end GeoPoints
        int sourceId = findNearestNodeId(start, ch.nodes);
        int targetId = findNearestNodeId(end, ch.nodes);


        print('Source node: ${ch.nodes[sourceId]}');
        print('Target node: ${ch.nodes[targetId]}');
        print('Outgoing edges from $sourceId: ${edges[sourceId]}');
        print('Outgoing edges from $targetId: ${edges[targetId]}');


// Now call query
        PathResult pathResult ;
        try {
          pathResult = ch.query(sourceId, targetId);
          print(
              "Shortest path from $sourceId to $targetId: cost=${pathResult
                  .cost}, path=${pathResult.nodeIds}");

          for (var nodeId in pathResult.nodeIds) {
            var node = ch.nodes[nodeId];
            if (node != null) {
              geoPointList.add(
                  GeoPoint(latitude: node.latitude, longitude: node.longitude));
            }else{debugPrint('DirectionRouteLocation L276, nodes  is empty');}
          }

        }catch(error){
          debugPrint(" DirectionRouteLocation L269, Error PathResult : $error");

        }

        // Print nodes and ways

         //printNodes(ch.nodes);
        //printWays(ways);
        // Print edge weights
        //printEdgeWeights(ways, ch.nodes);
/*
        if (ch.nodes.isNotEmpty) {
          ch.nodes.forEach((k, n) {
            geoPointList.add(GeoPoint(latitude: n.latitude, longitude: n.longitude));
          });
        } else {
          debugPrint("L115 Node is empty");
          geoPointList.add(start);
          geoPointList.add(end);
        }
*/


        // DrawRoad
        if (geoPointList.isNotEmpty) {
          debugPrint('Geopoints List L129, DirectionRouteLocation : $geoPointList');

          roadInfo = await (controller as FMapController).drawRoad(start, end,
              roadType: RoadType.car, //RoadType.bike, .foot
              intersectPoint: geoPointList.sublist(1, geoPointList.length - 1),
              roadOption: RoadOption(
                  roadWidth: 10, roadColor: Colors.deepPurple, zoomInto: true));

          duration = roadInfo!.duration! / 3600;
          durationToString();
          distanceToString();
          instructionToString();
        } else {
          debugPrint("DirectionRouteLocation L137, GeoPointList is empty");
        }
      }
    });
  }

  void printNodes(Map<int, chnode.Node> nodes) {
    debugPrint('DirectionROuteLOcation L318, printNodes :');
    nodes.forEach((k, n) {
      debugPrint(
          'Node: id=$k, latitude=${n.latitude}, longitude=${n.longitude}');
      debugPrint(
          'DirectionRouteLocation L321, PrintNode Node: id=$k, latitude=${n.latitude}, longitude=${n.longitude}');
    });
  }

  void printWays(List<Way> ways) {
    for (var way in ways) {
      print(
          'DirectionRouteLocation L340 PrintWay : Way: nodeIds=${way.nodeIds}, oneway=${way.oneway}');
    }
  }

  void printEdgeWeights(List<Way> ways, Map<int, chnode.Node> nodes) {
    for (var way in ways) {
      for (int i = 0; i < way.nodeIds.length - 1; i++) {
        int from = way.nodeIds[i];
        int to = way.nodeIds[i + 1];

        var fromNode = nodes[from];
        var toNode = nodes[to];

        if (fromNode == null || toNode == null) {
          print('Error: fromNode or toNode is null');
          print('from: $from, to: $to');
          print('fromNode: $fromNode, toNode: $toNode');
          return;
        }

        double weight =
            GeoDistance().calculateHaversineDistanceNode(fromNode, toNode);
        print('Edge from $from to $to: weight=$weight');
      }
        }
  }

  /*
   * Function createRoute
   * Display the route on the map from controller.geopoints
   * It uses an Observer of List searchGeopoints : GeoPointObserver
   */
  void createRoute() async {
    debugPrint("Direction Route L98 - It passes by Route  ");
    GeoPointObserver observer =
        (controller as FMapController).searchGeopointsObs;
    observer.searchedGeopoints.addListener(() async {
      print("Updated GeoPoints: ${observer.searchedGeopoints.value}");

      debugPrint("DirectionRouteLocation: createRoute");

      if (observer.getGeoPoint(0) != GeoPoint(latitude: 0, longitude: 0) &&
          observer.getGeoPoint(1) != GeoPoint(latitude: 0, longitude: 0)) {
        GeoPoint start = observer.getGeoPoint(0);
        GeoPoint end = observer.getGeoPoint(1);
        debugPrint("DirectionRouteLocation : $start");
        debugPrint('DirectionRouteLocation : $end');

        // TODO implement avoide GoePoints when ways are blocked.
        // We need to preview geopoints before making call to the api.
        // Most of the time, signaled routes are not obstructed.

        //DrawRoad
        roadInfo = await (controller as FMapController).drawRoad(start, end,
            roadType: RoadType.car, //RoadType.bike, .foot
            //intersectPoint:
            roadOption: RoadOption(
                roadWidth: 10, roadColor: Colors.deepPurple, zoomInto: true));

        duration = roadInfo!.duration! / 3600;
        durationToString();
        distanceToString();
        instructionToString();
      }
    });
  }

  get distance => roadInfo?.distance;

  List<Instruction>? get instructions => roadInfo?.instructions;

  double? get duration {
    () {
      _duration ??
          (roadInfo?.duration != null ? roadInfo!.duration! / 3600 : 0);
    };
    return null;
  }

  set duration(value) {
    _duration = value;
  }

  durationToString() {
    print("Duration: ${_duration ?? 0} heures");
  }

  distanceToString() {
    print("Distance On RoadInfo: ${roadInfo?.distance} km");
  }

  instructionToString() {
    print("Insructions: ${roadInfo?.instructions} ");
  }

  /*
   * Function createRoutePoint
   * @Param  List<GeoPoint> routePoints,
   * @Param  RoadOption? roadOptions
   * Display the route on the map
   */
  void createRoutePoint(
      List<GeoPoint> routePoints, RoadOption? roadOptions) async {
    if (routePoints.length == 2) {
      GeoPoint start = routePoints[0];
      GeoPoint end = routePoints[1];

      debugPrint(
          "DirectionRouteLocation L140 depart:$routePoints");
      debugPrint("DirectionRouteLocation L141 depart:$start");
      debugPrint("DirectionRouteLocation L142 arrivée$end");

      // Not really needed roadInfo cop with the display on map
      // I keep it here to get an exemple, It could be interesting for further or custom API
      // TravelZoomFit(controller: mapController, departure: start, arrival: end). adjustMap();

      //DrawRoad
      roadInfo = await controller.drawRoad(
        start, end,
        roadType: RoadType.car, //RoadType.bike, .foot
        //intersectPoint:
      );

      roadOptions ??
          RoadOption(
              roadWidth: 10, roadColor: Colors.deepPurple, zoomInto: true);
      //Draw Road manually
      await controller.drawRoadManually(routePoints, roadOptions!);

      durationToString();
      distanceToString();
      instructionToString();
    }

    //This method is not enough precise, prefer to use the distance provided by roadInfo
    //var dist= (await calculateDistancePoint(routePoints));
    //print("distance: "+ dist.toString());

    // manageRouteZoomDisplay(this.mapController, departure,arrival);
    // Create one or 3 different routes.
    // create One line between D - A
    // search the way that follow the most possible around this main line.
    // Fetch point
    // care about circulations rules.

    //Add GeoPoint to MapController
    //DrawRoute
  }
}
