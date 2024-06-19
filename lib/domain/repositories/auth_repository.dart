import 'package:celebrities/data/common/Resource.dart';

abstract class UserRepository {
  Stream<Resource<String>> login({
    required String phoneNumber,
    required String password,
  });
}