import 'package:flutter/material.dart';

class LoginState with ChangeNotifier {
  bool isLoggedIn;
  String token;
  LoginState(this.isLoggedIn);

  getLoggedInStatus() => isLoggedIn;
  getToken() => token;

  setJWT(_token) => {
        token = _token, //notifyListeners()
      };
  void flip() {
    isLoggedIn = !isLoggedIn;
    //print(isLoggedIn)
    notifyListeners();
  }
}
