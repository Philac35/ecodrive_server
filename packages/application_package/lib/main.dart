import 'package:application_package/src/Modules/Authentication/Provider/Listenable/AuthProvider.dart';
import 'package:application_package/src/Modules/Authentication/View/Form/Controller/AccountCreationController.dart';
import 'package:application_package/src/Modules/Authentication/View/Form/Controller/ConnexionFormController.dart';
import 'package:application_package/src/Modules/Authentication/View/Form/Controller/ControllerFormInterface.dart';
import 'package:application_package/src/Router/AppRouter.dart';
import 'package:application_package/src/Router/lib/src/Observer/NavigationObserver.dart';

import 'package:application_package/src/Views/Forms/Controler/ContactFormController.dart';
import 'package:application_package/src/Views/Graphisme/CustomColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AccountCreationController());
  debugPrint('AccountCreationController registered');

  Get.put(ConnexionFormController());//In Authentication form
  debugPrint('ConnexionFormController registered');
  Get.put(ControllerFormInterface);
  Get.put(ContactFormController());
  debugPrint('ContactFormController registered');
  runApp( MyApp());
}

class MyApp extends StatelessWidget {


  final ColorScheme colorScheme = ColorScheme.light(
    primary: Color(0xFF0051C1),
    secondary: Color(0xFFC3D0F0),
    tertiary: Color(0x00ffe86a),
  );
  final _appRouter = AppRouter(); //Router Autoroute


   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

      return MaterialApp.router(
        debugShowCheckedModeBanner: false,

        routerConfig: _appRouter.config(
          reevaluateListenable: AuthProvider(),
          navigatorObservers: () => [NavigationObserver()],
        ),
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: colorScheme,
        extensions: [
          CustomColors(quaternary: Color(0xFF123456)),
        ],
        useMaterial3: true,
      ),


    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
