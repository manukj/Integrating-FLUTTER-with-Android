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

  int _counter = 00009;
  static const platform = const MethodChannel('changeTheme');

  Color colorPrimary;
  Color colorPrimaryDark;
  Color colorAccent;

  ///
  /// shared preferences
  ///

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _readStyleColorsFromSharedPrf() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      colorPrimaryDark = _getColorFromHex(prefs.getString("colorAccent"));
      colorPrimary = _getColorFromHex(prefs.getString("colorAccent"));
      colorAccent = _getColorFromHex(prefs.getString("colorPrimaryDark"));
    });
  }

  ///
  /// end of SharedPreferences
  ///


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
          _readStyleColorsFromSharedPrf();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
