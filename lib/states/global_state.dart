import 'package:utopia/states/user_state.dart';

class GlobalState {
  UserSate? userSate;
  GlobalState({required this.userSate});
  
  GlobalState updateGlobalState({UserSate? updatedUserState}) {
    return GlobalState(userSate: updatedUserState ?? userSate);
  }
}
