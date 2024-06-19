import 'package:celebrities/core/network/api_client.dart';
import 'package:celebrities/core/network/auth_api.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @Named('baseUrl')
  String get baseUrl => 'https://60a4954bfbd48100179dc49d.mockapi.io/api/innocent';

  @Named('baseUrlV1')
  String get baseUrlV1 => '';

  @injectable
  ApiClient provideApiClient(
      @Named('baseUrl') String baseUrl,
      @Named('baseUrlV1') String baseUrlV1,
      ) {
    return ApiClient(
      baseUrl: baseUrl,
      baseUrlV1: baseUrlV1,
    );
  }

  @injectable
  AuthApi provideAuthApi(ApiClient apiClient) {
    return AuthApi(apiClient);
  }
}
