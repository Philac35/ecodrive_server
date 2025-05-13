import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';


// Navigation observers are used to observe when routes are pushed ,replaced or popped
class NavigationObserver extends AutoRouterObserver {

  @override
  void didPush(Route route, Route? previousRoute) {
    print('New route pushed: ${route.settings.name}');
  }

  // only override to observer tab routes
  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    print('Tab route visited: ${route.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    print('Tab route re-visited: ${route.name}');
  }
}

/*Configure :
*return MaterialApp.router(
  routerConfig: _appRouter.config(
    navigatorObservers: () => [MyObserver()],
  ),
);
*/