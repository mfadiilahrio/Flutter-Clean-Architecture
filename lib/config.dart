import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @Named('baseUrl')
  String get baseUrl => 'https://60a4954bfbd48100179dc49d.mockapi.io/api/innocent';
}