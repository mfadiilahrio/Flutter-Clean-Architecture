import 'package:celebrities/data/common/Resource.dart';
import 'package:celebrities/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final UserRepository repository;

  LoginUseCase(this.repository);

  Stream<Resource<String>> execute({
    required String phoneNumber,
    required String password,
  }) {
    return repository.login(
      phoneNumber: phoneNumber,
      password: password,
    );
  }
}