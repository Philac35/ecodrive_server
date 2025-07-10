
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';


//Rotation of Map , reposition the map and map "camera" view
class MapRotation extends HookWidget {
  const MapRotation({
    super.key,
    required this.controller,
  });

  final MapController controller;

  get onPressed => onPressed;

  @override
  Widget build(BuildContext context) {
    final angle = useValueNotifier(0.0);
    return PointerInterceptor(

      child: FloatingActionButton(
        key: UniqueKey(),
        onPressed: () async {
          print ("I pressed MapRotation ");
          angle.value += 30;
          if (angle.value > 360) {
            angle.value = 0;
          }
          await controller.rotateMapCamera(angle.value);
        },
        heroTag: "RotationMapFab",
        elevation: 1,
        mini: true,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ValueListenableBuilder(
            valueListenable: angle,
            builder: (ctx, angle, child) {
              return AnimatedRotation(
                turns: angle == 0 ? 0 : 360 / angle,
                duration: const Duration(milliseconds: 250),
                child: child!,
              );
            },
            child: Image.asset("asset/compass.png"),
          ),
        ),
      ),
    );
  }
}
