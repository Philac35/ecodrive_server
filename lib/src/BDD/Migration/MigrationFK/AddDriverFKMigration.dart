


import 'package:angel3_migration/angel3_migration.dart';
class AddDriverFKMigration extends Migration {


  @override
  Future<void> up(Schema schema) async {

    schema.alter('drivers', (table) {
      var addressRef = table.integer('address_id').references('addresses', 'id');
      addressRef.onDeleteCascade();
      var photoRef = table.integer('photo_id').references('photos', 'id');
      photoRef.onDeleteCascade();
      var authUserRef = table.integer('auth_user_id').references('auth_users', 'id');
      authUserRef.onDeleteCascade();

    });
  }

  @override
  Future<void> down(Schema schema) async {
    // If supported, drop foreign keys here or ignore.
  }
}
