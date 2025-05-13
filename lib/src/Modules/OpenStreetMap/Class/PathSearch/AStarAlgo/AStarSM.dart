import 'dart:collection';

import 'package:ecodrive_server/src/Modules/OpenStreetMap/Class/PathSearch/AStarAlgo/Class/Priorityqueue.dart';

//import 'package:flutter/foundation.dart';
import 'Class/Node.dart';


/*
 * Algoritme A* with simplify memory bound
 */
class SMAStar {

  final int memoryLimit;
  final Node start;
  final Node goal;
  final PriorityQueue<Node> queue = PriorityQueue((a, b) => a.f.compareTo(b.f));
  final Set<Node> closedList = {};

  SMAStar({required this.memoryLimit, required this.start, required this.goal});

  bool isGoal(Node node) {
    return node == goal;
  }

  Node? nextSuccessor(Node node) {
    // Implement logic to get the next successor node
    // This is a placeholder implementation
    if (node.successors.isNotEmpty) {
      return node.successors.removeAt(0);
    }
    return null;
  }

  void updateFCost(Node node) {
    // Implement logic to update f-cost of the node and its ancestors if needed
    // This is a placeholder implementation
  }

  double search() {
    queue.add(start);

    while (true) {
      if (queue.isEmpty) {
        // No solution found
        return -1;
      }

      Node node = queue.removeFirst();

      if (isGoal(node)) {
        // Return the cost to reach the goal
        return node.f; // or node.g, depending on your cost tracking
      }

      Node? s = nextSuccessor(node);
      if (s == null) {
        updateFCost(node);
        continue;
      }

      if (!isGoal(s) && s.depth == memoryLimit) {
        s.f = double.infinity;
      } else {
        s.f = (s.f > node.f) ? s.f : s.s + s.h;
      }

      if (node.successors.every((element) => queue.contains(element))) {
        queue.remove(node);
      }

      if (queue.length >= memoryLimit) {
        int minDepth = queue.first.depth;
        Node? badNode = queue.first;

        for (Node element in queue) {
          if (element.depth < minDepth) {
            minDepth = element.depth;
            badNode = element;
          }
        }

        for (Node parent in badNode!.parents) {
          parent.successors.remove(badNode);
          if (parent.successors.isNotEmpty) {
            queue.add(parent);
          }
        }
      }

      queue.add(s);

      //Print for debug
      for(Node node in queue ){
        print(node.toString());
      }
    }
  }


}



void main() {
  // Example usage
  Node goal = Node(id: 1, latitude: 0, longitude: 0, s: 0, h: 0);
  Node start = Node(id: 0, latitude: 0, longitude: 0, s: 0, h: 10);

  // Add successors to the start node
  Node node1 = Node(id: 2, latitude: 0, longitude: 0, s: 5, h: 5, successors: [goal], parents: [start]);
  start.successors.add(node1);

  SMAStar smaStar = SMAStar(memoryLimit: 10, start: start, goal: goal);
  smaStar.search();
}

/*
* Algo created in 1968 by
* Peter Hart, Nils Nilsson, and Bertram Raphael (three American computer scientists)
* Source : “A Formal Basis for the Heuristic Determination of Minimum Cost Paths”
* It select the path that minimizes the following function f(n)= c(n)+h(n)
* c(n) is the cost of the path from stating point to node n
* h(n) is the estimated cost of the path form node n to the destination node, as computed by the Manhattan distance (or Taxicab distance)
 * Manhattan distance : distance between 2 points in a grid based environnement (with only horizontal and vertical moves.
 * It is like Dijkstra : the only change is the use of the cost function with Manhattan distance.
 * source : https://medium.com/@urna.hybesis/pathfinding-algorithms-the-four-pillars-1ebad85d4c6b
 */


/*
  *Complexity : O(E)
  * E is Edge
 */