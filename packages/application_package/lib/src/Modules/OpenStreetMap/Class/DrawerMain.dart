
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Add a Drawer/Menu to the map Component
class DrawerMain extends StatelessWidget {
  const DrawerMain({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (_) {
        Scaffold.of(context).closeDrawer();
      },
      child: Drawer(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.viewPaddingOf(context).top),
            ListTile(
              onTap: () {},
              title: const Text("search example"),
            ),
            ListTile(
              onTap: () {},
              title: const Text("map with hook example"),
            ),
            ListTile(
              onTap: () async {
                Scaffold.of(context).closeDrawer();
                await Navigator.pushNamed(context, '/old-home');
              },
              title: const Text("old home example"),
            )
          ],
        ),
      ),
    );
  }
}