import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../helper/custom_http_exception.dart';
import '../providers/auth_provider.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _email;
  String? _password;
  bool _isLoading = false;
  bool _isSignIn = true;
  static const String _TXT_LOGIN = 'Login';
  static const String _TXT_REGISTER = 'Register';

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      backgroundColor: Colors.black45,
      fontSize: 20,
    );
  }

  Future<void> _signInWithGoogle() async {
    final isLoggedIn = await Provider.of<AuthProvider>(context, listen: false)
        .doSignInWithGoogle();
    if (isLoggedIn) {
      _showToastMessage('You are logged in successfully!');
    } else {
      _showToastMessage('Sorry, Something went wrong!');
    }
  }

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    if (_email == null || _password == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isSignIn) {
        await Provider.of<AuthProvider>(context, listen: false)
            .doSignIn(_email!, _password!);
        _showToastMessage('You are logged in successfully!');
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
            .doSignUp(_email!, _password!);
        _showToastMessage('You are now registered!');
      }
    } on CustomHttpException catch (error) {
      var message = 'Not able to logged in!';
      if (error.toString().contains('EMAIL_NOT_FOUND')) {
        message = 'There is no user record corresponding to this identifier';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        message = 'The password is invalid or user does not have a password';
      } else if (error.toString().contains('USER_DISABLED')) {
        message = 'User account has been disabled by admin';
      } else if (error.toString().contains('EMAIL_EXISTS')) {
        message = 'This email is already in use';
      } else if (error.toString().contains('OPERATION_NOT_ALLOWED')) {
        message = 'Password sign-in is disabled for this project';
      } else if (error.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        message =
            'We have blocked all requests from this device due to unusual activity. Try again later';
      }
      _showToastMessage(message);
    } catch (error) {
      _showToastMessage('Not able to logged in, Please try again later!');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _TXT_REGISTER,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Switch(
                  activeColor: Colors.black,
                  value: _isSignIn,
                  onChanged: (value) {
                    setState(
                      () {
                        _isSignIn = value;
                      },
                    );
                  },
                ),
                Text(
                  _TXT_LOGIN,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 25,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: TextFormField(
                validator: (value) {
                  if ((value?.isEmpty ?? true) ||
                      !(value?.contains('@') ?? false)) {
                    return 'please enter valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontStyle: FontStyle.italic,
                ),
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  hintText: 'email',
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 25,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'password length must not be less than 6 char';
                  }
                  return null;
                },
                obscureText: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontStyle: FontStyle.italic,
                ),
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  hintText: 'password',
                  border: InputBorder.none,
                ),
                onSaved: (value) {
                  _password = value;
                },
              ),
            ),
            _isLoading
                ? Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    child: ElevatedButton(
                      child: Text(_isSignIn ? _TXT_LOGIN : _TXT_REGISTER),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 10,
                        ),
                        primary: Theme.of(context).primaryColor,
                        onPrimary: Colors.white,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: _authenticate,
                    ),
                  ),
            if (!_isLoading)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                child: ElevatedButton(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    children: [
                      Image.asset(
                        'assets/images/google_logo.png',
                        width: 30,
                        height: 30,
                        color: Colors.white,
                      ),
                      Text(
                        'Login with Google',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  onPressed: _signInWithGoogle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
