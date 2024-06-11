import 'package:celebrities/data/common/Resource.dart';
import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/domain/repositories/article_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetArticles {
  final ArticleRepository repository;

  GetArticles(this.repository);

  Stream<Resource<List<Article>>> execute() {
    return repository.getArticles();
  }
}