import 'package:flutter/cupertino.dart';
import 'package:utopia/enums/enums.dart';

class AuthScreenController with ChangeNotifier {
  AuthSignUpStatus signupStatus = AuthSignUpStatus.notLoading;
  AuthLoginStatus  loginStatus = AuthLoginStatus.notloading;

  startSigningUp() {
    signupStatus = AuthSignUpStatus.loading;
    notifyListeners();
  }

  stopSigningUp() {
    signupStatus = AuthSignUpStatus.notLoading;
    notifyListeners();
  }

  startLogin() {
    loginStatus = AuthLoginStatus.loading;
    notifyListeners();
  }
  stopLogin() {
    loginStatus = AuthLoginStatus.notloading;
    notifyListeners();
  }
}
