import 'package:celebrities/core/network/api_client.dart';
import 'package:celebrities/data/local/database_helper.dart';
import 'package:celebrities/data/models/article_model.dart';
import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/domain/repositories/article_repository.dart';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ArticleRepository)
class ArticleRepositoryImpl implements ArticleRepository {
  final ApiClient apiClient;
  final Logger _logger = Logger();
  final DatabaseHelper databaseHelper = DatabaseHelper();

  ArticleRepositoryImpl({required this.apiClient});

  @override
  Stream<List<Article>> getArticles() async* {
    _logger.i('Fetching articles from local database');
    List<Article> localArticles = (await databaseHelper.getArticles()).map((article) => article.toEntity()).toList();
    yield localArticles;

    try {
      _logger.i('Fetching articles from API');
      List<dynamic> remoteArticles = await apiClient.getArticles();
      List<Article> articles = remoteArticles.map((article) => ArticleModel.fromJson(article).toEntity()).toList();

      await databaseHelper.deleteAllArticles();
      for (var article in articles) {
        await databaseHelper.insertArticle(ArticleModel.fromEntity(article));
      }

      yield articles;
    } catch (e) {
      _logger.e('Failed to fetch articles from API', e);
    }
  }
}