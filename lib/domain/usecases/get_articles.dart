
import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/domain/repositories/article_repository.dart';

class GetArticles {
  final ArticleRepository repository;

  GetArticles(this.repository);

  Stream<List<Article>> execute() {
    return repository.getArticles();
  }
}
