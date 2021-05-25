import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodies/helper/custom_http_exception.dart';
import 'package:provider/provider.dart';

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

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    if (_email == null || _password == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .doSignIn(_email!, _password!);
      _showToastMessage('You are logged in successfully!');
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
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 25,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                border: Border.all(
                  color: Colors.deepPurple,
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
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.grey,
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
                color: Colors.deepPurpleAccent,
                border: Border.all(
                  color: Colors.deepPurple,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'please enter password';
                  }
                  return null;
                },
                obscureText: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.grey,
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
                ? CircularProgressIndicator()
                : Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: ElevatedButton(
                      child: Text('Sign In'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        primary: Colors.deepOrange,
                        onPrimary: Colors.white,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () => _signIn(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
