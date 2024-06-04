import 'package:celebrities/domain/entities/article.dart';

abstract class ArticleRepository {
  Stream<List<Article>> getArticles();
}