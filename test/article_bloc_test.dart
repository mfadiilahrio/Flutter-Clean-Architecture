import 'package:celebrities/data/common/resource.dart';
import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/domain/usecases/get_articles_usecase.dart';
import 'package:celebrities/presentation/article/bloc/article_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'article_bloc_test.mocks.dart';

@GenerateMocks([GetArticlesUseCase])
void main() {
  late ArticleBloc bloc;
  late MockGetArticles mockGetArticles;

  setUp(() {
    mockGetArticles = MockGetArticles();
    bloc = ArticleBloc(getArticles: mockGetArticles);
  });

  final tArticle = Article(
    id: '1',
    title: 'Test Title',
    content: 'Test Content',
    contentThumbnail: 'http://test.com/thumbnail.jpg',
    contributorName: 'Contributor',
    createdAt: '2021-06-01T12:00:00Z',
    slideshow: ['http://test.com/slide1.jpg'],
  );

  final tArticleList = [tArticle];

  test('initial state should be Resource.loading()', () {
    expectLater(bloc.articlesStream, emits(Resource.loading()));
  });

  test('should emit [Resource.loading, Resource.success] when data is gotten successfully', () async {
    // arrange
    when(mockGetArticles.execute()).thenAnswer((_) => Stream.fromIterable([
      Resource.loading(),
      Resource.success(tArticleList)
    ]));

    // assert later
    final expected = [
      Resource.loading(), // Initial state is loading
      Resource.success(tArticleList), // Then it emits the list of articles
    ];
    expectLater(bloc.articlesStream, emitsInOrder(expected));

    // act
    await bloc.fetchArticles();
  });

  test('should emit [Resource.loading, Resource.error] when getting data fails', () async {
    // arrange
    when(mockGetArticles.execute()).thenAnswer((_) => Stream.fromIterable([
      Resource.loading(),
      Resource.error('Server Failure')
    ]));

    // assert later
    final expected = [
      Resource.loading(), // Initial state is loading
      Resource.error('Server Failure'), // Then it emits the error
    ];
    expectLater(bloc.articlesStream, emitsInOrder(expected));

    // act
    await bloc.fetchArticles();
  });

  tearDown(() {
    bloc.dispose();
  });
}