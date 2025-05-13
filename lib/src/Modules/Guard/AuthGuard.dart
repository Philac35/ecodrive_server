import 'package:auto_route/auto_route.dart';
import 'package:ecodrive_server/src/Router/AppRouter.gr.dart';

import '../Authentication/View/ConnexionModal.dart';
import '../Authentication/Provider/Listenable/AuthProvider.dart';
import '../Authentication/View/Page/ConnexionModalPage.dart';

class AuthGuard extends AutoRouteGuard {
  late final AuthProvider authProvider;
  bool isAuthenticated = false;

  AuthGuard({required AuthProvider authProvider}) {
    this.authProvider = AuthProvider();
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Check if the user is authenticated
    if (this.authProvider.isAuthenticated) {
      // User is logged in, allow navigation
      resolver.next(true);
    } else {
      // User is not logged in, redirect to the login page
      router.push(ConnexionModalRoute() as PageRouteInfo);
      resolver.next(false);
    }
  }
}
