import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../Entities/TrafficEvent.dart';
import '../Icones/VisualElement.dart';
import 'StreetMarker.dart';

class StreetMarkerFactory {

  var event;

  StreetMarkerFactory(this.event);

  createStreetMarker() {

    var markIcone = getMarkerForEventType(event) ??
        MarkerIcon(icon: Icon(Icons.location_on, color: Colors.orange));

    // Validate the created marker
    checkOnly1ParamNonNull(markIcone);
    StreetMarker streetMarker = StreetMarker(
        event: event, markerIcone: markIcone);

          //debugPrint('icon: ${markIcone.icon}');
           debugPrint('StreetMarkerFactory, check iconWidget exist :');
          debugPrint('iconWidget: ${markIcone.iconWidget}');
          /*
          debugPrint('assetMarker: ${markIcone.assetMarker}');
          debugPrint ("MapWithTraffic L203 ${markIcone}"); */
    return StreetMarker(event: event, markerIcone: markIcone);
  }
}

void checkType(TrafficEvent event) {
  if (event.description.contains(RegExp('[T-t]ravaux')) ||
      event.description.contains(RegExp('[C-c]hantier'))) {
    event.type = 'travaux';
  }
  if (event.description.contains(RegExp('[A-a]ccident'))) {
    event.type = 'accident';
  }
}

/*
  * Function getMarkerForEventType
  * @Param TrafficEvent event
   */
MarkerIcon getMarkerForEventType(TrafficEvent event) {
  MarkerIcon markerIcon;
  VisualElement visualElement = VisualElement();
  checkType(event);

  switch (event.type.toLowerCase()) {
    case 'accident':
      markerIcon = visualElement.getRoadAccidentIcon();
      break;

    case 'travaux':
      final roadConstructionIcon = visualElement.getRoadConstructionIcon();
      markerIcon = MarkerIcon(
        iconWidget: roadConstructionIcon.iconWidget ??
            Icon(Icons.construction, color: Colors.orange, size: 48),
      );
      break;

    case 'manifestation':
      markerIcon = MarkerIcon(
        iconWidget: Icon(Icons.event, color: Colors.blue, size: 48),
      );
      break;

    case 'medium':
      markerIcon = MarkerIcon(
        iconWidget: Icon(Icons.location_on, color: Colors.orange, size: 48),
      );
      break;

    case 'high':
      markerIcon = MarkerIcon(
        iconWidget: Icon(Icons.location_on, color: Colors.red, size: 48),
      );
      break;

    default:
      markerIcon = MarkerIcon(
        iconWidget: Icon(Icons.location_on, color: Colors.green, size: 48),
      );
  }

  // Validate the created MarkerIcon
  checkOnly1ParamNonNull(markerIcon);
  return markerIcon;
}


/*
  * Function checkOnly1ParamNonNull
  * @Param MarkerIcon markerIcon
  */
bool checkOnly1ParamNonNull(MarkerIcon markerIcon) {
  if ((markerIcon.icon != null &&
      (markerIcon.assetMarker != null ||
          markerIcon.iconWidget != null)) ||
      (markerIcon.iconWidget != null &&
          (markerIcon.assetMarker != null || markerIcon.icon != null)) ||
      (markerIcon.assetMarker != null &&
          (markerIcon.icon != null || markerIcon.iconWidget != null))) {
    throw Exception(
        "Only one of 'icon', 'iconWidget', or 'assetMarker' can be non-null.");
  }
  return true;
}




