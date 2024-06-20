import 'package:celebrities/data/local/shared_preferences_service.dart';
import 'package:celebrities/data/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'di/di.dart';
import 'presentation/article/pages/article_page.dart';
import 'presentation/login/pages/login_page.dart';
import 'presentation/profile/pages/profile_page.dart';
import 'presentation/sync/pages/sync_page.dart';
import 'package:get_it/get_it.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await configureDependencies();

  final sharedPreferencesService = SharedPreferencesService();
  await sharedPreferencesService.init();
  GetIt.I.registerSingleton<SharedPreferencesService>(sharedPreferencesService);

  final isLoggedIn = sharedPreferencesService.isLoggedIn;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Celebrities',
      theme: buildLightTheme(),  // Use buildLightTheme
      darkTheme: buildDarkTheme(),  // Use buildDarkTheme
      themeMode: ThemeMode.system, // Follow system theme
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => getIt<LoginPage>(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ArticlePage(),
    SyncPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: 'Sync',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
      ),
    );
  }
}