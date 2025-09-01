
import '../../../../Repository/Repository.dart';
import '../../Entities/AuthUserEntity.dart';
//import '../../Entities/AuthUser.dart';
import '../AuthUserRepository.dart';
import "package:shared_package/BDD/Model/AbstractModels/Modules/Authentication/Entities/AuthUserEntity.dart" as a;

abstract class  AbstractRepository<T extends a.AuthUser>{

Repository <T>?  repository;



// Fetch entities Functions

Future<T?> findById(int id);
Future<List<T?>?> findAll();
Future<List<T?>?> findBy(Map<String, dynamic> parameters);
Future<T?> findLast();
Future<int> getLastId();
Future<dynamic> query(String query,Map<String, dynamic>? substitutionValues);
Future<dynamic> queries(List<String> queries);
Future<a.AuthUser?> persist(T? entity);
Future<bool> delete({int? id,a.AuthUser? entity});
Future<dynamic>update({required Map<String,dynamic> parameters,Map<String,dynamic>? whereClause}) ;


}
