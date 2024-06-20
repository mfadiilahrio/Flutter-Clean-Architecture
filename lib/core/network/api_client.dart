import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import 'package:celebrities/data/local/shared_preferences_service.dart';
import 'package:celebrities/main.dart'; // Import the navigatorKey

@injectable
class ApiClient {
  final String baseUrl;
  final String baseUrlV1;
  final SharedPreferencesService _sharedPreferencesService;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  ApiClient({
    @Named('baseUrl') required this.baseUrl,
    @Named('baseUrlV1') required this.baseUrlV1,
  }) : _sharedPreferencesService = SharedPreferencesService();

  Future<http.Response> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers, String? customBaseUrl}) async {
    final url = '${customBaseUrl ?? baseUrl}$endpoint';
    final requestBody = jsonEncode(body);

    if (kDebugMode) {
      _logger.i('POST $url');
      _logger.i('Request Body: $requestBody');
    }

    final response = await http.post(
      Uri.parse(url),
      headers: headers ?? {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (kDebugMode) {
      _logResponse(response);
    }

    _checkUnauthorized(response);

    return response;
  }

  Future<http.Response> get(String endpoint, {Map<String, String>? headers, String? customBaseUrl}) async {
    final url = '${customBaseUrl ?? baseUrl}$endpoint';
    final response = await http.get(Uri.parse(url), headers: headers);

    if (kDebugMode) {
      _logger.i('GET $url');
      if (headers != null) _logger.i('Headers: $headers');
      _logResponse(response);
    }

    _checkUnauthorized(response);

    return response;
  }

  Map<String, String> getHeaders() {
    final token = _sharedPreferencesService.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  void _checkUnauthorized(http.Response response) {
    if (response.statusCode == 401) {
      _logout();
    }
  }

  Future<void> _logout() async {
    await _sharedPreferencesService.clear();
    // Navigate to the login page using navigatorKey
    navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  void _logResponse(http.Response response) {
    _logger.i('Response Status: ${response.statusCode}');
    _logger.i('Response Headers: ${response.headers}');
    _logLongString(response.body);
  }

  void _logLongString(String longString) {
    const int chunkSize = 2048;
    for (int i = 0; i < longString.length; i += chunkSize) {
      if (i + chunkSize < longString.length) {
        _logger.i(longString.substring(i, i + chunkSize));
      } else {
        _logger.i(longString.substring(i));
      }
    }
  }
}