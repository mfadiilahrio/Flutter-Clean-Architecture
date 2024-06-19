import 'package:celebrities/data/local/shared_preferences_service.dart';
import 'package:celebrities/presentation/common/CustomButton.dart';
import 'package:celebrities/presentation/common/CustomTextFormField.dart';
import 'package:celebrities/presentation/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:celebrities/data/common/Resource.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final LoginBloc _loginBloc = GetIt.I<LoginBloc>();
  final SharedPreferencesService _sharedPrefs = GetIt.I<SharedPreferencesService>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loginBloc.loginStream.listen((resource) async {
      if (resource.status == Status.Success) {
        Fluttertoast.showToast(
          msg: "Login successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _sharedPrefs.isLoggedIn = true;
        Navigator.pushReplacementNamed(context, '/home');
      } else if (resource.status == Status.Error) {
        Fluttertoast.showToast(
          msg: "Login failed: ${resource.message}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      setState(() {
        _isLoading = resource.status == Status.Loading;
      });
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      String phoneNumber = _phoneController.text;
      if (!phoneNumber.startsWith('+62')) {
        phoneNumber = '+62$phoneNumber';
      }

      _loginBloc.login(
        phoneNumber: phoneNumber,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFormField(
                controller: _phoneController,
                labelText: 'Phone Number',
                type: TextFieldType.phone,
                validator: (value) {
                  if (value!.isEmpty || value == '+62') {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              CustomTextFormField(
                controller: _passwordController,
                labelText: 'Password',
                type: TextFieldType.password,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              CustomButton(
                text: 'Login',
                onPressed: _login,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}