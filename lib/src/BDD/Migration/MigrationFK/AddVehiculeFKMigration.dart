
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
class AddVehiculeFKMigration extends Migration {


  @override
  Future<void> up(Schema schema) async {

    schema.alter('Vehicules', (table) {
      // Add foreign keys for Address, Photo, and AuthUser with cascade delete  (after generation)
      table
          .declare('driver_id', ColumnType('int'))
          .references('f_angel_models', 'id');
      var assuranceRef = table.integer('assurance_id').references('assurances', 'id');
      assuranceRef.onDeleteCascade();
      table.declareColumn(
        'photo_list',
        Column(type: ColumnType('jsonb'), length: 255),
      );

    });
  }

  @override
  Future<void> down(Schema schema) async {
    // If supported, drop foreign keys here or ignore.
  }
}
