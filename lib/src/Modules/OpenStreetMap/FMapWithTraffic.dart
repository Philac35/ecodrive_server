
import 'package:ecodrive_server/src/Modules/Traffic/Component/MapWithTraffic.dart';
import 'package:flutter/cupertino.dart';


class FMapWithTraffic extends InheritedWidget{

  //Datex File that list traffic's events, Informations come from French State Services
  //TODO Uses differents files from differents sources
  //TODO Check redondant informations
  String file = "https://tipi.bison-fute.gouv.fr/bison-fute-ouvert/publicationsDIR/Evenementiel-DIR/grt/RRN/content.xml";


   FMapWithTraffic(  {
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);





  // Static method to access FMapWithTraffic instance in the widget tree
  static FMapWithTraffic? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FMapWithTraffic>();
  }


  static FMapWithTraffic of(BuildContext context) {
    final FMapWithTraffic? result = maybeOf(context);
    assert(result != null, 'No FirstComponent found in context');
    return result!;
  }


  @override
  bool updateShouldNotify(FMapWithTraffic oldWidget) => file != oldWidget.file;

}