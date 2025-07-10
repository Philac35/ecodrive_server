import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class VisualElement{


  MarkerIcon getRoadConstructionIcon() {
    return MarkerIcon(
      iconWidget: Image.asset(
        'images/Icones/road_construction.png',
        width: 48,
        height: 48,
      ),
    );
  }


  MarkerIcon getRoadAccidentIcon() {
    return MarkerIcon(
      iconWidget: Image.asset(
        'images/Icones/triangle.png',
        width: 48,
        height: 48,
      ),
    );
  }



}