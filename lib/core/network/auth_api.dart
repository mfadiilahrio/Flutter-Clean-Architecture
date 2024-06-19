import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:celebrities/data/local/shared_preferences_service.dart';
import 'api_client.dart';

@injectable
class AuthApi {
  final ApiClient _apiClient;
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  AuthApi(this._apiClient);

  Future<Map<String, dynamic>> login({
    required String phoneNumber,
    required String password,
    required String role,
  }) async {
    final response = await _apiClient.post(
      '/account/auth/login',
      {
        'phone_number': phoneNumber,
        'password': password,
        'role': role,
      },
      customBaseUrl: _apiClient.baseUrlV1,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      _sharedPreferencesService.token = token;
      return data;
    } else {
      throw Exception('Failed to login');
    }
  }
}