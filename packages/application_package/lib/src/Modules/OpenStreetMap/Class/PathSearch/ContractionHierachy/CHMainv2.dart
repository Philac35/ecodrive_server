import 'package:flutter/cupertino.dart';
import '../../GeoDistance.dart';
import '../AStarAlgo/AStarSM.dart';
import '../AStarAlgo/Class/Priorityqueue.dart';  //THis class use Priorityqueue from AStarAlgo
import '../AStarAlgo/Class/Node.dart' as asa;

import 'Class/Node.dart';
import 'Class/Edge.dart';
import 'Class/PathResult.dart';
import 'Class/Way.dart';


class CHMainV2 {

  final Map<int, Node> nodes = {};
  late  Map<int, List<Edge>> edges = {};
  final Map<int, List<Edge>> reverseEdges = {};
  final Map<int, int> rank = {};
  final GeoDistance geoDistance = GeoDistance();

  void addEdge(int from, int to, double weight) {
    edges.putIfAbsent(from, () => []).add(Edge(from: from, to: to, weight: weight, nodeMap: nodes));
    reverseEdges.putIfAbsent(to, () => []).add(Edge(to: to, from: from, weight: weight, nodeMap: nodes));
    nodes.putIfAbsent(from, () => Node(id: from, latitude: 0.0, longitude: 0.0));
    nodes.putIfAbsent(to, () => Node(id: to, latitude: 0.0, longitude: 0.0));
  }

  void preprocess() {
    // 1. Determine node importance (degree-based, simple)
    List<int> nodeOrder = nodes.keys.toList()
      ..sort((a, b) => (edges[a]?.length ?? 0).compareTo(edges[b]?.length ?? 0));

    int currentRank = 0;
    Set<int> contracted = {};

    for (final nodeId in nodeOrder) {
      // 2a. Collect all neighbors (in+out)
      final neighbors = <int>{};
      for (final edge in edges[nodeId] ?? []) {
        neighbors.add(edge.to);
      }
      for (final edge in reverseEdges[nodeId] ?? []) {
        neighbors.add(edge.from);
      }
      final neighborList = neighbors.toList();

      // 2b. For every pair of neighbors, check for necessary shortcut
      for (var i = 0; i < neighborList.length; i++) {
        for (var j = 0; j < neighborList.length; j++) {
          if (i == j) continue;
          final u = neighborList[i];
          final v = neighborList[j];

          // Only consider if both u and v are not contracted
          if (contracted.contains(u) || contracted.contains(v)) continue;

          // Weights for u->nodeId and nodeId->v
          final uToNode = getEdgeWeight(u, nodeId);
          final nodeToV = getEdgeWeight(nodeId, v);
          if (uToNode == double.infinity || nodeToV == double.infinity) continue;

          final shortcutWeight = uToNode + nodeToV;

          // Check existing direct edge from u to v
          final existing = getEdgeWeight(u, v);

          // For simplicity: add shortcut if no direct edge or shortcut is shorter
          if (shortcutWeight < existing) {
            edges.putIfAbsent(u, () => []).add(Edge(from: u, to: v, shortcutWeight: shortcutWeight, nodeMap: nodes, isShortcut: true));
            reverseEdges.putIfAbsent(v, () => []).add(Edge(from: u, to: v, shortcutWeight: shortcutWeight, nodeMap: nodes, isShortcut: true));
          }
        }
      }

      // 2c. Mark node as contracted (don't remove from map, just mark)
      contracted.add(nodeId);

      // 3. Store contraction order (rank)
      rank[nodeId] = currentRank++;
    }
  }

  double getEdgeWeight(int from, int to) {
    for (var edge in edges[from] ?? []) {
      if (edge.to == to) {
        return edge.effectiveWeight;
      }
    }
    return double.infinity;
  }


