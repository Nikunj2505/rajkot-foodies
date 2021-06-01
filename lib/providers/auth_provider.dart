import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

// --------------------- Google Sign in ----------------------------------------
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
  ]);

  Future<bool> doSignInWithGoogle() async {
    try {
      final googleSignInAcc = await _googleSignIn.signIn();
      if (googleSignInAcc != null) {
        debugPrint(googleSignInAcc.id);
        debugPrint(googleSignInAcc.email);
        debugPrint(googleSignInAcc.displayName);
        debugPrint(googleSignInAcc.photoUrl);
        final auth = await googleSignInAcc.authentication;
        debugPrint(auth.idToken);
        debugPrint(auth.accessToken);

        // save info to preferences
        _idToken = googleSignInAcc.id;
        _userId = googleSignInAcc.id;
        _emailAddress = googleSignInAcc.email;
        // adding 1 day as expiration time..
        // this can be change as per requirement
        _expiredAt = DateTime.now().add(
          Duration(seconds: (24 * 60)),
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

        return true;
      }
    } catch (error) {
      print(error);
      return false;
    }
    return false;
  }

  Future<GoogleSignInAccount?> doSignOutWithGoogle() async {
    return await _googleSignIn.signOut();
  }

  // ---------------------------------------------------------------------------

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
