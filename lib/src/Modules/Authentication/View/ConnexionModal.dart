import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Form/Connexion/ConnexionForm.dart';

//The page
class ConnexionModal extends StatefulWidget implements AutoRouteWrapper {
  const ConnexionModal({Key? key}) : super(key: key);

  static AutoRoutePage<dynamic> page(RouteData routeData) {
    return AutoRoutePage(
      routeData: routeData,
      child: ConnexionModal(),
    );
  }

  @override
  State<ConnexionModal> createState() => _ConnexionModalState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}

class _ConnexionModalState extends State<ConnexionModal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Connexion"),
      content: SingleChildScrollView(child: ConnexionForm()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
