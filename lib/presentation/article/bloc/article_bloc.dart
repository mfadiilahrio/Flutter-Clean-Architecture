import 'package:celebrities/data/common/Resource.dart';
import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/domain/usecases/get_articles_usecase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleBloc {
  final GetArticlesUseCase getArticles;
  final _articlesSubject = BehaviorSubject<Resource<List<Article>>>.seeded(Resource.loading());

  Stream<Resource<List<Article>>> get articlesStream => _articlesSubject.stream;

  ArticleBloc({required this.getArticles});

  Future<void> fetchArticles() async {
    try {
      final articlesStream = getArticles.execute();
      await for (var resource in articlesStream) {
        _articlesSubject.add(resource);
      }
    } catch (e) {
      _articlesSubject.add(Resource.error(e.toString()));
    }
  }

  void dispose() {
    _articlesSubject.close();
  }
}