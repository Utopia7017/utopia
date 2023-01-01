import 'package:utopia/states/article_state.dart';
import 'package:utopia/states/auth_state.dart';
import 'package:utopia/states/my_articles_state.dart';
import 'package:utopia/states/user_state.dart';

class GlobalState {
  /// A state management system.
  UserState userState;
  MyArticleState myArticleState;
  ArticleState articleState;
  AuthState authState;

  /// A constructor.
  GlobalState(
      {required this.userState,
      required this.articleState,
      required this.authState,
      required this.myArticleState});

  /// It updates the global state.
  ///
  /// Args:
  ///   userSate (UserSate): The state of the user.
  ///   articleState (ArticleState): This is the state of the article.
  ///   myArticleState (MyArticleState): This is the state of the my articles,
  ///   authState (AuthState): This is the state of the authentication.
  ///
  /// Returns:
  ///   A new GlobalState object with the updated values.
  GlobalState updateGlobalState({
    UserState? userState,
    ArticleState? articleState,
    MyArticleState? myArticleState,
    AuthState? authState,
  }) {
    return GlobalState(
      userState: userState ?? this.userState,
      articleState: articleState ?? this.articleState,
      authState: authState ?? this.authState,
      myArticleState: myArticleState ?? this.myArticleState,
    );
  }

  /// > This function initializes the global state with the initial states of the user, article, auth
  /// and myArticle states
  /// 
  /// Returns:
  ///   A GlobalState object with the following properties:
  ///   userState: UserState object
  ///   articleState: ArticleState object
  ///   authState: AuthState object
  ///   myArticleState: MyArticleState object
  factory GlobalState.initGlobalState() {
    return GlobalState(
        userState: UserState.initUserState(),
        articleState: ArticleState.initArticleState(),
        authState: AuthState.initAuthState(),
        myArticleState: MyArticleState.initMyArticleState());
  }
}
