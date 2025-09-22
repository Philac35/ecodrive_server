


  import '../../Interface/entityInterface.dart';
  import '../../Model/AbstractModels/DriverEntity.dart';
  import '../../Model/AbstractModels/UserEntity.dart';
  import '../../Model/Index/Entity_Index.dart';
  import '../Relations/RelationMeta.dart';
  import 'Interface/TransformerAbstract.dart';

  class DriverToUserTransformer extends TransformerAbstract<Driver> {
    @override
    Map<String, dynamic>? extract(EntityInterface child, RelationMeta relation) {
      final driver = child as Driver;

      // Full Driver JSON
      final json = driver.toJson();

      // Lookup User’s field list from Entity_Index
      final fields = Entity_Index["User"]!['fields'] as List<String>;

      final res = <String, dynamic>{};

      for (final field in fields) {
        if (json.containsKey(field)) {
          res[field] = json[field];
        }
      }

      return res;
    }

    @override
    void attach(EntityInterface child, dynamic parent, RelationMeta relation) {
      final driver = child as Driver;
      driver.user = parent; // link in memory
    }
  }
