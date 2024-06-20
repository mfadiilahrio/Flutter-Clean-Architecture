import 'dart:async';
import 'package:celebrities/core/network/api_client.dart';
import 'package:celebrities/core/network/auth_api.dart';
import 'package:celebrities/data/common/resource.dart';
import 'package:celebrities/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final AuthApi api;

  UserRepositoryImpl(this.api);

  @override
  Stream<Resource<String>> login({
    required String phoneNumber,
    required String password,
  }) async* {
    yield Resource.loading();

    try {
      final data = await api.login(
        phoneNumber: phoneNumber,
        password: password,
        role: 'COURIER',
      );
      final token = data['token'];
      yield Resource.success(token);
    } catch (e) {
      yield Resource.error(e.toString());
    }
  }
}