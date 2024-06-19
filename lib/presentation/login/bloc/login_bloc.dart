import 'package:celebrities/data/common/Resource.dart';
import 'package:celebrities/domain/usecases/login_usecase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginBloc {
  final LoginUseCase loginUseCase;
  final _loginSubject = BehaviorSubject<Resource<String>>();

  Stream<Resource<String>> get loginStream => _loginSubject.stream;

  LoginBloc({required this.loginUseCase});

  void login({required String phoneNumber, required String password}) {
    loginUseCase.execute(phoneNumber: phoneNumber, password: password).listen((resource) {
      _loginSubject.add(resource);
    });
  }

  void dispose() {
    _loginSubject.close();
  }
}