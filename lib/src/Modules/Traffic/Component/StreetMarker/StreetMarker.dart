import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../Entities/TrafficEvent.dart';
import 'package:ecodrive_server/src/Modules/Traffic/Component/MapWithTraffic.dart';

import '../Icones/VisualElement.dart';



class StreetMarker extends StatefulWidget implements Marker {
  final TrafficEvent event;
  late MarkerIcon? markerIcone;
  Icon? icone;
  GeoPoint geoPoint;

  StreetMarker({Key? key,
    required this.event,
    MarkerIcon? markerIcone,
    GeoPoint? geoPoint})
      : this.geoPoint = geoPoint ??
      GeoPoint(latitude: event.latitude, longitude: event.longitude),
        this.markerIcone = markerIcone,
        super(key: key);

  @override
  _StreetMarkerState createState() => _StreetMarkerState();

  @override
  Style? style;

  @override
  Content get content => throw UnimplementedError();
}

class _StreetMarkerState extends State<StreetMarker> {
  late GeoPoint geoPoint;

  @override
  void initState() {
    super.initState();


  }


  //cf. showMarkerDescription in MapWithTraffic that implement a correct close function
  void showMarkerDescription(TrafficEvent event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event.type),
          content: Text(event.description),
          actions: <Widget>[
            GestureDetector(
              //intercepting: true,
              //debug:true,
              child: TextButton(
                onPressed: () {
                  debugPrint("Close button tapped");
                  Navigator.of(context).pop();
                }, // Close the dialog
                child: Text('Close'),
                /* Container(
                  color: Colors.transparent, // Ensure it's tappable
                   padding: EdgeInsets.all(8.0),
                   child: Text('Close'),
                      ),*/
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      intercepting: true,
      child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          // HitTestBehavior.opaque/translucent
          onTapDown: (details) {
            //These functions don't detect Tap
            print("Tap detected at ${details.globalPosition}");
          },
          onTapUp: (details) {
            print("Tap released at ${details.globalPosition}");
          },
          onTapCancel: () {
            print("Tap canceled");
          },
          onTap: () {
            debugPrint("StreetMarker L63, onTap debug");
            this.showMarkerDescription(widget.event);
          },
          child: IgnorePointer(
              child: Container(
                  decoration:
                  BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: widget.markerIcone
                        ?.iconWidget,
                  ))) //??            Icon(Icons.location_on, color: Colors.blue),
      ),
    );
  }
}