  // Bidirectional Dijkstra using only upward edges (by rank)
  PathResult query(int source, int target) {
    final distF = <int, double>{source: 0};
    final distB = <int, double>{target: 0};
    final prevF = <int, int>{}; // For path reconstruction (forward)
    final prevB = <int, int>{}; // For path reconstruction (backward)
    final visitedF = <int>{};
    final visitedB = <int>{};
    final queueF = PriorityQueue<int>((a, b) => (distF[a] ?? double.infinity).compareTo(distF[b] ?? double.infinity));
    final queueB = PriorityQueue<int>((a, b) => (distB[a] ?? double.infinity).compareTo(distB[b] ?? double.infinity));
    double best = double.infinity;
    int? meetingNode; // The node where the two searches meet

    queueF.add(source);
    queueB.add(target);

    while (queueF.isNotEmpty || queueB.isNotEmpty) {
      if (queueF.isNotEmpty) {
        int u = queueF.removeFirst();
        if (visitedF.contains(u)) continue;
        visitedF.add(u);

        if (visitedB.contains(u)) {
          double d = (distF[u] ?? double.infinity) + (distB[u] ?? double.infinity);
          if (d < best) {
            best = d;
            meetingNode = u;
          }
        }

        for (var e in edges[u] ?? []) {
          if (rank[e.from]! < rank[e.to]!) { // upward edge
            double nd = distF[u]! + e.effectiveWeight;
            if (nd < (distF[e.to] ?? double.infinity)) {
              distF[e.to] = nd;
              prevF[e.to] = u; // Track predecessor
              queueF.add(e.to);
            }
          }
        }
      }
      if (queueB.isNotEmpty) {
        int u = queueB.removeFirst();
        if (visitedB.contains(u)) continue;
        visitedB.add(u);

        if (visitedF.contains(u)) {
          double d = (distF[u] ?? double.infinity) + (distB[u] ?? double.infinity);
          if (d < best) {
            best = d;
            meetingNode = u;
          }
        }

        for (var e in reverseEdges[u] ?? []) {
          if (rank[e.from]! > rank[e.to]!) { // downward edge in reverse graph
            double nd = distB[u]! + e.effectiveWeight;
            if (nd < (distB[e.to] ?? double.infinity)) {
              distB[e.to] = nd;
              prevB[e.to] = u; // Track predecessor
              queueB.add(e.to);
            }
          }
        }
      }
    }

    if (best == double.infinity || meetingNode == null) {
      return PathResult(-1, []);
    }

    // Reconstruct path
    List<int> path = [];

    // Path from source to meetingNode (forward)
    int node = meetingNode;
    List<int> forwardPath = [];
    while (node != source) {
      forwardPath.add(node);
      node = prevF[node]!;
    }
    forwardPath.add(source);
    forwardPath = forwardPath.reversed.toList();

    // Path from meetingNode to target (backward)
    node = meetingNode;
    List<int> backwardPath = [];
    while (node != target) {
      node = prevB[node]!;
      backwardPath.add(node);
    }

    path = forwardPath + backwardPath;

    return PathResult(best, path);
  }


  double queryAStarSM(int source, int target){
    var smas=SMAStar(memoryLimit: 10,start:nodes[source]! as asa.Node, goal:nodes[target]! as asa.Node);
    return smas.search();
  }

  void addWays(List<Way> ways) {
    for (var way in ways) {
      String? highwayType = way.tags['highway'];
      if (way != null) {
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

          double weight = geoDistance.calculateHaversineDistanceNode(fromNode, toNode);

          // Penalize certain road types
          if (highwayType == 'service' || highwayType == 'track') {
            weight *= 10;
          }


          // Add edge to your graph
          edges.putIfAbsent(from, () => []).add(
              Edge(from: from, to: to, weight: weight, nodeMap: nodes)
          );

          if (!way.oneway) {
            // If not oneway, add reverse edge
            if (!way.oneway) {
              edges.putIfAbsent(to, () => []).add(
                  Edge(from: to, to: from, weight: weight, nodeMap: nodes)
              );

        }
      } else {
        print("CHMain L102, addWays, There is no data in Way here!");
      }
    }
  }
}}}

/*
  * Complexity O(logV) or better
  * V: vertice
  */

//Use A* offers little or no advantage in CH cause search space is already minimized.