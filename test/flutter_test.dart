import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/domain/repositories/article_repository.dart';
import 'package:celebrities/domain/usecases/get_articles.dart';
import 'package:celebrities/presentation/bloc/article_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Generate the mock class using build_runner
import 'article_bloc_test.dart';
@GenerateMocks([ArticleRepository])
import 'article_bloc_test.mocks.dart';

void main() {
  late ArticleBloc bloc;
  late MockArticleRepository mockArticleRepository;
  late GetArticles getArticles;

  setUp(() {
    mockArticleRepository = MockArticleRepository();
    getArticles = GetArticles(mockArticleRepository);
    bloc = ArticleBloc(getArticles: getArticles);
  });

  test('should fetch articles from the repository', () async {
    // arrange
    final articles = [Article(id: '1', title: 'Title', content: 'Content')];
    when(mockArticleRepository.getArticles()).thenAnswer((_) => Stream.value(articles));

    // act
    bloc.fetchArticles();

    // assert
    await expectLater(bloc.articlesStream, emitsInOrder([articles]));
  });

  test('should handle empty articles gracefully', () async {
    // arrange
    when(mockArticleRepository.getArticles()).thenAnswer((_) => Stream.value([]));

    // act
    bloc.fetchArticles();

    // assert
    await expectLater(bloc.articlesStream, emitsInOrder([[]]));
  });

  test('should handle error gracefully', () async {
    // arrange
    when(mockArticleRepository.getArticles()).thenAnswer((_) => Stream.error(Exception('Failed to fetch articles')));

    // act
    bloc.fetchArticles();

    // assert
    await expectLater(bloc.articlesStream, emitsError(isA<Exception>()));
  });
}