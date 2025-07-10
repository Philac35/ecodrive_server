import 'package:auto_route/auto_route.dart';
import 'package:application_package/src/Router/AppRouter.gr.dart';

import '../Authentication/Provider/Listenable/AuthProvider.dart';

class AuthGuard extends AutoRouteGuard {
  late final AuthProvider authProvider;
  bool isAuthenticated = false;

  AuthGuard({required AuthProvider authProvider}) {
    this.authProvider = AuthProvider();
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Check if the user is authenticated
    if (authProvider.isAuthenticated) {
      // User is logged in, allow navigation
      resolver.next(true);
    } else {
      // User is not logged in, redirect to the login page
      router.push(ConnexionModalRoute() as PageRouteInfo);
      resolver.next(false);
    }
  }
}
