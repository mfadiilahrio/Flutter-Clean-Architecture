import 'package:celebrities/core/network/api_client.dart';
import 'package:celebrities/core/network/article_api.dart';
import 'package:celebrities/data/common/resource.dart';
import 'package:celebrities/data/local/db/database_helper.dart';
import 'package:celebrities/data/models/article_model.dart';
import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/domain/repositories/article_repository.dart';
import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'dart:io';

@Injectable(as: ArticleRepository)
class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleApi api;
  final Logger _logger = Logger();
  final DatabaseHelper databaseHelper = DatabaseHelper();

  ArticleRepositoryImpl({required this.api});

  @override
  Stream<Resource<List<Article>>> getArticles() async* {
    yield Resource.loading();

    _logger.i('Fetching articles from local database');
    try {
      List<Article> localArticles = (await databaseHelper.getArticles()).map((article) => article.toEntity()).toList();
      yield Resource.success(localArticles);
    } catch (e) {
      _logger.e('Failed to fetch articles from local database', e);
      yield Resource.error('Failed to fetch articles from local database', responseCode: 500);
    }

    try {
      _logger.i('Fetching articles from API');
      List<dynamic> remoteArticles = await api.getArticles();
      List<Article> articles = remoteArticles.map((article) => ArticleModel.fromJson(article).toEntity()).toList();

      await databaseHelper.deleteAllArticles();
      for (var article in articles) {
        await databaseHelper.insertArticle(ArticleModel.fromEntity(article));
      }

      yield Resource.success(articles);
    } catch (e) {
      _logger.e('Failed to fetch articles from API', e);
      if (e is SocketException) {
        // Return data from local database when there is no internet connection
        try {
          _logger.i('Returning articles from local database due to no internet connection');
          List<Article> localArticles = (await databaseHelper.getArticles()).map((article) => article.toEntity()).toList();
          yield Resource.success(localArticles);
        } catch (e) {
          yield Resource.error('No Internet connection and failed to fetch local data', responseCode: 503);
        }
      } else if (e is HttpException) {
        yield Resource.error('Failed to fetch data', responseCode: 500);
      } else {
        yield Resource.error('Unexpected error occurred', responseCode: 500);
      }
    }
  }
}