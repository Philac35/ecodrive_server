import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';

class AddDrivingLicenceFKMigration extends Migration {


@override
Future<void> up(Schema schema) async {

schema.alter('drivers', (table) {
  var photoRef = table.integer('photo_id').references('photos', 'id');
  photoRef.onDeleteCascade();
  table
      .declare('driver_id', ColumnType('int'))
      .references('f_angel_models', 'id');

});
}

@override
Future<void> down(Schema schema) async {
// If supported, drop foreign keys here or ignore.
}
}
