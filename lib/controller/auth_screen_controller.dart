import 'package:flutter/cupertino.dart';
import 'package:utopia/enums/enums.dart';

class AuthScreenController with ChangeNotifier {
  AuthSignUpStatus signupStatus = AuthSignUpStatus.notLoading;
  AuthLoginStatus  loginStatus = AuthLoginStatus.notloading;
  bool termsCondition = false;
  bool showLoginPassword = false;
  bool showSignupPasswprd = false;
  bool showSignupConfirmPassword = false;

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

  void acceptTermsCondition() {
    termsCondition=true;
    notifyListeners();
  }
  void declineTermsCondition () {
    termsCondition = false;
    notifyListeners();
  }
  void loginOnVisibility() {
    showLoginPassword = true;
    notifyListeners();
  }
  void loginOffVisibility() {
    showLoginPassword = false;
    notifyListeners();
  }
  void signupOnVisibility() {
    showSignupPasswprd= true;
    notifyListeners();
  }
  void signupOffVisibility() {
    showSignupPasswprd= false;
    notifyListeners();
  }
  void signupConfirmOnVisibility() {
    showSignupConfirmPassword = true;
    notifyListeners();
  }
  void signupOffConfirmOffVisibility() {
    showSignupConfirmPassword= false;
    notifyListeners();
  }
}