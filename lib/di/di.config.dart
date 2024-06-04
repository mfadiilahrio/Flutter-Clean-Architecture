// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'package:celebrities/config.dart' as _i8;
import 'package:celebrities/core/network/api_client.dart' as _i3;
import 'package:celebrities/data/repositories/article_repository_impl.dart' as _i5;
import 'package:celebrities/domain/repositories/article_repository.dart' as _i4;
import 'package:celebrities/domain/usecases/get_articles.dart' as _i6;
import 'package:celebrities/presentation/bloc/article_bloc.dart'
    as _i7; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<String>(
    () => registerModule.baseUrl,
    instanceName: 'baseUrl',
  );
  gh.factory<_i3.ApiClient>(
      () => _i3.ApiClient(get<String>(instanceName: 'baseUrl')));
  gh.factory<_i4.ArticleRepository>(
      () => _i5.ArticleRepositoryImpl(apiClient: get<_i3.ApiClient>()));
  gh.factory<_i6.GetArticles>(
      () => _i6.GetArticles(get<_i4.ArticleRepository>()));
  gh.factory<_i7.ArticleBloc>(
      () => _i7.ArticleBloc(getArticles: get<_i6.GetArticles>()));
  return get;
}

class _$RegisterModule extends _i8.RegisterModule {}
