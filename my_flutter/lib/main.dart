import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ///
  /// shared preferences
  ///

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _readCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = counter;
    });
  }

  ///
  /// end of SharedPreferences
  ///

  int _counter = 00009;
  static const platform = const MethodChannel('changeTheme');

  Color colorPrimary;
  Color colorPrimaryDark;
  Color colorAccent;

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }

  @override
  void initState() {
    _getStyleColors();
  }

  Future<void> _getStyleColors() async {
    Map result;
    try {
      result = await platform.invokeMethod('getStyleColor');
      result.forEach((k, v) => print('${k}: ${v}'));
    } on PlatformException catch (e) {}

    setState(() {
      colorPrimaryDark = _getColorFromHex(result['colorPrimaryDark']);
      colorPrimary = _getColorFromHex(result['colorPrimary']);
      colorAccent = _getColorFromHex(result['colorAccent']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
        backgroundColor: colorPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
            ),
            Text(
              '$colorPrimaryDark',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorAccent,
        onPressed: () {
          _readCounter();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
