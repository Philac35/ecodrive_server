
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../../ConnexionModal.dart';
import '../CustomModalRoute.dart';
//Generic Route builder Attempts


class CustomModalRouteBuilder<T> {
  final RouteSettings routeSettings;

  CustomModalRouteBuilder({
    required String routeName,
    required Object? arguments,
  }) : routeSettings = RouteSettings(name: routeName, arguments: arguments);

  Route<T> buildRoute(BuildContext context, Widget child) {
    return PageRouteBuilder<T>(
      settings: routeSettings,
      pageBuilder: (context, animation1, animation2) => child,
      fullscreenDialog: true,
      // Optional, for modal behavior
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation1),
          child: child,
        );
      },
    );
  }
}



//CustomBuilder Type
typedef CustomRouteBuilder = Route<T> Function<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
    );


Route<T> connexionModalRouteBuilder<T>(BuildContext context, Widget child, AutoRoutePage<T> page) {
  final routeBuilder = CustomModalRouteBuilder<T>(
    routeName: 'ConnexionModal',
    arguments: '', // You can pass any arguments you need here
  );
  return routeBuilder.buildRoute(context, child);
}


/*
class CustomModalRouteBuilder {
  CustomModalRouteBuilder();

  CustomRouteBuilder get connexionModalRouteBuilder => <T>(
      BuildContext context,
      Widget child,
      AutoRoutePage<T> page,
      ) {
    return CustomModalRoute<T>(
      child: child,
      settings: page,
    );
  };
}
*/