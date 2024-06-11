import 'package:celebrities/data/common/Resource.dart';
import 'package:celebrities/domain/entities/article.dart';

abstract class ArticleRepository {
  Stream<Resource<List<Article>>> getArticles();
}