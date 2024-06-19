import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'di/di.dart';
import 'presentation/article/pages/article_page.dart';
import 'presentation/profile/pages/profile_page.dart';
import 'presentation/sync/pages/sync_page.dart';
import 'package:flutter/services.dart';

void main() {
  initializeDateFormatting('id_ID', null).then((_) {
    configureDependencies();
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  static const MaterialColor whiteSwatch = MaterialColor(
    _whitePrimaryValue,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(_whitePrimaryValue),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
  static const int _whitePrimaryValue = 0xFFFFFFFF;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Celebrities',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: whiteSwatch,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: whiteSwatch,
          brightness: Brightness.light,
        ).copyWith(
          secondary: Colors.pink,
          background: Colors.white,
          onBackground: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 4.0, // Shadow effect for light theme
          iconTheme: IconThemeData(color: Colors.black),
          shadowColor: Colors.grey.withOpacity(0.9)
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: whiteSwatch,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: whiteSwatch,
          brightness: Brightness.dark,
        ).copyWith(
          secondary: Colors.pink,
          background: Colors.black,
          onBackground: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 4.0, // Shadow effect for dark theme
          iconTheme: IconThemeData(color: Colors.white),
          shadowColor: Colors.grey.withOpacity(0.5)
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: ThemeMode.system, // Follow system theme
      home: HomePage(),
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