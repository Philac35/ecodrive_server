import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:angel3_model/angel3_model.dart';

@serializable
abstract class FAngelModel extends Model {
  String? _id;
  // The int representation you want in your Dart code



  // Override id as String? for Angel, but bridge to intId
  @override
  String? get id => _id.toString();

  @override
  set id(String? value) {
    if (value == null) {
      _id = 0 as String?; // or handle as needed
    } else {
      _id = (int.tryParse(value) ?? 0) as String?;
    }
  }
}
