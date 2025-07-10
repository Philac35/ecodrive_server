import 'dart:convert';

import 'package:application_package/src/Modules/OpenStreetMap/Controller/MapControllerInterface.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

import 'ContractionHierachy/Class/Edge.dart';
import 'Interface/MapDataInterface.dart';
import 'Interface/NodeInterface.dart';

class MapData<T extends NodeInterface> implements MapDataInterface {

  MapControllerInterface controller;
  late NodeInterface node;
  final T Function({required int id, required double latitude, required double longitude}) nodeFactory;

  MapData(this.controller, this.nodeFactory);



  @override
  Future<List<NodeInterface>> fetchMapData({Duration timeout = const Duration(seconds: 5)}) async {
    // Access CustomTile from BaseMapController
    List<CustomTile> tiles =[];

    BaseMapController bcontroller=this.controller as BaseMapController;
    debugPrint("MapData L22 ${bcontroller.toString()}" );

    final stopwatch = Stopwatch()..start();

    while (bcontroller.customTile == null && stopwatch.elapsed < timeout) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    if (bcontroller.customTile == null) {
      debugPrint("Timeout: customTile was not set in time.");
      return [];
    }

    debugPrint("MapData L31 Controller type: ${this.controller.runtimeType}");
    debugPrint("MapData L32 Controller: ${this.controller}");
    debugPrint("MapData L33 BaseMapController: $bcontroller");
    debugPrint("MapData L34  CustomTile: ${bcontroller.customTile}");

        CustomTile? tile=bcontroller.customTile; // Adjust this according to your FMapController implementation
    debugPrint("MapData L37 $tile" );

    List<NodeInterface> nodes = [];
    if(tile!=null){
    tiles.add(tile);


    // Extract map data from tiles and convert to graph
    for (CustomTile tile in tiles) {
      for (TileURLs tileUrl in tile.urlsServers) {
        try {
          // Fetch tile data from the URL
          final response = await http.get(Uri.parse(tileUrl.url));

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);

            for (var element in data['elements']) {
              debugPrint("MapData L24 , TODO check if lat et lon parameters exist in :${element.toString()}");
              double lat = element['lat'];
              double lon = element['lon'];
              int id = element['id'];
                 node = nodeFactory(id: id, latitude: lat, longitude: lon);
              debugPrint("MapData L24 , Node added to NodeList of General Graph");
              nodes.add(node);
            }
          } else {
            // Handle the case where the HTTP request fails
            print('Failed to fetch tile data from ${tileUrl.url}');
          }
        } catch (e) {
          // Handle any exceptions that occur during the HTTP request
          print('Error fetching tile data from ${tileUrl.url}: $e');
        }
      }
    }}else{debugPrint("MapData L57, Tiles is null");}

    // Connect nodes (simplified example)
    for (int i = 0; i < nodes.length - 1; i++) {
      nodes[i].successors.add(nodes[i + 1] as Edge);    //There is an error here
      nodes[i + 1].successors.add(nodes[i] as Edge);
    }

    return nodes;
  }



/**
 *  We must care or circulation diraction.
    for (Way way in ways) {
    bool oneway = way.tags['oneway'] == 'yes';
    bool reverse = way.tags['oneway'] == '-1';
    List<int> nodeIds = way.nodeRefs;

    for (int i = 0; i < nodeIds.length - 1; i++) {
    int from = nodeIds[i];
    int to = nodeIds[i + 1];
    if (oneway) {
    graph.addEdge(from, to); // Only forward
    } else if (reverse) {
    graph.addEdge(to, from); // Only backward
    } else {
    graph.addEdge(from, to);
    graph.addEdge(to, from); // Both directions
    }
    }
    }

 */









}