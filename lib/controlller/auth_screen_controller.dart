import 'package:flutter/cupertino.dart';
import 'package:utopia/enums/enums.dart';

class AuthScreenController with ChangeNotifier {
  AuthSignUpStatus status = AuthSignUpStatus.notLoading;

  startLoding() {
    status = AuthSignUpStatus.loading;
    notifyListeners();
  }

  stopLoding() {
    status = AuthSignUpStatus.notLoading;
    notifyListeners();
  }
}
