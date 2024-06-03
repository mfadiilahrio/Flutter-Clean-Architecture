import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/domain/usecases/get_articles.dart';
import 'package:rxdart/rxdart.dart';

class ArticleBloc {
  final GetArticles getArticles;
  final _articlesSubject = BehaviorSubject<List<Article>>.seeded([]);

  Stream<List<Article>> get articlesStream => _articlesSubject.stream;

  ArticleBloc({required this.getArticles});

  Future<void> fetchArticles() async {
    try {
      final articlesStream = getArticles.execute();
      await for (var articles in articlesStream) {
        _articlesSubject.add(articles);
      }
    } catch (e) {
      _articlesSubject.addError(e);
    }
  }

  void dispose() {
    _articlesSubject.close();
  }
}
