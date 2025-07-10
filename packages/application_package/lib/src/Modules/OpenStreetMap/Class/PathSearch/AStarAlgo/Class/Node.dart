
/*
 *Class Node spécific to A* Algorithme.
 */
import '../../Interface/NodeInterface.dart';

class Node implements NodeInterface{

  final int id;
  final double latitude;
  final double longitude;
   List<Node> successors;
   List<Node> parents;
  double f = 0;   // Cost Total  f(n)= s(n) +h(n)
  double s = 0;   // Cost to come s(n)
  double h = 0;   // Heuristic Cost h(n)
  int depth = 0;

  Node({
    required this.id,
    required this.latitude,
    required this.longitude,
    List<Node>? successors,
    List<Node>? parents,
    this.s = 0,
    this.h = 0,
  }): successors = successors ?? [],
        parents = parents ?? []
  ;

  Map<String, dynamic> toJson() => {
    'id': id,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  @override
  String toString() {
    return 'Node(id: $id, latitude: $latitude, longitude: $longitude, successors: ${successors.length}, parents: ${parents.length})';
  }


   //get latitude => latitude;
}


/*
s (Cost-to-Come):This represents the cost from the start node to the current node. It is often denoted as g(n) in the literature.
It accumulates the cost of the path from the start node to the current node as the algorithm explores the graph.

h (Heuristic Cost):
This represents the estimated cost from the current node to the goal node. It is often denoted as h(n).
The heuristic function should be admissible, meaning it never overestimates the true cost. A common heuristic is the Euclidean distance or Manhattan distance, depending on the problem domain.

f (Total Cost):
This is the sum of the cost-to-come (s) and the heuristic cost (h). It is often denoted as f(n) = g(n) + h(n).
The A* algorithm uses this total cost to prioritize which nodes to explore next. Nodes with lower f values are explored first, as they are considered more promising for finding the optimal path to the goal.

 */