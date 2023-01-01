import 'package:utopia/enums/enums.dart';

class AuthState {
  /// Initializing the state of the AuthState class.
  AuthSignUpStatus signupStatus = AuthSignUpStatus.NOT_LOADING;
  AuthLoginStatus loginStatus = AuthLoginStatus.NOT_LOADING;
  bool termsCondition = false;
  bool showLoginPassword = false;
  bool showSignupPassword = false;
  bool showSignupConfirmPassword = false;
  int registrationPageIndex = 1;

  /// A constructor.
  AuthState(
      {required this.signupStatus,
      required this.loginStatus,
      required this.registrationPageIndex,
      required this.showLoginPassword,
      required this.showSignupPassword,
      required this.showSignupConfirmPassword,
      required this.termsCondition});

  /// A factory constructor that returns an instance of AuthState.
  /// 
  /// Returns:
  ///   AuthState
  factory AuthState.initAuthState() {
    return AuthState(
        signupStatus: AuthSignUpStatus.NOT_LOADING,
        loginStatus: AuthLoginStatus.NOT_LOADING,
        registrationPageIndex: 1,
        showLoginPassword: false,
        showSignupPassword: false,
        showSignupConfirmPassword: false,
        termsCondition: false);
  }

  /// It returns a new instance of the AuthState class with the updated values
  ///
  /// Args:
  ///   signupStatus (AuthSignUpStatus): This is the status of the signup process. It can be one of the
  /// following:
  ///   loginStatus (AuthLoginStatus): This is the status of the login process. It can be either
  /// `AuthLoginStatus.notSubmitted` or `AuthLoginStatus.submitted`.
  ///   termsCondition (bool): This is a boolean value that determines whether the user has accepted the
  /// terms and conditions.
  ///   showLoginPassword (bool): This is a boolean value that determines whether the password field in
  /// the login page is visible or not.
  ///   showSignupPassword (bool): This is a boolean value that determines whether the password field is
  /// visible or not.
  ///   showSignupConfirmPassword (bool): This is a boolean value that determines whether the confirm
  /// password field is visible or not.
  ///   registrationPageIndex (int): This is the index of the page that the user is currently on.
  ///
  /// Returns:
  ///   A new AuthState object with the updated values.
  AuthState _updateState(
      {AuthSignUpStatus? signupStatus,
      AuthLoginStatus? loginStatus,
      bool? termsCondition,
      bool? showLoginPassword,
      bool? showSignupPassword,
      bool? showSignupConfirmPassword,
      int? registrationPageIndex}) {
    return AuthState(
        signupStatus: signupStatus ?? this.signupStatus,
        loginStatus: loginStatus ?? this.loginStatus,
        registrationPageIndex:
            registrationPageIndex ?? this.registrationPageIndex,
        showLoginPassword: showLoginPassword ?? this.showLoginPassword,
        showSignupPassword: showSignupPassword ?? this.showSignupPassword,
        showSignupConfirmPassword:
            showSignupConfirmPassword ?? this.showSignupConfirmPassword,
        termsCondition: termsCondition ?? this.termsCondition);
  }

  /// If the registration page index is 1, increase it by 1
  ///
  /// Returns:
  ///   A new instance of the AuthState class.
  AuthState increaseRegistrationPageIndex() {
    if (registrationPageIndex == 1) {
      ++registrationPageIndex;
    }
    return _updateState(registrationPageIndex: registrationPageIndex);
  }

  /// If the registration page index is 2, decrease it by 1
  ///
  /// Returns:
  ///   A new instance of the AuthState class.
  AuthState decreaseRegistrationPageIndex() {
    if (registrationPageIndex == 2) {
      --registrationPageIndex;
    }
    return _updateState(registrationPageIndex: registrationPageIndex);
  }

  /// > The function `startSigningUp` sets the `signupStatus` to `AuthSignUpStatus.LOADING` and returns
  /// the updated state
  ///
  /// Returns:
  ///   The return type is AuthState.
  AuthState startSigningUp() {
    signupStatus = AuthSignUpStatus.LOADING;
    return _updateState(signupStatus: signupStatus);
  }

  /// > Stop the signup process and update the state
  ///
  /// Returns:
  ///   The return type is AuthState.
  AuthState stopSigningUp() {
    signupStatus = AuthSignUpStatus.NOT_LOADING;
    return _updateState(signupStatus: signupStatus);
  }

  /// > The function `startLogin` sets the `loginStatus` to `AuthLoginStatus.LOADING` and returns the
  /// updated state
  ///
  /// Returns:
  ///   The return value is an AuthState object.
  AuthState startLogin() {
    loginStatus = AuthLoginStatus.LOADING;
    return _updateState(loginStatus: loginStatus);
  }

  /// > Stop the login process
  ///
  /// Returns:
  ///   The return value is an AuthState object.
  AuthState stopLogin() {
    loginStatus = AuthLoginStatus.NOT_LOADING;
    return _updateState(loginStatus: loginStatus);
  }

  /// It sets the termsCondition variable to true and then calls the _updateState function to update the
  /// state of the app
  ///
  /// Returns:
  ///   The return value is a new instance of the AuthState class.
  AuthState acceptTermsCondition() {
    termsCondition = true;
    return _updateState(termsCondition: termsCondition);
  }

  /// > Decline the terms and conditions and update the state
  ///
  /// Returns:
  ///   the value of the termsCondition variable.
  AuthState declineTermsCondition() {
    termsCondition = false;
    return _updateState(termsCondition: termsCondition);
  }

  /// `showLoginPassword` is a boolean variable that is set to true when the user clicks on the password
  /// field
  ///
  /// Returns:
  ///   The return value is a Future<AuthState>
  AuthState loginOnVisibility() {
    showLoginPassword = true;
    return _updateState(showLoginPassword: showLoginPassword);
  }

  /// It sets the visibility of the login and password fields to false.
  ///
  /// Returns:
  ///   The return type is AuthState.
  AuthState loginOffVisibility() {
    showLoginPassword = false;
    return _updateState(showLoginPassword: showLoginPassword);
  }

  /// "When the user clicks the signup button, show the password field."
  ///
  /// The first line of the function is a Dart comment. Comments are ignored by the Dart compiler
  ///
  /// Returns:
  ///   The AuthState is being returned.
  AuthState signupOnVisibility() {
    showSignupPassword = true;
    return _updateState(showSignupPassword: showSignupPassword);
  }

  /// * It sets the value of the `showSignupPassword` variable to `false` and then calls the
  /// `_updateState` function to update the state of the widget
  ///
  /// Returns:
  ///   The AuthState is being returned.
  AuthState signupOffVisibility() {
    showSignupPassword = false;
    return _updateState(showSignupPassword: showSignupPassword);
  }

  /// > When the user clicks on the "Show" button, the function sets the `showSignupConfirmPassword`
  /// variable to `true` and then calls the `_updateState` function to update the state of the widget
  ///
  /// Returns:
  ///   The return type is AuthState.
  AuthState signupConfirmOnVisibility() {
    showSignupConfirmPassword = true;
    return _updateState(showSignupConfirmPassword: showSignupConfirmPassword);
  }

  /// It hides the confirm password field.
  ///
  /// Returns:
  ///   The return type is AuthState.
  AuthState signupConfirmOffVisibility() {
    showSignupConfirmPassword = false;
    return _updateState(showSignupConfirmPassword: showSignupConfirmPassword);
  }
}
