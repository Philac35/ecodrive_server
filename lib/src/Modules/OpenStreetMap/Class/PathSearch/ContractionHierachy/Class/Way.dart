import '../../../GeoDistance.dart';
import './Node.dart';


/**
 *  A Way in OSM is an ordered list of nodes.
 *  It represents a polyline: a road, street, path, or boundary.
 *  Example: A way might have nodes [n1, n2, n3, n4] and represent a stretch of road.
 */

class Way {
  final int id;
  final List<int> nodeIds;
  final bool oneway; // true if one-way, false if bidirectional
  final Map<String, dynamic> tags;

  Way({required this.id, required this.nodeIds, this.oneway = false,required this.tags});
}




