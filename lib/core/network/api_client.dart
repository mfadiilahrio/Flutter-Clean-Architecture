import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';

@injectable
class ApiClient {
  final String baseUrl;
  final Logger _logger = Logger();

  ApiClient(@Named('baseUrl') this.baseUrl);

  Future<List<dynamic>> getArticles() async {
    final response = await http.get(Uri.parse('$baseUrl/newsapp/articles'));
    _logger.i('GET $baseUrl/newsapp/articles');
    _logger.i('Response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load articles');
    }
  }
}