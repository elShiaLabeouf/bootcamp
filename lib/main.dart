import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:word_vault/common/constants.dart';
import 'package:word_vault/helpers/utility.dart';
import 'package:word_vault/pages/app.dart';
// import 'package:word_vault/pages/app_lock_page.dart';
// import 'package:word_vault/pages/introduction_page.dart';
import 'package:word_vault/common/theme.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

import 'helpers/globals.dart' as globals;

late SharedPreferences prefs;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Phoenix(
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;
  int themeID = 3;

  @override
  void initState() {
    getprefs();
    super.initState();
  }

  getprefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getInt('themeMode') != null) {
        switch (prefs.getInt('themeMode')) {
          case 0:
            themeMode = ThemeMode.light;
            break;
          case 1:
            themeMode = ThemeMode.dark;
            break;
          case 2:
            themeMode = ThemeMode.system;
            break;
          default:
            themeMode = ThemeMode.system;
            break;
        }
      } else {
        themeMode = ThemeMode.system;
        prefs.setInt('themeMode', 2);
      }
      globals.themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: theme(),
      darkTheme: themeDark(),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool newUser = true;

  getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      newUser = prefs.getBool('newUser') ?? true;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => WordVaultApp()),
          (Route<dynamic> route) => false);
    });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
