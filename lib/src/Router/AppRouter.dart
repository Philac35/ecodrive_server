import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../Modules/Authentication/View/ConnexionModal.dart';
import '../Modules/Authentication/View/Modal/CustomModalRoute.dart';
//import '../Modules/Authentication/View/Modal/Route/ConnexionModalPage.dart';
import '../Modules/Authentication/View/Page/ConnexionModalPage.dart';
import '../Modules/Guard/AuthGuard.dart';
import '../Modules/Authentication/Provider/Listenable/AuthProvider.dart';

import './AppRouter.gr.dart';


import '../Modules/Authentication/View/Modal/ModalBuilder/ConnexionModalRouteBuilder.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
 late AuthGuard authGard;
 AppRouter(){
   this.authGard= AuthGuard(authProvider: AuthProvider());
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


