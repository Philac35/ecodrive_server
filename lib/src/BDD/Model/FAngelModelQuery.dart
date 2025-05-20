import 'package:angel3_orm/angel3_orm.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Administrator.dart';

import 'package:angel3_orm/angel3_orm.dart';
import 'package:optional/optional_internal.dart';

import 'Abstract/FAngelModel.dart';


 class FAngelModelQuery<T extends FAngelModel, W extends QueryWhere>
    extends Query<T, W> {


  Query? parent;
  Set<String>? trampoline;

  FAngelModelQuery({Set<String>? trampoline, Query? parent})
      : super( parent: parent);



  @override
  Optional<T> deserialize(List row) {
    // TODO: implement deserialize
    throw UnimplementedError();
  }

  @override
  // TODO: implement fields
  List<String> get fields => throw UnimplementedError();

  @override
  // TODO: implement tableName
  String get tableName => throw UnimplementedError();

  @override
  // TODO: implement values
  QueryValues? get values => throw UnimplementedError();

  @override
  // TODO: implement where
  get where => throw UnimplementedError();

  parseRow(List list) {}

// You can add custom query logic here if needed
}