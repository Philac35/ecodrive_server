import 'dart:convert';

import 'package:ecodrive_server/src/Modules/OpenStreetMap/Controller/FMapController.dart';
import 'package:ecodrive_server/src/Modules/OpenStreetMap/Controller/MapControllerProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:ecodrive_server/src/Modules/OpenStreetMap/Controller/MapControllerInterface.dart';
import 'package:ecodrive_server/src/Modules/OpenStreetMap/Controller/FBaseMapController.dart';
import 'package:ecodrive_server/src/Modules/OpenStreetMap/Class/Debouncer.dart'
    as deb;
import '../Class/DirectionRouteLocation.dart';

class SearchInMap extends StatefulWidget {
  final MapControllerInterface controller;
  final FocusNode searchFocusNode;
  final Function(String) onSearch;
  final String? hintText;
  final bool? isDeparture;

  SearchInMap(
      {super.key,
      required this.searchFocusNode,
      required this.onSearch,
      required this.controller,
      this.hintText,
      this.isDeparture});

  @override
  State<StatefulWidget> createState() => _SearchInMapState();
}

/*
 *  Class SearchInMapState
 */
class _SearchInMapState extends State<SearchInMap> {

   FMapController?  controller;
  final textController = TextEditingController();
  late List<GeoPoint> currentPoints;



  bool isReady = false;

  _SearchInMapState();


  late final deb.Debouncer _debouncer;
   set debouncer(deb.Debouncer debouncer) {
     this._debouncer = debouncer;
   } // Ensure the point is added to the controller's geopoints list

   deb.Debouncer get debouncer => this._debouncer;

  get isDeparture => widget.isDeparture;

  @override
  void initState() {
    super.initState();
  }


  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

     controller=widget.controller! as FMapController;
    controller != null  ?    debugPrint("${controller} was  instanciated !"): debugPrint("${controller} was not instanciated !");

    this.debouncer = deb.Debouncer(delay: Duration(milliseconds: 500));
    textController.addListener(onTextChanged);
    textController.addListener(_onSearchChanged);

