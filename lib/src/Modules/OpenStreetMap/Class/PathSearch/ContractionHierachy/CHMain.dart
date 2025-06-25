import 'package:flutter/cupertino.dart';
import '../../GeoDistance.dart';
import './Class/Node.dart';
import './Class/Edge.dart';
import 'Class/Way.dart';


class CHMain {
  final Map<int, Node> nodes = {};
  final Map<int, List<Edge>> edges = {};
  final Map<int, List<Edge>> reverseEdges = {};
  final Map<int, int> rank = {};

  void addEdge(int from, int to, double weight) {
    edges.putIfAbsent(from, () => []).add(Edge(from:from, to:to, nodeMap: nodes));
    reverseEdges.putIfAbsent(to, () => []).add(Edge(to:to, from:from, nodeMap:nodes));
    nodes.putIfAbsent(from, () => Node(id: from, latitude: 0.0, longitude: 0.0));
    nodes.putIfAbsent(to, () => Node(id: to, latitude: 0.0, longitude: 0.0));

  }

  // Dummy contraction: just assign increasing ranks (real CH contracts nodes and adds shortcuts)
  void preprocess1() {

   //First attempt is not a real CH algo just a restricted Dijkstra.
    int r = 0;
    for (var node in nodes.values) {
      rank[node.id] = r++;
    }
  }


  /// Returns the weight of the edge from `from` to `to` (shortcut or direct)
  double getEdgeWeight(int from, int to) {
    for (var edge in edges[from] ?? []) {
      if (edge.to == to) {
        // Return shortcut weight if it's a shortcut, otherwise normal weight
        return edge.isShortcut ? (edge.shortWeight ?? edge.weight) : edge.weight;
      }
    }
    return double.infinity;
  }

  // 1. Determine node importance (could be degree, edge difference, etc.)
  // 2. For each node (in increasing importance):
  //    a. Contract the node:
  //       - For every pair of neighbors (u, v), check if the shortest path from u to v goes through this node.
  //       - If yes, add a shortcut edge from u to v with the correct weight.
  //    b. Remove the node from the graph.
  // 3. Store the shortcuts and contraction order (ranks).

  void preprocess() {
    // 1. Determine node importance (degree-based, simple)
    List<int> nodeOrder = nodes.keys.toList()
      ..sort((a, b) => (edges[a]?.length ?? 0).compareTo(edges[b]?.length ?? 0));

    int currentRank = 0;
    Set<int> contracted = {};

    for (final nodeId in nodeOrder) {
      debugPrint('Contracting node: $nodeId');

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
            debugPrint('Adding shortcut from $u to $v with weight $shortcutWeight');
            edges.putIfAbsent(u, () => []).add(Edge(from: u, to: v, shortcutWeight: shortcutWeight, nodeMap: nodes));
            reverseEdges.putIfAbsent(v, () => []).add(Edge(from: u, to: v, shortcutWeight: shortcutWeight, nodeMap: nodes));
          }
        }
      }

      // 2c. Mark node as contracted (don't remove from map, just mark)
      contracted.add(nodeId);

      // 3. Store contraction order (rank)
      rank[nodeId] = currentRank++;
    }
  }



  // Bidirectional Dijkstra using only upward edges (by rank)
  double query(int source, int target) {
    final distF = <int, double>{source: 0};
    final distB = <int, double>{target: 0};
    final visitedF = <int>{};
    final visitedB = <int>{};
    final queueF = <int>[source];
    final queueB = <int>[target];
    double best = double.infinity;

    while (queueF.isNotEmpty || queueB.isNotEmpty) {
      if (queueF.isNotEmpty) {
        int u = queueF.removeLast();
        visitedF.add(u);
        for (var e in edges[u] ?? []) {
          if (rank[e.from]! < rank[e.to]!) { // upward edge
            double nd = distF[u]! + e.weight;
            if (nd < (distF[e.to] ?? double.infinity)) {
              distF[e.to] = nd;
              queueF.add(e.to);
            }
          }
        }
      }
      if (queueB.isNotEmpty) {
        int u = queueB.removeLast();
        visitedB.add(u);
        for (var e in reverseEdges[u] ?? []) {
          if (rank[e.from]! < rank[e.to]!) { // upward edge in reverse graph
            double nd = distB[u]! + e.weight;
            if (nd < (distB[e.to] ?? double.infinity)) {
              distB[e.to] = nd;
              queueB.add(e.to);
            }
          }
        }
      }
      // Check intersection
      for (var v in visitedF) {
        if (visitedB.contains(v)) {
          double d = (distF[v] ?? double.infinity) + (distB[v] ?? double.infinity);
          if (d < best) best = d;
        }
      }
    }
    return best == double.infinity ? -1 : best;
  }




  addWays(List<Way>ways) {
    for (var way in ways) {
      if(way !=null){
      for (int i = 0; i < way.nodeIds.length - 1; i++) {
        int from = way.nodeIds[i];
        int to = way.nodeIds[i + 1];

        // Calculate weight using GeoDistance (e.g., Haversine formula)
        var fromNode = nodes[from];
        var toNode = nodes[to];


        if (fromNode == null || toNode == null) {
          debugPrint('Error: fromNode or toNode is null');
          debugPrint('from: $from, to: $to');
          debugPrint('fromNode: $fromNode, toNode: $toNode');
          // Handle the error appropriately, e.g., return an error value or throw an exception
          return;
        }

        double weight = GeoDistance().calculateHaversineDistanceNode(
            fromNode!, toNode!);

        this.addEdge(from, to, weight);
        // Only add the reverse edge if the way is NOT one-way
        if (!way.oneway) {
          this.addEdge(to, from, weight);
        }
      }

      }else{debugPrint("CHMain L102, addWays, There is no datat in Way here!" );}
    }
  }

void main() {
  var ch = CHMain();
  // Example graph: 0-1-2, 0-2 direct
  ch.addEdge(0, 1, 1); //0
  ch.addEdge(1, 2, 1); //1
  ch.addEdge(0, 2, 3); //2

  ch.preprocess();
  print('Shortest path from 0 to 2: ${ch.query(0, 2)}'); // Should print 2.0
} }