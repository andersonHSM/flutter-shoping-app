import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/data/sharedPreferences_store.dart';
import 'package:shopping_app/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expireDate;
  Timer _logoutTimer;

  String get token {
    if (_token != null &&
        _expireDate != null &&
        _expireDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  String get userId {
    return isAuthenticated ? _userId : null;
  }

  bool get isAuthenticated {
    return token != null;
  }

  static const _key = "AIzaSyCU01PcSPZLSKyxFcJaq9vFCU9etnqTB80";
  static const _signupUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=";

  static const _signInUrl =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=";

  Future<void> _authenticate(String email, String password, String url) async {
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    final responseBody = json.decode(response.body);

    if (responseBody['error'] != null) {
      throw AuthException(responseBody['error']['message']);
    }

    _token = responseBody['idToken'];
    _expireDate = DateTime.now().add(
      Duration(seconds: int.parse(responseBody['expiresIn'])),
    );
    _userId = responseBody['localId'];

    SharedPreferenceStore.saveMap('userData', {
      "token": _token,
      "userId": _userId,
      "expireDate": _expireDate.toIso8601String(),
    });

    _autoLogout();
    notifyListeners();

    return Future.value();
  }

  Future<void> tryAutoLogin() async {
    if (isAuthenticated) {
      return Future.value();
    }

    final userData = await SharedPreferenceStore.getMap('userData');

    if (userData == null) {
      return Future.value();
    }

    final expireDate = DateTime.parse(userData['expireDate']);

    if (expireDate.isBefore(DateTime.now())) {
      return Future.value();
    }

    _userId = userData['userId'];
    _token = userData['token'];
    _expireDate = expireDate;

    _autoLogout();
    notifyListeners();
    return Future.value();
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "$_signupUrl$_key");
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, "$_signInUrl$_key");
  }

  void logout() {
    _token = null;
    _expireDate = null;
    _userId = null;

    SharedPreferenceStore.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }
    final int timeToLogout = _expireDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout), logout);
  }
}
