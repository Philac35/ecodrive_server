import 'package:application_package/src/Modules/OpenStreetMap/Class/GeoDistance.dart';
import 'Node.dart';

/// Edge represents a direct traversable segment between two points.
class Edge {
  final int from, to;   // Here it is the id of Nodes that are used
 late  double weight; //It should be based on distance (haversine formula) , time d*t, or custom (d*penalty factor)
  final bool isShortcut;
  final double? shortcutWeight; //Stores the sum if it's a shortcut, null
  Map<int, Node> nodeMap;

  Edge({required this. from, required this.to,required this.nodeMap,this.weight = 1.0,  this.shortcutWeight, this.isShortcut=false}){
     weight= getWeight(nodeMap);
  }
  double get effectiveWeight => isShortcut ? (shortcutWeight ?? weight) : weight;

  double getWeight(Map<int, Node> nodeMap) {
    final nodeA = nodeMap[from]!;
    final nodeB = nodeMap[to]!;
    return GeoDistance().calculateHaversineDistanceNode(nodeA, nodeB);
  }


}