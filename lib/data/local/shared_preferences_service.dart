import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();
  late SharedPreferences _prefs;

  factory SharedPreferencesService() {
    return _instance;
  }

  SharedPreferencesService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token
  String get token => _prefs.getString('token') ?? '';
  set token(String value) => _prefs.setString('token', value);

  // Login status
  bool get isLoggedIn => _prefs.getBool('isLoggedIn') ?? false;
  set isLoggedIn(bool value) => _prefs.setBool('isLoggedIn', value);

  // Clear all preferences
  Future<void> clear() async {
    await _prefs.clear();
  }
}