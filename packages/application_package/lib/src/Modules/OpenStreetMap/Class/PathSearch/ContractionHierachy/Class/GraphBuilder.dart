import 'package:shared_package/Modules/OpenStreetMap/Class/GeoDistance.dart';

import 'Edge.dart';
import 'Way.dart';
import '../../Interface/NodeInterface.dart';

import 'Node.dart';
class GraphBuilder {
  Map<int, List<Edge>> edges = {};

  Map<int, List<Edge>> buildGraph(Map<int, Node> nodeMap, List<Way> ways) {
    for (final way in ways) {
      String? highwayType = way.tags['highway'];

      for (int i = 0; i < way.nodeIds.length - 1; i++) {
        int from = way.nodeIds[i];
        int to = way.nodeIds[i + 1];

        // Ensure both nodes exist
        if (!nodeMap.containsKey(from) || !nodeMap.containsKey(to)) continue;

        Node nodeA = nodeMap[from]!;
        Node nodeB = nodeMap[to]!;

        double weight = GeoDistance().calculateHaversineDistanceNode(nodeA, nodeB);




        // Penalize certain road types
        if (highwayType == 'service' || highwayType == 'track') {
          weight *= 10; // or any penalty factor you want
        }

        //Create and  Add edge
        edges.putIfAbsent(from, () => []).add(
          Edge(from: from, to: to, weight: weight, nodeMap: nodeMap),
        );

        // Add reverse edge if not oneway
        if (!way.oneway) {
          edges.putIfAbsent(to, () => []).add(
            Edge(from: to, to: from, weight: weight, nodeMap: nodeMap),
          );
        }
      }
    }
    print("Number of ways parsed: ${ways.length}");
    return edges;
  }
}



