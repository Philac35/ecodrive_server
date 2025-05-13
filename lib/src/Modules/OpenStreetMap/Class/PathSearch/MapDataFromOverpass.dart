import 'dart:convert';

import 'package:ecodrive_server/src/Modules/OpenStreetMap/Class/PathSearch/Interface/MapDataInterface.dart';
import 'package:ecodrive_server/src/Modules/OpenStreetMap/Class/PathSearch/Interface/NodeInterface.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../Controller/MapControllerInterface.dart';
import '../FBoundingBox.dart';
import 'ContractionHierachy/Class/Way.dart';
import 'Interface/NodeInterface.dart';

class MapDataFromOverpass<T extends NodeInterface> implements MapDataInterface {


  late MapControllerInterface controller;

  late Uri url;
  late NodeInterface node;
  late final T Function(
      {required int id,
      required double latitude,
      required double longitude}) nodeFactory;

  MapDataFromOverpass(this.controller, this.nodeFactory){

    url =Uri.parse( 'https://overpass.kumi.systems/api/interpreter');//
    //                     https://lz4.overpass-api.de/api/interpreter
    // url = Uri.parse('https://overpass-api.de/api/interpreter');// original url
   //  url = Uri.parse('https://lz4.overpass-api.de/api/interpreter');

  }

/*
 * Function fetchNodes
 * Limit of Overpass API :  frequency 10 000 and 1GB /day. You can receive 429 errors (Too many requests)
 *  Advices :  [timeout:25][maxsize:1073741824]; at the start of your query to avoid server timeouts and memory errors
 *  Check /api/status on the Overpass server for your current quota and wait times
 * @return Future<List<Node>>
 */


  Future<Map<String, Object>> fetchNodes(GeoPoint start, GeoPoint end) async {
    FBoundingBox fb = FBoundingBox();

    BoundingBox b = FBoundingBox().calculateBounds(start, end);
    //BoundingBox bufferedBox=   fb.hadBufferedBox(bbox: b);

    // Example query: get all nodes in a bounding box
    //  [timeout:25];
    //[maxsize:1073741824];
    //node(${b.south},${b.west},${b.north},${b.east});
    /**
        final query = '''
        [out:json];
        (
        way["highway"~"motorway|trunk|primary|secondary"](${b.south},${b.west},${b.north},${b.east});
        >;
        );
        out;


        ''';*/

try{

  List<Way>ways= await getWays(b);
  Map<int, NodeInterface>nodeMap= await getNodes(b,ways);



      return {
        'nodes': nodeMap,
        'ways': ways,
      };
    } catch (e){
           debugPrint("MapDataFromOverpass L60, Error : ${e}");
    }

    return {
      'nodes': {},
      'ways': [],
    };
  }



  Future<Map<int, NodeInterface>> getNodes( BoundingBox b, List<Way>ways) async {

// 1. Extract all unique node IDs from ways
    Set<int> nodeIds = {};
    for (var way in ways) {
      nodeIds.addAll(way.nodeIds);
    }

// 2. Build and send the node query
    final nodeQuery = '''
[out:json][timeout:25];
node(id:${nodeIds.join(',')});
out body;
''';

    print("QUERY SENT TO OVERPASS FOR NODES:");
    print(nodeQuery);
    final nodeResponse = await http.post(url, body: {'data': nodeQuery});
    final nodeData = jsonDecode(nodeResponse.body);
      debugPrint(nodeData.toString());
// 3. Build nodeMap from nodeData['elements']
    Map<int, NodeInterface> nodeMap = {};
    for (var element in nodeData['elements']) {
      if (element['type'] == 'node' &&
          element.containsKey('lat') &&
          element.containsKey('lon')) {
        nodeMap[element['id']] = nodeFactory(
          id: element['id'],
          latitude: element['lat'],
          longitude: element['lon'],
        );
      }
    }

    print("Number of nodes parsed ${nodeMap.length}");
return nodeMap;

  }

  Future<List<Way>> getWays(BoundingBox b) async {
    final query = '''
    [out:json][timeout:25][maxsize:150000];
    (
      way["highway"~"motorway|trunk|primary|secondary"](${b.south},${b.west},${b.north},${b.east});
    );
    out body;
    >;
    out skel qt;
  ''';

    print("QUERY SENT TO OVERPASS FOR WAYS:");
    print(query);

    final response = await http.post(url, body: {'data': query});

    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);

      List<Way> ways = [];
      for (var element in data['elements']) {
        if (element['type'] == 'way' && element.containsKey('nodes')) {
          // Check for oneway tag
          bool oneway = false;
          if (element.containsKey('tags')) {
            var tags = element['tags'];
            if (tags['oneway'] == 'yes' ||
                tags['oneway'] == 'true' ||
                tags['oneway'] == '1') {
              oneway = true;
            }
            if (tags['highway'] == 'service' || tags['highway'] == 'track') {
              continue; // Skip this way
            }
          }
          ways.add(Way(
            id: element['id'],
            nodeIds: List<int>.from(element['nodes']),
            oneway: oneway,
            tags: element['tags'] ?? {},
          ));
        }
      }
      return ways;
    } else {
      throw Exception('Failed to fetch ways: ${response.statusCode}');
    }
  }





  @override
  Future<List<NodeInterface>> fetchMapData(
      {Duration timeout = const Duration(seconds: 5)}) {
    // TODO: implement fetchMapData
    // In MapData we should fetch informations from CustomTiles. here Nodes are fetched in previous function.
    throw UnimplementedError();
  }
}
