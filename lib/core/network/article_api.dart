import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'api_client.dart';

@injectable
class ArticleApi {
  final ApiClient _apiClient;

  ArticleApi(this._apiClient);

  Future<List<dynamic>> getArticles() async {
    final headers = await _apiClient.getHeaders();
    final response = await _apiClient.get('/newsapp/articles', headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load articles');
    }
  }
}