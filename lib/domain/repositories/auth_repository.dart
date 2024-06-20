import 'package:celebrities/data/common/resource.dart';

abstract class UserRepository {
  Stream<Resource<String>> login({
    required String phoneNumber,
    required String password,
  });
}