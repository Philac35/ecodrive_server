import 'package:application_package/src/Modules/OpenStreetMap/Class/PathSearch/Interface/NodeInterface.dart';

import 'Edge.dart';
class Node implements NodeInterface{
  @override
  final int id;
  @override
  @override
  final double latitude, longitude;
  int level = 0; // CH level, higher = contracted later
  List<Edge> parents = [];
  @override
  List<Edge> successors = [];
// ...other fields as needed

Node( {required this.id,
        required this.latitude,
         required this.longitude,
  List<Edge>? successors,
  List<Edge>? parents,
}): successors = successors ?? <Edge>[],
      parents = parents ?? <Edge>[]
;



  @override
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



}
