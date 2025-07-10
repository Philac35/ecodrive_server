import 'Repository.dart';
import '../BDD/Model/AbstractModels/AddressEntity.dart'  ;


//Nous créons des class Repository ssi les Entités ont des besoin spécifique d'accès en BDD.
class AddressRepository extends Repository<Address>{


  AddressRepository({required super.fromJson, required super.executor,  required super.queryFactory, required super.entity});

  findOne(){
    AddressQuery().select(['address']);



  }


}