    widget.searchFocusNode.addListener(() {
      if (widget.searchFocusNode.hasFocus) {
        textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textController.text.length,
        );
      }
    });
  }



  @override
  void dispose() {
    textController.removeListener(onTextChanged);
    textController.removeListener(_onSearchChanged);
    textController.dispose();
    //  widget.searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: GestureDetector(
        onTap: () {
          print('SearchInMap GestureDetector tapped');
          FocusScope.of(context).requestFocus(widget.searchFocusNode);
        },
        child: SizedBox(
          height: 48,
          child: Card(
            color: Colors.white,
            elevation: 2,
            shape: const StadiumBorder(),
            child: TextField(
              controller: textController,
              focusNode: widget.searchFocusNode,
              onSubmitted: (query) {
                widget.onSearch(query);
                searchLocationDepartureArrival(query, isDeparture: widget.isDeparture);
              },
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                filled: false,
                isDense: true,
                hintText: widget.hintText != null ? widget.hintText : 'search',
                prefixIcon: const Icon(
                  Icons.search,
                  size: 22,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //  widget.controller.geopoints=position;
  addMarker(
      isDeparture, List<GeoPoint> currentPoints, GeoPoint position) async {
    currentPoints.add(position);
    await widget.controller.addMarker(position,
        markerIcon: MarkerIcon(
          icon: Icon(
            Icons.location_on,
            color: isDeparture != null && isDeparture == true
                ? Colors.green
                : Colors.red,
            size: 48,
          ),
        ));
  }

  Future<void> searchLocationDepartureArrival(String query, {bool? isDeparture = false}) async {
    currentPoints = await widget.controller.geopoints;
     //To get the status of nominatim : https://nominatim.openstreetmap.org/status
     // or check : https://downforeveryoneorjustme.com/
    final url =        'https://nominatim.openstreetmap.org/search?q=$query&format=json';


    //final url ='https://photon.komoot.io/api/?q=$query';
    //final url = "https://github.com/osm-fr/osmpoi4addok/search?q=$query&format=json";
 //   final url="https://demo.addok.xyz/search?q=$query&format=json";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final place = data.first;
        final lat = double.parse(place['lat']);
        final lon = double.parse(place['lon']);
        final position = GeoPoint(latitude: lat, longitude: lon);

        //  if (!currentPoints.contains(position)) {        }


        if (isDeparture == true) {
          controller?.clearAllRoads();
          controller?.clearStaticPositions();
          addMarker(isDeparture, currentPoints, position);

          // Update the controller's geopoints list
          // Note: This is a workaround as there's no direct setter for geopoints
          // await widget.controller.setStaticPosition(currentPoints, "route_points");

          controller?.searchGeopointsObs.updateGeoPoint(0, position);
          controller?.moveTo(position, animate: true);
        } else if (isDeparture == false) {

          controller?.searchGeopointsObs.updateGeoPoint(1, position);
          var point = GeoPoint(latitude: 0, longitude: 0);
          addMarker(isDeparture, currentPoints, position);
          // Update the controller's geopoints list
          // Note: This is a workaround as there's no direct setter for geopoints
          //await widget.controller.setStaticPosition(currentPoints, "route_points");

          if (controller?.searchGeopointsObs.getGeoPoint(0)  != point && controller?.searchGeopointsObs.getGeoPoint(1)  != point) {
            debugPrint("SearchInMap L206, Send request à DirectionRouteLocation to search route");
            controller != null?  debugPrint("SearchInMap L212 Controller : ${controller.toString()} was  instanciated !")   : debugPrint("SearchInMap L212 Controller ${controller.toString()} was not instanciated !");
            if(controller !=null){
              //DirectionRouteLocation( controller: controller ! ).createRoute();
              DirectionRouteLocation( controller: controller! as MapControllerInterface ).createRouteWithContractionHierarchy();

            }
          }

        }
      }
    } else {
      throw Exception('Failed to load location');
    }
  }

   void onTextChanged() {
     //   print('SearchInMap  L59, ${textController.value}');
   }

   void _onSearchChanged() {

     // Start a new timer to wait for user to stop typing
     debouncer.run(() {
       if(isDeparture== true){
         searchLocationDepartureArrival(textController.text, isDeparture: isDeparture);}   //ne pas mettre textController.value.toString(), it can work but sometime it return all the textController
       else{ searchLocationDepartureArrival(textController.text, isDeparture: false);}
       if (controller!.searchGeopointsObs.getGeoPoint(0) != null && controller!.searchGeopointsObs.getGeoPoint(1) != null) {
         isReady = true;
       }
     }
     );
}
}


/*
class SearchInMap extends StatefulWidget {
  final MapController controller;
  final FocusNode searchFocusNode;
  final Function(String) onSearch;

  const SearchInMap({
    super.key,
    required this.searchFocusNode,
    required this.onSearch,
    required this.controller,
  });
  @override
  State<StatefulWidget> createState() => _SearchInMapState();
}

class _SearchInMapState extends State<SearchInMap> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textController.addListener(onTextChanged);
    widget.searchFocusNode.addListener(() {
      if (widget.searchFocusNode.hasFocus) {
        textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textController.text.length,
        );
      }
    });
  }

  void onTextChanged() {}

  Future<void> searchLocation(String query) async {
    final url = 'https://nominatim.openstreetmap.org/search?q=$query&format=json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final place = data.first;
        final lat = double.parse(place['lat']);
        final lon = double.parse(place['lon']);
        final position = GeoPoint(latitude: lat, longitude: lon);

        await widget.controller.moveTo(position, animate: true);
        await widget.controller.addMarker(
          position,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 48,
            ),
          ),
        );
      }
    } else {
      throw Exception('Failed to load location');
    }
  }
  @override
  void dispose() {
    textController.removeListener(onTextChanged);
    textController.dispose();
    widget.searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.searchFocusNode.hasFocus) {print("SearchInMap L625, focus is set on Searchbar");}
    else{print ("SearchInMap L694, focus isn't set on Searchbar");}

    return GestureDetector(
      onTap: () {
        print('SearchInMap GestureDetector tapped');
        FocusScope.of(context).requestFocus(widget.searchFocusNode);

        widget.searchFocusNode.requestFocus();
      },
      child: SizedBox(
        height: 48,
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: const StadiumBorder(),
          child: TextField(
            controller: textController,
            focusNode: widget.searchFocusNode,

            onSubmitted: (query) {
              widget.onSearch(query);
              searchLocation(query);
            },


            maxLines: 1,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              filled: false,
              isDense: true,
              hintText: "search",
              prefixIcon: Icon(
                Icons.search,
                size: 22,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
