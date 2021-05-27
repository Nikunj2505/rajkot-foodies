import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/custom_http_exception.dart';

class AuthProvider with ChangeNotifier {
  String? _idToken;
  String? _userId;
  String? _emailAddress;
  DateTime? _expiredAt;

  bool isAuthenticated() {
    return token != null;
  }

  String? get token {
    if (_idToken != null &&
        _userId != null &&
        _expiredAt != null &&
        _expiredAt!.isAfter(DateTime.now())) {
      return _idToken;
    }
    return null;
  }

  static const _FIREBASE_WEB_API_KEY =
      'AIzaSyAbS0nIygXwMyRYXvk5AxWokLQeEFFAmTE';

  Future<void> doSignUp(String email, String password) async {
    final response = await http.post(
      Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_FIREBASE_WEB_API_KEY',
      ),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    try {
      if (response.statusCode == 200) {
        setAuthenticationResponse(response);
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] != null) {
          throw CustomHttpException(responseData['error']['message']);
        }
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> doSignIn(String email, String password) async {
    final response = await http.post(
      Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_FIREBASE_WEB_API_KEY',
      ),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    try {
      if (response.statusCode == 200) {
        debugPrint('$response');
        setAuthenticationResponse(response);
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        debugPrint('$error');
        throw CustomHttpException(error['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> setAuthenticationResponse(http.Response response) async {
    final res = jsonDecode(response.body);
    _idToken = res['idToken'];
    _userId = res['localId'];
    _emailAddress = res['email'];
    _expiredAt = DateTime.now().add(
      Duration(
        seconds: int.parse(res['expiresIn']),
      ),
    );
    notifyListeners();
    final preference = await SharedPreferences.getInstance();
    preference.setString(
      'userData',
      jsonEncode(
        {
          'token': _idToken!,
          'userId': _userId!,
          'email': _emailAddress!,
          'expiredAt': _expiredAt!.toIso8601String(),
        },
      ),
    );
  }

  Future<void> doLogout() async {
    _idToken = null;
    _userId = null;
    _expiredAt = null;
    final preference = await SharedPreferences.getInstance();
    // preference.remove('userData');
    preference.clear();
    notifyListeners();
  }

  Future<bool> checkForAutoLogin() async {
    final preference = await SharedPreferences.getInstance();
    if (!preference.containsKey('userData')) {
      return false;
    }
    final jsonString = preference.getString('userData');
    if (jsonString == null) return false;
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final date = DateTime.parse(data['expiredAt']);
    if (date.isBefore(DateTime.now())) {
      return false;
    }
    _idToken = data['token'];
    _userId = data['userId'];
    _expiredAt = date;
    notifyListeners();
    return true;
  }
}
