import 'package:auto_route/auto_route.dart';

//import '../Modules/Authentication/View/Modal/Route/ConnexionModalPage.dart';
import 'package:application_package/src/Modules/Guard/AuthGuard.dart';
import 'package:application_package/src/Modules/Authentication/Provider/Listenable/AuthProvider.dart';

import './AppRouter.gr.dart';



@AutoRouterConfig()
class AppRouter extends RootStackRouter {
 late AuthGuard authGard;
 AppRouter(){
   authGard= AuthGuard(authProvider: AuthProvider());
 }
  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/accueil', page: Accueil.page, initial:true),
    //AutoRoute(path: '/administrateur', page: Administrateur.page),
    AutoRoute(path: '/connexion', page: Connexion.page),//, guards:[this.authGard]),
    AutoRoute(path: '/administrateur', page: Administrateur.page),//,guards:[this.authGard])
    AutoRoute(path: '/employé', page: Employe.page), //,guards:[this.authGard]
    AutoRoute(path: '/contact', page: Contact.page),
    AutoRoute(path: '/credits', page: Credits.page),
  ];

}


