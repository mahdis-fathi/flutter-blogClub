import 'package:blogclub/article.dart';
import 'package:blogclub/gen/fonts.gen.dart';
import 'package:blogclub/home.dart';
import 'package:blogclub/profile.dart';
import 'package:blogclub/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff0D253C);
    const secondaryTextColor = Color(0xff2D4379);
    const primaryColor = Color(0xff376AED);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                textStyle: MaterialStateProperty.all(const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: FontFamily.avenir,
        )))),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          onPrimary: Colors.white,
          onSurface: primaryTextColor,
          onBackground: primaryTextColor,
          background: Color(0xffFBFCFF),
          surface: Colors.white,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          titleSpacing: 32,
          backgroundColor: Colors.white,
          foregroundColor: primaryTextColor,
        ),
        textTheme: const TextTheme(
            subtitle1: TextStyle(
                fontFamily: FontFamily.avenir,
                color: secondaryTextColor,
                fontWeight: FontWeight.w200,
                fontSize: 18),
            caption: TextStyle(
              fontFamily: FontFamily.avenir,
              fontWeight: FontWeight.w700,
              color: Color(0xff7B8BB2),
              fontSize: 10,
            ),
            subtitle2: TextStyle(
                fontFamily: FontFamily.avenir,
                color: primaryTextColor,
                fontWeight: FontWeight.w400,
                fontSize: 14),
            headline6: TextStyle(
                fontFamily: FontFamily.avenir,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: primaryTextColor),
            headline5: TextStyle(
              fontFamily: FontFamily.avenir,
              fontSize: 20,
              color: primaryTextColor,
              fontWeight: FontWeight.w700,
            ),
            headline4: TextStyle(
                fontFamily: FontFamily.avenir,
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: primaryTextColor),
            bodyText1: TextStyle(
                fontFamily: FontFamily.avenir,
                color: primaryTextColor,
                fontSize: 14),
            bodyText2: TextStyle(
                fontFamily: FontFamily.avenir,
                color: secondaryTextColor,
                fontSize: 12)),
      ),
      /* home: Stack(children: [
        const Positioned.fill(child: HomeScreen()),
        Positioned(bottom: 0, right: 0, left: 0, child: _BottomNavigation())
      ]),*/
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

const int homeIndex = 0;
const int articleIndex = 1;
const int searchIndex = 2;
const int menuIndex = 3;
const double bottomNavigationHeight = 65;

class _MainScreenState extends State<MainScreen> {
  int selectedScreenIndex = homeIndex;
  final List<int> _history = [];

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _articleKey = GlobalKey();
  final GlobalKey<NavigatorState> _searchKey = GlobalKey();
  final GlobalKey<NavigatorState> _menuKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    articleIndex: _articleKey,
    searchIndex: _searchKey,
    menuIndex: _menuKey,
  };

  Future<bool> _onWilPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWilPop,
      child: Scaffold(
        body: Stack(children: [
          Positioned.fill(
            bottom: bottomNavigationHeight,
            child: IndexedStack(
              index: selectedScreenIndex,
              children: [
                _navigator(_homeKey, homeIndex, const HomeScreen()),
                _navigator(_articleKey, articleIndex, const ArticleScreen()),
                _navigator(_searchKey, menuIndex, const SearchScreen(tabName: 'search',)),
                _navigator(_menuKey, menuIndex, const ProfileScreen()),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomNavigation(
              selectedIndex: selectedScreenIndex,
              onTap: (int index) {
                setState(() {
                  _history.remove(selectedScreenIndex);
                  _history.add(selectedScreenIndex);
                  selectedScreenIndex = index;
                });
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedScreenIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: ((settings) => MaterialPageRoute(
                builder: (context) => Offstage(
                    offstage: selectedScreenIndex != index, child: child))),
          );
  }
}


class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key, required this.tabName, this.screenNumber = 1}) : super(key: key);

  final String tabName;
  final int screenNumber;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'tab: $tabName, #$screenNumber',
          style: Theme.of(context).textTheme.headline4,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchScreen(tabName: tabName, screenNumber: screenNumber+1,)));
            },
            child: const Text('click me')),
      ]),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final Function(int index) onTap;
  final int selectedIndex;

  const _BottomNavigation(
      {Key? key, required this.onTap, required this.selectedIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: Stack(children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: const Color(0xff9B8487).withOpacity(0.3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BottomNavigationItem(
                  iconFileName: 'Home.png',
                  activeIconFileName: 'homeActive.png',
                  title: 'Home',
                  onTap: () {
                    onTap(homeIndex);
                  },
                  isActive: selectedIndex == homeIndex,
                ),
                BottomNavigationItem(
                  iconFileName: 'Articles.png',
                  activeIconFileName: 'ArticleActive.png',
                  title: 'Article',
                  onTap: () {
                    onTap(articleIndex);
                  },
                  isActive: selectedIndex == articleIndex,
                ),
                Expanded(child: Container()),
                BottomNavigationItem(
                  iconFileName: 'Search.png',
                  activeIconFileName: 'searchActive.png',
                  title: 'Search',
                  onTap: () {
                    onTap(searchIndex);
                  },
                  isActive: selectedIndex == searchIndex,
                ),
                BottomNavigationItem(
                  iconFileName: 'Menu.png',
                  activeIconFileName: 'menuActive.png',
                  title: 'Menu',
                  onTap: () {
                    onTap(menuIndex);
                  },
                  isActive: selectedIndex == menuIndex,
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Container(
            width: 65,
            height: 85,
            alignment: Alignment.topCenter,
            child: Container(
              height: bottomNavigationHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.5),
                color: const Color(0xff376AED),
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Image.asset('assets/img/icons/plus.png'),
            ),
          ),
        )
      ]),
    );
  }
}

class BottomNavigationItem extends StatelessWidget {
  final String iconFileName, activeIconFileName, title;
  final bool isActive;
  final Function() onTap;

  const BottomNavigationItem(
      {Key? key,
      required this.iconFileName,
      required this.activeIconFileName,
      required this.title,
      required this.onTap,
      required this.isActive})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/icons/${isActive ? activeIconFileName : iconFileName}',
              width: 24,
              height: 24,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              style: themeData.textTheme.caption!.apply(
                  color: isActive
                      ? themeData.colorScheme.primary
                      : themeData.textTheme.caption!.color),
            ),
          ],
        ),
      ),
    );
  }
}
