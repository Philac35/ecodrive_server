import 'package:ecodrive_server/src/Modules/OpenStreetMap/Class/PathSearch/Interface/NodeInterface.dart';

import './Edge.dart';
class Node implements NodeInterface{
  final int id;
  final double latitude, longitude;
  int level = 0; // CH level, higher = contracted later
  List<Edge> parents = [];
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
