import 'package:celebrities/data/common/resource.dart';
import 'package:celebrities/domain/entities/article.dart';

abstract class ArticleRepository {
  Stream<Resource<List<Article>>> getArticles();
}