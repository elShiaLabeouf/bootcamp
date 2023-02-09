import 'package:animations/animations.dart';
import 'package:bootcamp/common/string_values.dart';
import 'package:bootcamp/common/constants.dart';
import 'package:bootcamp/pages/quizzes_page.dart';
import 'package:bootcamp/pages/home_page.dart';
import 'package:bootcamp/pages/archived_page.dart';
import 'package:bootcamp/pages/settings_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:bootcamp/helpers/globals.dart' as globals;
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:flutter/cupertino.dart';

enum ViewType { Tile, Grid }

class BootcampApp extends StatefulWidget {
  const BootcampApp({Key? key}) : super(key: key);

  @override
  _BootcampAppState createState() => _BootcampAppState();
}

class _BootcampAppState extends State<BootcampApp> {
  late SharedPreferences sharedPreferences;
  ViewType viewType = ViewType.Tile;
  bool isAppLogged = false;
  String appPin = "";
  bool openNav = false;

  bool isAndroid = UniversalPlatform.isAndroid;
  bool isIOS = UniversalPlatform.isIOS;
  bool isWeb = UniversalPlatform.isWeb;
  bool isDesktop = false;

  late PageController _pageController;
  int _page = 0;

  final _pageList = <Widget>[
    HomePage(title: kAppName),
    QuizzesPage(),
    ArchivedPage(),
    SettingsPage(),
  ];

  String username = '';

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      username = sharedPreferences.getString('nc_userdisplayname') ?? '';
      print(appPin);
    });
  }

  Future getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    getPref();
    getdata();
    _pageController = PageController();
  }

  Future<bool> onWillPop() async {
    if (_pageController.page!.round() == _pageController.initialPage) {
      sharedPreferences.setBool("is_app_unlocked", false);
      return true;
    } else {
      _pageController.jumpToPage(_pageController.initialPage);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = (globals.themeMode == ThemeMode.dark ||
        (brightness == Brightness.dark &&
            globals.themeMode == ThemeMode.system));
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: darkModeOn ? Colors.transparent : Colors.transparent,
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        systemNavBarStyle: FlexSystemNavBarStyle.background,
        useDivider: false,
        opacity: 0,
      ),
      child: WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            children: _pageList,
            onPageChanged: onPageChanged,
            controller: _pageController,
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedIconTheme:
                const IconThemeData(color: kBlack, opacity: 1.0, size: 30),
            unselectedIconTheme:
                const IconThemeData(color: kBlack, opacity: 0.5, size: 20),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Iconsax.book),
                label: kLabelNotes,
              ),
              BottomNavigationBarItem(
                icon: Icon(IcoFontIcons.brainAlt),
                label: kLabelArchive,
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.archivebox),
                label: kLabelSearch,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: kLabelMore,
              ),
            ],
            currentIndex: _page,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: navigationTapped,
          ),
        ),
      ),
    );
  }
}
