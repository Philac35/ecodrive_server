import 'package:flutter/material.dart';


//Here MainNavigation provide a way to add a drawer, a menu to navigate on the app
class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: UniqueKey(),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      heroTag: "MainMenuFab",
      mini: true,
      backgroundColor: Colors.white,
      child: const Icon(Icons.menu),
    );
  }

/*
  Future<void> _safeMoveTo(GeoPoint point) async {
    print("Attempting to move to $point");
    if (!_isMapReady) {
      print("Map is not ready yet, waiting...");
      await Future.doWhile(() => Future.delayed(Duration(milliseconds: 100))
          .then((_) => !_isMapReady));
    }
    print("Map is ready, moving to point");

    try {
      await mapController.moveTo(point, animate: true);
    } catch (e) {
      print("Error moving to position: $e");
    }
  }*/
}

