import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/domain/usecases/get_articles.dart';
import 'package:celebrities/presentation/article/bloc/article_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'article_bloc_test.mocks.dart';

@GenerateMocks([GetArticles])
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

  test('initial state should be empty list', () {
    expect(bloc.articlesStream, emits([]));
  });

  test('should emit [articles] when data is gotten successfully', () async {
    // arrange
    when(mockGetArticles.execute())
        .thenAnswer((_) => Stream.value(tArticleList));

    // assert later
    final expected = [
      [], // Initial state is an empty list
      tArticleList, // Then it emits the list of articles
    ];
    expect(bloc.articlesStream, emitsInOrder(expected));

    // act
    await bloc.fetchArticles();
  });

  test('should emit [error] when getting data fails', () async {
    // arrange
    when(mockGetArticles.execute()).thenAnswer((_) => Stream.error('Server Failure'));

    // assert later
    final expected = [
      [], // Initial state is an empty list
      emitsError('Server Failure'),
    ];
    expect(bloc.articlesStream, emitsInOrder(expected));

    // act
    await bloc.fetchArticles();
  });

  tearDown(() {
    bloc.dispose();
  });
}