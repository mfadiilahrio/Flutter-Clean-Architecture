import 'package:celebrities/core/network/api_client.dart';
import 'package:celebrities/data/models/article_model.dart';
import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/domain/repositories/article_repository.dart';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ArticleRepository)
class ArticleRepositoryImpl implements ArticleRepository {
  final ApiClient apiClient;
  final Logger _logger = Logger();

  ArticleRepositoryImpl({required this.apiClient});

  @override
  Stream<List<Article>> getArticles() {
    _logger.i('Fetching articles from API');
    return Stream.fromFuture(apiClient.getArticles())
        .map((articles) {
      final articleList = articles.map((article) => ArticleModel.fromJson(article).toEntity()).toList();
      _logger.i('Fetched ${articleList.length} articles');
      return articleList;
    });
  }
}