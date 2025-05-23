import 'package:angel3_migration/angel3_migration.dart';

//Not Conventional
import 'package:angel3_orm/angel3_orm.dart';
import 'package:ecodrive_server/src/BDD/MigrationRunner/RawSqlMixin.dart';
import 'package:mysql_client/mysql_client.dart';
//Not Conventional


class AddPersonFKMigration extends Migration with RawSqlMixin{

  //This is not conventional
  late final MySQLConnection _connection;

  AddPersonFKMigration(this._connection) {
    setConnection(_connection);
  }

  void setConnection(MySQLConnection connection) {
    _connection = connection;
  }


  @override
  Future<void> up(Schema schema) async {

     schema.alter('persons', (table) {
      table.integer('photo_id').references('photos', 'id').onDeleteCascade();
      table.integer('auth_user_id').references('auth_users', 'id').onDeleteCascade();
      table.integer('photo_id').references('photos', 'id').onDeleteCascade();
      table.integer('auth_user_id').references('auth_users', 'id').onDeleteCascade();

      print(schema.alter.runtimeType);
    });
  }

  @override
  Future<void> down(Schema schema) async {
    // If supported, drop foreign keys here or ignore.

   final result =await rawQuery('''SELECT
        CONSTRAINT_NAME,
        TABLE_NAME,
        COLUMN_NAME,
        REFERENCED_TABLE_NAME,
        REFERENCED_COLUMN_NAME
        FROM
        information_schema.KEY_COLUMN_USAGE
        WHERE
        TABLE_NAME = 'persons'
        AND REFERENCED_TABLE_NAME IS NOT NULL;''');
    for (var row in result) {
      var constraintName = row['CONSTRAINT_NAME'];
      await rawExecute('ALTER TABLE persons DROP FOREIGN KEY $constraintName');
    }

  }



}
