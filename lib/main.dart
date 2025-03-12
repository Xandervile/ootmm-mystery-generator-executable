import 'package:flutter/material.dart';
import 'settings/settings.dart';
import 'generation/generation.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.setTitle("OoTMM Mystery Settings Generator");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OoTMM Mystery Generator',
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes:{
        '/': (context) => MyHomePage(title: 'OoTMM Generator'),
        '/settings': (context) => SettingsPage(),
        '/item_settings': (context) => ItemSettingsPage(),
        '/world_settings': (context) => WorldSettingsPage(),
        '/misc_settings': (context) => MiscSettingsPage()
      }
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
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 70,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
                child: Text(
                  'Settings List',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20, 
                  ),
                )
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Generator'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Main Settings'),
              onTap: () {
                // Update the state of the app
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/settings'); // Navigates to SettingsPage
              },
            ),
            ListTile(
              leading: Icon(Icons.radar),
              title: Text('Item Settings'),
              onTap: () {
                // Update the state of the app
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/item_settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.house),
              title: Text('World Settings'),
              onTap: () {   
                Navigator.pop(context);
                Navigator.pushNamed(context, '/world_settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.face),
              title: Text('Misc. Settings'),
              onTap: () {
                // Update the state of the app
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/misc_settings');
              },
            ),
          ]
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 100,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
          generateSettings();},
          tooltip: 'Generate Settings',
          child: Text('Generate'),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// call using Map<String, int> generalWeights = await getItemWeights();