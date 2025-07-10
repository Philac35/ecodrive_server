





import '../Entities/AuthUser.dart' as a;

class Repository<T extends a.AuthUser>  {

  Repository({Repository<T>? repository}) ;


  @override
  Future<T?> find() {
    // TODO: implement find
    throw UnimplementedError();
  }

  @override
  Future<List<T>> findAll() {
    throw UnimplementedError();

  }

  @override
  Future<List<T>> findBy(Map<String, dynamic> parameters) {
    throw UnimplementedError();
  
  }

  @override
  Future<T?> findById(int id) {
    throw UnimplementedError();
  
  }

  @override
  Future<T?> findLast() {
    throw UnimplementedError();
  
  }

  @override
  Future<int> getLastId() {
    throw UnimplementedError();
  //TODO Check if type retour match with Futur <int>
  }

  @override
  Future queries(List<String> queries) {
    throw UnimplementedError();
  //TODO Check if type retour match with Futur <int>
  }

  @override
  Future query(String query) {
    List<String> queries=[query];
   return this.queries(queries);
  }


  @override
  Future<bool>persist(T entity) {

    throw UnimplementedError();
  
  }

  @override
  Future<bool> delete({int? id, T? entity})async {
    bool exit =false;
    if(id!=null){
      throw UnimplementedError();
     }else if(entity!=null){
      throw UnimplementedError();

    }
    return exit;

  }

  @override
  Future<bool>update(T entity) {
    throw UnimplementedError();


  }


}

