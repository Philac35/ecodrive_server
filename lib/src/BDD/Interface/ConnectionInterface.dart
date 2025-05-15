abstract interface class ConnectionInterface{

  get connexion;

  get log;
  loadConfiguration();
  Future<dynamic> connect({int? timeoutMs});

}