
import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
class AddTravelFKMigration extends Migration {


  @override
  Future<void> up(Schema schema) async {

    schema.alter('Travel', (table) {
      table
          .declare('driver_id', ColumnType('int'))
          .references('f_angel_models', 'id');
      table
          .declare('itinerary_id', ColumnType('int'))
          .references('f_angel_models', 'id');
    });
  }

  @override
  Future<void> down(Schema schema) async {
    // If supported, drop foreign keys here or ignore.
  }
}
