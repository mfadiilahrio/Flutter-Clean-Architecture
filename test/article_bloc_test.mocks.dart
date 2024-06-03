// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
import 'dart:async' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:rxdart/rxdart.dart' as _i5;
import 'package:celebrities/domain/entities/article.dart' as _i2;
import 'package:celebrities/domain/repositories/article_repository.dart' as _i3;

// ignore_for_file: comment_references
class MockArticleRepository extends _i1.Mock implements _i3.ArticleRepository {
  MockArticleRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<List<_i2.Article>> getArticles() =>
      (super.noSuchMethod(Invocation.method(#getArticles, []),
          returnValue: Stream<List<_i2.Article>>.empty()) as _i4.Stream<List<_i2.Article>>);
}
