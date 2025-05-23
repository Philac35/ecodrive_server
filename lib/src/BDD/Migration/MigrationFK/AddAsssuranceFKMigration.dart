


import 'package:angel3_migration/angel3_migration.dart';
import 'package:angel3_orm/angel3_orm.dart';
class AddAssuranceFKMigration extends Migration {


@override
Future<void> up(Schema schema) async {

schema.alter('Assurances', (table) {
  var photoRef = table.integer('photo_id').references('photos', 'id');
  photoRef.onDeleteCascade();
  table
      .declare('vehicule_id', ColumnType('int'))
      .references('vehicules', 'id');

});
}

@override
Future<void> down(Schema schema) async {
// If supported, drop foreign keys here or ignore.
}
}
