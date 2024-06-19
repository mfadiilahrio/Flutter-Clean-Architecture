// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i4;

import '../core/network/api_client.dart' as _i5;
import '../core/network/article_api.dart' as _i6;
import '../core/network/auth_api.dart' as _i9;
import '../data/repositories/article_repository_impl.dart' as _i8;
import '../data/repositories/user_repository_impl.dart' as _i12;
import '../domain/repositories/article_repository.dart' as _i7;
import '../domain/repositories/auth_repository.dart' as _i11;
import '../domain/usecases/get_articles_usecase.dart' as _i10;
import '../domain/usecases/login_usecase.dart' as _i14;
import '../presentation/article/bloc/article_bloc.dart' as _i13;
import '../presentation/login/bloc/login_bloc.dart' as _i15;
import '../presentation/login/pages/login_page.dart' as _i3;
import '../register_module.dart'
    as _i16; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i3.LoginPage>(() => _i3.LoginPage());
  await gh.factoryAsync<_i4.SharedPreferences>(
    () => registerModule.prefs,
    preResolve: true,
  );
  gh.factory<String>(
    () => registerModule.baseUrl,
    instanceName: 'baseUrl',
  );
  gh.factory<String>(
    () => registerModule.baseUrlV1,
    instanceName: 'baseUrlV1',
  );
  gh.factory<_i5.ApiClient>(() => _i5.ApiClient(
        baseUrl: get<String>(instanceName: 'baseUrl'),
        baseUrlV1: get<String>(instanceName: 'baseUrlV1'),
      ));
  gh.factory<_i6.ArticleApi>(() => _i6.ArticleApi(get<_i5.ApiClient>()));
  gh.factory<_i7.ArticleRepository>(
      () => _i8.ArticleRepositoryImpl(api: get<_i6.ArticleApi>()));
  gh.factory<_i9.AuthApi>(() => _i9.AuthApi(get<_i5.ApiClient>()));
  gh.factory<_i10.GetArticlesUseCase>(
      () => _i10.GetArticlesUseCase(get<_i7.ArticleRepository>()));
  gh.lazySingleton<_i11.UserRepository>(
      () => _i12.UserRepositoryImpl(get<_i9.AuthApi>()));
  gh.factory<_i13.ArticleBloc>(
      () => _i13.ArticleBloc(getArticles: get<_i10.GetArticlesUseCase>()));
  gh.factory<_i14.LoginUseCase>(
      () => _i14.LoginUseCase(get<_i11.UserRepository>()));
  gh.factory<_i15.LoginBloc>(
      () => _i15.LoginBloc(loginUseCase: get<_i14.LoginUseCase>()));
  return get;
}

class _$RegisterModule extends _i16.RegisterModule {}
