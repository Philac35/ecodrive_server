import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../ConnexionModal.dart';
import '../Modal/ModalBuilder/CustomModalRouteBuilder.dart';

// ✅ Page Definition
@RoutePage()  // Mandatory annotation
class ConnexionModalPage extends StatelessWidget {
  const ConnexionModalPage({super.key});  // Remove child parameter

  @override
  Widget build(BuildContext context) {
    return const ConnexionModal();  // Your actual modal content
  }
}
/*
class ConnexionModalPage extends Page<void> implements AutoRouteWrapper,PageInfo  {
Widget? child;
ConnexionModalPage(child);

  @override
  Widget wrappedRoute(BuildContext context) {
    return child!;
  }


  @override
  String get name => 'ConnexionModal';

  @override
  AutoRoutePageBuilder get builder => (data) {
    return ConnexionModal();
  };
  @override
  PageInfo copyWith({String? name, AutoRoutePageBuilder? builder}) {
    return ConnexionModalPage(child);
  }

  @override
  Route<void> createRoute(BuildContext context) {
    return CustomModalRouteBuilder<void>(
      routeName: 'ConnexionModal',
      arguments: '', // You can pass any arguments you need here
    ).buildRoute(context, child!);
  }
}

 */