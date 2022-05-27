import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/httpException.dart';

class AuthProvider with ChangeNotifier {
  static String? token;
  DateTime? expiryDate;
  static String? userId;
  Timer? _authTimer;

  bool get isAuth {
    if (token == '') {
      return false;
    }
    return token != null;
  }

  String? get getToken {
    if (expiryDate != null &&
        expiryDate!.isAfter(DateTime.now()) &&
        token != null) {
      return token!;
    }

    return null;
  }

  // static String? getTokenFromAuth(){
  //   if(expiryDate !=null && expiryDate!.isAfter(DateTime.now()) && _token != null){
  //     return _token!;
  //   }

  //   return null;
  // }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCMjwezUYrp6CFWwPv0fVilbq7UJ8domsY';

    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            "email": email,
            "password": password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(res.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      token = responseData['idToken'];
      userId = responseData['localId'];
      expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      notifyListeners();
      // print(json.decode(res.body));
      final local = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': responseData['idToken'],
        'userId': responseData['localId'],
        'expired': expiryDate!.toIso8601String()
      });
      local.setString('userData', userData);
      // _autoLogout();
    } catch (error) {
      throw error;
    }
  }

  // Future<bool> tryAutoLogin() async {
  //   final local = await SharedPreferences.getInstance();
  //   if (!local.containsKey('userData')) {
  //     return false;
  //   }
  //   final extractedData =
  //       json.decode(local.getString('userData')!) as Map<String, dynamic>;
  //   final date = DateTime.parse(extractedData['expired']);
  //   if (date.isAfter(DateTime.now())) {
  //     return false;
  //   }
  //   token = extractedData['token'];
  //   userId = extractedData['userId'];
  //   expiryDate = date;
  //   notifyListeners();
  //   return true;
  // }
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final date = DateTime.parse(extractedUserData['expired']!);

    if (date.isBefore(DateTime.now())) {
      return false;
    }
    token = extractedUserData['token'];
    userId = extractedUserData['userId'];
    expiryDate = date;
    notifyListeners();
    // _autoLogout();
    return true;
  }

  Future<void> signUp(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async{
    token = '';
    userId = '';
    expiryDate = null;
    if(_authTimer != null){
      _authTimer!.cancel();
      _authTimer=null;
    }
    final local= await SharedPreferences.getInstance();
    local.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if(_authTimer != null){
      _authTimer!.cancel();
    }
    final timeToExpiry = expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer=Timer(Duration(seconds: timeToExpiry), logout);
  }
}
