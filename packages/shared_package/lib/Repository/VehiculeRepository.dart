import 'dart:convert';

import 'package:angel3_orm/src/query_executor.dart';
import 'package:mysql_client/src/mysql_client/pool.dart';

import 'Repository.dart';
import '../BDD/Model/AbstractModels/VehiculeEntity.dart'  ;
import 'package:optional/optional.dart';

//Nous créons des class Repository ssi les Entités ont des besoin spécifique d'accès en BDD.
class VehiculeRepository extends Repository<Vehicule>{


  VehiculeRepository({required super.fromJson,
    //required super.executor,
    required super.queryFactory, required super.entity, required super.connexion, required super.executor, required super.connexionPool});


@override
  Future<Vehicule?> persist(Vehicule? entity) async {
  print("L21 , I pass in VehiculeRepository");
  final query = queryFactory();
  query.values?.copyFrom(entity);
  var entityid=query.values.id;
  var preferences=query.values?.preferences;
  print('VehiculeRepository L26 ${preferences.runtimeType.toString()}');
  if(entityid.runtimeType== String ){int.parse(entityid);}


/*
  query.values.preferences = entity?.preferences == null
      ? null
      : jsonEncode(entity?.preferences);
*/

  if(connexionPool!=null){print('VehiculeRepository L36 : using PoolConnexion $connexionPool');}
  else if (connexion!=null) {print('VehiculeRepository L37 : using PoolConnexion $connexionPool');}
  else{print('VehiculeRepository L38 : No connexion neither MysqlConnection nor PoolConnection ');}


  print('VehiculeRepository L41: save input: $entity');

  Optional<Vehicule> insertedRow;
  try {
    insertedRow = await query.insert(executor!);
    if(insertedRow!=null){
      print('VehiculeRepository L49, debug:  type : ${insertedRow?.first!.runtimeType.toString()}, insertedRow :$insertedRow ');
    }
    else{print("Entity was not saved, insertRow is null");}
  }catch(e,stack){ print('VehiculeRepository L46, INSERT FAILED! error: $e');
  print('VehiculeRepository L46,  stack: $stack');
    return null;}



  return insertedRow.value;

  }



}