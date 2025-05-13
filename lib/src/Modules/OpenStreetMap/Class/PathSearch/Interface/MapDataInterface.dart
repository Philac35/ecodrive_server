import 'NodeInterface.dart';

abstract interface class MapDataInterface{


  Future<List<NodeInterface>> fetchMapData({Duration timeout = const Duration(seconds: 5)}) ;

}