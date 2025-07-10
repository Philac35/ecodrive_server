import 'package:angel3_migration/angel3_migration.dart';
import 'package:mysql_client/mysql_client.dart';


mixin RawSqlMixin on Migration{
  late MySQLConnection _connection;

  /// Sets the database connection
  void setConnection(MySQLConnection connection) {
    _connection = connection;
  }

  /// Executes a raw SQL query and returns the results
  Future<List<Map<String, dynamic>>> rawQuery(
      String query, {
        List<dynamic>? params,
      }) async {
    try {
      final results = await _connection.execute(query, params as Map<String, dynamic>?);
      return results.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      print('Error executing query: $e');
      rethrow;
    }
  }

  /// Executes a raw SQL command (INSERT, UPDATE, DELETE, etc.)
  Future<int?> rawExecute(
      String query, {
        List<dynamic>? params,
      }) async {
    try {
      final result = await _connection.execute(query, params as Map<String, dynamic>?);
      return result.affectedRows.toInt();  //Convert BigInt to Int
    } catch (e) {
      print('Error executing command: $e');
      rethrow;
    }
  }

  /// Closes the database connection
  Future<void> close() async {
    await _connection.close();

    }

  /// Checks if the connection is active
  bool get isConnected => _connection != null;
}
