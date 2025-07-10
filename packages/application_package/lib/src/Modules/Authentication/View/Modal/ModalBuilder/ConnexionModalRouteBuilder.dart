

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart'; 


Route<T> connexionModalRouteBuilder<T>(

    BuildContext context,
    Widget child,
    //ConnexionModalRoute page,
   // CustomPage<T> page,
    AutoRoutePage<T>  page,
    ) {
  return DialogRoute(
      context: context,
      builder: (_) => child,
  settings: page,);  // AutoRoutePage implements RouteSettings
}
