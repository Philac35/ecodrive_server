

import 'dart:convert';

import 'package:angel3_orm/src/query.dart';
import 'package:angel3_orm/src/query_executor.dart';
import 'package:angel3_orm/src/query_where.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_package/BDD/Connection/MysqlConnection.dart';
import 'package:shared_package/BDD/Executor/MysqlPoolExecutor.dart';
import 'package:shared_package/Library/StringLibrary/string_librairy.dart';
import 'package:shared_package/Modules/Authentication/Repository/Abstract/AbstractRepository.dart';
import 'package:shared_package/Services/Parser/ParserJson.dart';

import '../../../BDD/Model/Abstract/PersonEntity.dart';
import '../../../BDD/Model/AbstractModels/Modules/Authentication/Entities/AuthUserEntity.dart' as a;
import '../../../BDD/Model/Index/Entity_Index.dart';
import '../../../Repository/Repository.dart';
//import '../Entities/AuthUser.dart' as a;

class AuthUserRepository  extends AbstractRepository<a.AuthUser>
    implements Repository<a.AuthUser>{

MySQLConnection? connexion;
MySQLConnectionPool? connexionPool;


  AuthUserRepository({this.connexionPool, this.connexion});




  @override
  Future<List<a.AuthUser?>?> findAll() async{
   List <a.AuthUser?> result =[];
    IResultSet? res= await  connexionPool?.execute("SELECT * from auth_users ;");

   return parseResultSet(res!);

  }

  @override
  Future<List<a.AuthUser?>?> findBy(Map<String, dynamic> parameters) async{

    //you must set parameters as string in where clause
   IResultSet? res= await query("SELECT * FROM auth_users ${whereClause(parameters)}",parameters);
   return parseResultSet(res!);
  
  }



  @override
  Future<a.AuthUser?> findById(int id) async{
    List <a.AuthUser?> result =[];
    IResultSet? res= await  connexionPool?.execute("SELECT * FROM auth_users WHERE id=$id ;");
    return parseResultSet(res!).first;
  }

  @override
  Future<a.AuthUser?> findLast() async {
    IResultSet? res= await  connexionPool?.execute("SELECT * FROM auth_users ORDER BY id DESC LIMIT 1;");
    return parseResultSet(res!).first;

  }

  @override
  Future<int> getLastId() async{
    List <a.AuthUser?> result =[];
    IResultSet? res= await  connexionPool?.execute("SELECT * FROM auth_users ORDER BY id DESC LIMIT 1 ;");
    print('ORM L70 $res');
    return   int.parse( parseResultSet(res!).first!.id!);

  }

  @override
  Future queries(List<String> queries) {
    throw UnimplementedError();
  //TODO Check if type retour match with Futur <int>
  }

  @override

  Future<IResultSet> query(String query,Map<String, dynamic>? substitutionValues) {

    //Substitution system : Change @parameter -> ?
    for (var name in substitutionValues!.keys) {
      query = query.replaceAll('@$name', ':$name');

      // Convert UTC time to local time
      var value = substitutionValues[name];

      //Utilistation du system temporel local
      if (value is DateTime && value.isUtc) {
        var t = value.toLocal();

        substitutionValues[name] = t;
      }
    }
    return this.connexion!.execute(query,substitutionValues);
  }


  @override
  Future<a.AuthUser?>persist(a.AuthUser? entity) async{


    List <a.AuthUser?> result =[];
    DateTime createdDate=DateTime.now();


    if(connexionPool!=null){print('AuthUserRepository L112 : using PoolConnexion $connexionPool');}
    else if (connexion!=null) {print('AuthUserRepository L113 : using PoolConnexion $connexionPool');}
    else{print('AuthUserRepository L114 : No connexion neither MysqlConnection nor PoolConnection ');}



    String query= "INSERT INTO auth_users (created_at, updated_at, identifiant, password,role, person_id) VALUES ( :createdAt, :updatedAt, :identifiant, :password,:role, :personId );";

    print("AuthUserRepository L118 : "+query);




    Map<String, dynamic>? parameters= entity?.toJson();
    parameters?.addAll({'createdAt':createdDate,'updatedAt':createdDate});
    if (parameters != null && parameters['role'] is List) {
      //Else we have a list as required in the System whereas we need json in mysql
      parameters['role'] = jsonEncode(parameters['role']);
    }


    print("AuthUserRepository L119 : $parameters");

    //As Insert return nothing we need to send a new request to get last Tuple
    IResultSet? res=await connexionPool?.execute(query,parameters!);
    return await getLastJustSavedEntry(res!);
  }


  @override
  Future<bool> delete({ int? id,a.AuthUser? entity})async {
    bool ret =false;
    var res;
    if(id!=null){
        res= connexionPool?.execute("DELETE FROM auth_users WHERE id=$id ;");

     }else if(entity!=null){
        res= connexionPool?.execute("DELETE FROM auth_users ${whereClause(entity.toJson())}");
    }

    return res!=null? true:false;

  }

  @override
    Future<dynamic>update({required Map<String,dynamic> parameters,Map<String,dynamic>? whereClause}) async{
    //checkConnection()
    Map<String,dynamic> paramSnakeCase=StringLib().camelToSnakeKeyFromMap(parameters) as  Map<String,dynamic> ;

    if( paramSnakeCase['role']!=null){ paramSnakeCase['role']= jsonEncode(paramSnakeCase['role']);}
    var entries = paramSnakeCase.entries;
    var whereclauseentries= whereClause?.entries;

    String? whereClauseStr= whereclauseentries?.map((e) =>"${e.key} = :${e.key}").join("AND");
    String updateStr= entries.map((e)=> "${e.key} = :${e.key}").join(",");
    String query="UPDATE auth_users SET ${updateStr} WHERE ${whereClauseStr !=null?whereClauseStr:""};";

    var res= connexionPool?.execute(query,  paramSnakeCase);

  }


//Helper
  /**
   * Function  getLastJustSavedEntry
   * @Param IResultSet
   * @Return Future<AuthUser?>
   */
  Future<a.AuthUser?> getLastJustSavedEntry(IResultSet  res) async {
    final insertId = res.lastInsertID;

    final row = await connexionPool?.execute(
        'SELECT * FROM auth_users WHERE id = :id',
        {"id":insertId}
    );

    a.AuthUser? entityRet=  parseResultSet(row!)?.first;
    return entityRet;

  }

  /**
   * Function  parseResultSet
   * @Param IResultSet
   * @Return List <a.AuthUser?>
   */
List <a.AuthUser?> parseResultSet(IResultSet res){
  List <a.AuthUser?> result =[];
  try {
    res?.rows.forEach((row){
      final roleList = jsonDecode(row.colByName('role')!) as List<dynamic>;
      result.add(a.AuthUser(id:row.colByName('id') ,
          createdAt: DateTime.parse(row.colByName('created_at')!) ,
          updatedAt: DateTime.parse(row.colByName('updated_at')!),
          identifiant:row.colByName('identifiant'),
          password: row.colByName('password'),
          role:  roleList?.map((e) => e.toString()).toList(),
          personId:  row.colByName('person_id')!=null? int.parse(row.colByName('person_id')!):null));
    });
  }catch(e, stack){print("AuthRepository, Error: $e");
  print("StackTrace:$stack");
  }
  return result;
}

  /**
   * Function  whereClause
   * @Param Map<String, dynamic>  parameters
   * @Return String
   */
  String whereClause(Map<String, dynamic>  parameters){
    if (parameters.isEmpty) return "";
    return "WHERE ${parameters.keys.map((key) => "$key = :$key").join(" AND ")}";
  }

  @override
  Repository<a.AuthUser>? repository;

  @override
  a.AuthUser? entity;


//Functions from  Repository<a.AuthUser>
  @override
  void addWhereRawForAllParams(Query<dynamic, QueryWhere> query) {
    // TODO: implement addWhereRawForAllParams
  }

  @override
  checkConnection() {
    // TODO: implement checkConnection
    throw UnimplementedError();
  }

  @override
  String escapeSqlString(String s) {
    // TODO: implement escapeSqlString
    throw UnimplementedError();
  }


  @override
  // TODO: implement fromJson
  a.AuthUser Function(Map<String, dynamic> p1) get fromJson => throw UnimplementedError();

  @override
  a.AuthUser? parseRow(insertedRow) {
    // TODO: implement parseRow
    throw UnimplementedError();
  }

  @override
  Future<bool> persistBool(a.AuthUser? entity) {
    // TODO: implement persistBool
    throw UnimplementedError();
  }

  @override
  // TODO: implement queryFactory
  Function() get queryFactory => throw UnimplementedError();

  @override
  String rawSql(param) {
    // TODO: implement rawSql
    throw UnimplementedError();
  }

  @override
  QueryExecutor? executor;



}

