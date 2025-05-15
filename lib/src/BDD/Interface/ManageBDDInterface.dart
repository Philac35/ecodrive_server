abstract interface class ManageBDDInterface{

  connect();
  execute({required String tableName, required String query,  Map<String, dynamic>? substitutionValues });



}