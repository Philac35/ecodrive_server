import 'dart:async';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:ecodrive_server/src/BDD/Interface/ConnectionInterface.dart';

import '../Interface/ExecutorInterface.dart';


/**
 * Class SQLExcutor
 *
 *  Used when i didn't know there was orm_mysql intern MysqlExecutor class
 *
 * /!\ Blob and timestamp not supported. We must use datetime
 *     UTC datetime not supported
 */
class SQLExecutor extends QueryExecutor {
  ConnectionInterface connexion;
  SQLExecutor({required this.connexion});
  final Dialect _dialect =MySQLDialect() ;

  @override
  Future<List<List>> query(
          String tableName,
          String query,
          Map<String, dynamic> substitutionValues,
          {String returningQuery = '',
            String resultQuery = '',
           List<String> returningFields = const []}
      ) async {
          print('SQLExecutor received query: $query and values: $substitutionValues');


         var now = DateTime.now();
          var res= await connexion.connexion.execute(query,substitutionValues);
          return  res as List<List<dynamic>>;
  }



  /*
   * Function transaction
   * transaction are usual sql query,
   * You can send a set of queries as if it was 1.
   * they enforce ACID properties (atomicity, consistency, isolation, durability)
   */
  @override
    Future<T> transaction<T>(FutureOr<T> Function(QueryExecutor) f) {
    throw UnsupportedError('Transactions are not supported.');
  }



  @override
  Dialect get dialect => _dialect;
}