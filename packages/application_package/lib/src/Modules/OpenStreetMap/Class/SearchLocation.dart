



import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;


//This is the native Class of the package.
//My equivalent of this class is the Components SearchInMap. It was developped previously
class SearchLocation extends StatefulWidget {

  final MapController controller;
  const SearchLocation({super.key, required this.controller});






  @override
  State<StatefulWidget> createState() {
 return SearchLocationState();
  }
}


class SearchLocationState extends State<SearchLocation>{

   /*
    * Function searchLocation
    * set as exemple here, it don"t use the package GeoLocation
    * but nominatim  the Geolocator or OpenStreetMap
    */
  Future<void> searchLocation(String query ,{ bool? isDeparture=false}) async {
    final url = 'https://nominatim.openstreetmap.org/search?q=$query&format=json';  // /!\ This service crashes regularly !
    //final url ='https://photon.komoot.io/api/?q=$query';//cf. https://photon.komoot.io/
        //final url ="https://corsproxy.io/?url=https://photon.komoot.io/search?q=$query&format=json"; //Essai avec corpsproxy to avoid cors errors
        //final url = "https://github.com/osm-fr/osmpoi4addok/search?q=$query&format=json";  //toTry
        //final url = "https://wiki.openstreetmap.org/wiki/Overpass_API/Overpass_QL/search?q=$query&format=json"; //toTry
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final place = data.first;
        final lat = double.parse(place['lat']);
        final lon = double.parse(place['lon']);
        final position = GeoPoint(latitude: lat, longitude: lon);




        //  widget.controller.geopoints=position;

        await widget.controller.addMarker(
            position,
            markerIcon: MarkerIcon(
              icon: Icon(
                Icons.location_on,
                color: isDeparture!=null && isDeparture==true? Colors.green : Colors.red,
                size: 48,
              ),
            )
        );

        // Ensure the point is added to the controller's geopoints list
        List<GeoPoint> currentPoints = await widget.controller.geopoints;
        if (!currentPoints.contains(position)) {
          currentPoints.add(position);
          // Update the controller's geopoints list
          // Note: This is a workaround as there's no direct setter for geopoints
          await widget.controller.setStaticPosition(currentPoints, "route_points");
        }
        if(isDeparture==true){
          await widget.controller.moveTo(position, animate: true);}
      }
    } else {
      throw Exception('Failed to load location');
    }
  }


  @override
  Widget build(BuildContext context) {
    return const TextField();
  }


}