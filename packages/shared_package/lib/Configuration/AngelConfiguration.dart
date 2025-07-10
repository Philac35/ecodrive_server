
class AngelConfiguration{

/// Returns an Angel plug-in that connects to a database, and sets up a controller connected to it...
AngelConfigurer connectToCarsTable(QueryExecutor executor) {
  return (Angel app) async {

    // Register the connection with Angel's dependency injection system.
    // This means that we can use it as a parameter in routes and controllers.
    app.container.registerSingleton(executor);

    // Attach the controller we create below
    await app.mountController<CarController>();
  };
}




}
