import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/user_model.dart' as um;
import 'package:utopia/states/article_state.dart';
import 'package:utopia/states/auth_state.dart';
import 'package:utopia/states/global_state.dart';
import 'package:utopia/states/my_articles_state.dart';
import 'package:utopia/states/user_state.dart';
import 'package:utopia/utils/article_body_component.dart';

class GlobalStateNotifier extends StateNotifier<GlobalState> {
  GlobalStateNotifier() : super(GlobalState.initGlobalState());

  @override
  GlobalState get state => super.state;

  /// It takes in a bunch of optional parameters, and if they are not null, it updates the state with
  /// the new values. Otherwise, it keeps the old values
  ///
  /// Args:
  ///   userState (UserState): The state of the user.
  ///   articleState (ArticleState): The state of the article page.
  ///   authState (AuthState): This is the state of the authentication.
  ///   myArticleState (MyArticleState): This is the state of the MyArticleState class.
  updateState(
      {UserState? userState,
      ArticleState? articleState,
      AuthState? authState,
      MyArticleState? myArticleState}) async {
    await Future.delayed(const Duration(microseconds: 1));
    state = state.updateGlobalState(
        userState: userState ?? state.userState,
        articleState: articleState ?? state.articleState,
        authState: authState ?? state.authState,
        myArticleState: myArticleState ?? state.myArticleState);
  }

  //*****************************************************************************************************/
  //*                                                                                                   */
  //*                                 Auth State controllers                                            */
  //*                                                                                                   */
  //*****************************************************************************************************/

  /// Increase the registration page index by one.
  increaseRegistrationPageIndex() {
    /// Updating the state of the AuthState class.
    updateState(authState: state.authState.increaseRegistrationPageIndex());
  }

  /// It decreases the registration page index by 1.
  decreaseRegistrationPageIndex() {
    updateState(authState: state.authState.decreaseRegistrationPageIndex());
  }

  /// > When the user clicks the sign up button, we want to update the state to reflect that the user is
  /// signing up
  startSigningUp() {
    updateState(authState: state.authState.startSigningUp());
  }

  /// > Stop signing up
  stopSigningUp() {
    updateState(authState: state.authState.stopSigningUp());
  }

  /// > When the user clicks the login button, we want to update the state to reflect that the user is
  /// logging in
  startLogin() {
    updateState(authState: state.authState.startLogin());
  }

  /// It stops the login process.
  stopLogin() {
    updateState(authState: state.authState.stopLogin());
  }

  /// It updates the state of the authState to acceptTermsCondition.
  acceptTermsCondition() {
    updateState(authState: state.authState.acceptTermsCondition());
  }

  /// It updates the state of the authState to declineTermsCondition.
  declineTermsCondition() {
    updateState(authState: state.authState.declineTermsCondition());
  }

  /// It updates the state of the app.
  loginOnVisibility() {
    updateState(authState: state.authState.loginOnVisibility());
  }

  /// It updates the state of the loginOffVisibility to true.
  loginOffVisibility() {
    updateState(authState: state.authState.loginOffVisibility());
  }

  /// "If the user is not signed in, then show the signup form."
  ///
  /// The function is called when the user clicks the "Sign Up" button
  signupOnVisibility() {
    updateState(authState: state.authState.signupOnVisibility());
  }

  /// It updates the state of the application.
  signupOffVisibility() {
    updateState(authState: state.authState.signupOffVisibility());
  }

  /// "When the user clicks the 'Show' button, we want to update the state to show the password."
  ///
  /// The first thing we do is call the `signupConfirmOnVisibility` function on the `authState` object.
  /// This function returns a new `AuthState` object with the `signupConfirmVisible` property set to
  /// `true`
  signupConfirmOnVisibility() {
    updateState(authState: state.authState.signupConfirmOnVisibility());
  }

  /// If the user is in the signup state, then the signup confirm off visibility state is set to true.
  signupConfirmOffVisibility() {
    updateState(authState: state.authState.signupConfirmOffVisibility());
  }

  //*****************************************************************************************************/
  //*                                                                                                   */
  //*                                 User State controllers                                            */
  //*                                                                                                   */
  //*****************************************************************************************************/

  /// "When the user clicks the button, we want to start fetching the popular authors."
  ///
  /// The first thing we do is call the `startFetchingPopularAuthors` function on the `userState`. This
  /// function returns a new `UserState` object with the `isFetchingPopularAuthors` property set to
  /// `true`
  startFetchingPopularAuthors() async {
    updateState(userState: await state.userState.startFetchingPopularAuthors());
  }

  /// > Stop fetching popular authors
  stopFetchingPopularAuthors() async {
    updateState(userState: await state.userState.stopFetchingPopularAuthors());
  }

  startFollowingUser() async {
    updateState(userState: await state.userState.startFollowingUser());
  }

  /// Stop following the user with the given ID.
  stopFollowingUser() async {
    updateState(userState: await state.userState.stopFollowingUser());
  }

  /// It updates the state of the userState to startFetchingMyProfile.
  startFetchingMyProfile() async {
    print("updating state from start fetching my profile method");
    updateState(userState: await state.userState.startFetchingMyProfile());
  }

  stopFetchingMyProfile() async {
    print("updating state from stop fetching my profile");
    updateState(userState: await state.userState.stopFetchingMyProfile());
  }

  /// It updates the state of the userState to startUploadingImage.
  startUploadingImage() async {
    updateState(userState: await state.userState.startUploadingImage());
  }

  /// Stop uploading the image and update the state.
  stopUploadingImage() async {
    updateState(userState: await state.userState.stopUploadingImage());
  }

  /// It gets the popular authors from the server and updates the state.
  getPopularAuthors() async {
    updateState(userState: await state.userState.getPopularAuthors());
  }

  /// "Set the userId in the userState and update the state."
  ///
  /// The first thing to notice is that the function is async. This is because the function is going to
  /// call an async function
  ///
  /// Args:
  ///   userId (String): The user's id.
  setUser(String userId) async {
    if (state.userState.user == null) {
      startFetchingMyProfile();
      await updateState(userState: await state.userState.setUser(userId));
      stopFetchingMyProfile();
    }
  }

  /// > Create a new user and update the state
  ///
  /// Args:
  ///   newUser (User): The new user to be created.
  createUser(um.User newUser) async {
    updateState(userState: await state.userState.createUser(newUser));
  }

  /// It changes the cover photo of the user.
  ///
  /// Args:
  ///   imageFile (CroppedFile): The image file that you want to upload.
  changeCoverPhoto(CroppedFile imageFile) async {
    updateState(userState: await state.userState.changeCoverPhoto(imageFile));
  }

  /// It changes the display photo of the user.
  ///
  /// Args:
  ///   imageFile (CroppedFile): The image file that you want to change the display photo to.
  changeDisplayPhoto(CroppedFile imageFile) async {
    updateState(userState: await state.userState.changeDisplayPhoto(imageFile));
  }

  /// It removes a follower from the user's list of followers.
  ///
  /// Args:
  ///   followerId (String): The id of the user who is following you.
  ///   myUid (String): The uid of the user who is currently logged in.
  removeFollower(String followerId, String myUid) async {
    updateState(
        userState: await state.userState.removeFollower(followerId, myUid));
  }

  /// It calls the followUser function in the userState class and updates the state.
  ///
  /// Args:
  ///   userId: The id of the user you want to follow.
  followUser({required userId}) async {
    updateState(userState: await state.userState.followUser(userId: userId));
  }

  /// It calls the unFollowUser function in the userState class and updates the state.
  ///
  /// Args:
  ///   userId: The id of the user you want to follow.
  unFollowUser({required userId}) async {
    updateState(userState: await state.userState.unFollowUser(userId: userId));
  }

  /// It updates the user's profile.
  ///
  /// Args:
  ///   name (String): The name of the user
  ///   bio (String): The user's bio
  updateProfile({required String name, required String bio}) async {
    updateState(
        userState: await state.userState.updateProfile(name: name, bio: bio));
  }

  /// It saves an article to the user's saved articles list.
  ///
  /// Args:
  ///   authorId (String): The author's id
  ///   articleId (String): The id of the article to be saved.
  saveArticleDetail(
      {required String authorId, required String articleId}) async {
    updateState(
        userState: await state.userState
            .saveArticleDetail(authorId: authorId, articleId: articleId));
  }

  /// It removes the article from the user's saved articles.
  ///
  /// Args:
  ///   authorId (String): The author of the article
  ///   articleId (String): The id of the article you want to unsave.
  unSaveArticleDetail(
      {required String authorId, required String articleId}) async {
    updateState(
        userState: await state.userState
            .unSaveArticleDetail(authorId: authorId, articleId: articleId));
  }

  /// It blocks the user with the given uid.
  ///
  /// Args:
  ///   uid (String): The user's uid
  blockThisUser(String uid) async {
    updateState(userState: await state.userState.blockThisUser(uid));
  }

  /// It unblocks a user.
  ///
  /// Args:
  ///   uid (String): The user id of the user you want to unblock.
  unBlockThisUser(String uid) async {
    updateState(userState: await state.userState.unBlockThisUser(uid));
  }

  /// It removes the user's display picture.
  removeDp() async {
    updateState(userState: await state.userState.removeDp());
  }

  /// It removes the current page from the user state.
  removeCp() async {
    updateState(userState: await state.userState.removeCp());
  }

  //*****************************************************************************************************/
  //*                                                                                                   */
  //*                                 Article State controllers                                         */
  //*                                                                                                   */
  //*****************************************************************************************************/

  /// > When the user clicks the button, we want to start loading articles
  startLoadingArticles() {
    updateState(articleState: state.articleState.startLoadingArticles());
  }

  /// > Stop loading articles
  stopLoadingArticles() {
    updateState(articleState: state.articleState.stopLoadingArticles());
  }

  /// `fetchArticles()` is an async function that calls `fetchArticles()` on the `articleState` object,
  /// which is an instance of the `ArticleState` class
  fetchArticles() async {
    startLoadingArticles();
    await updateState(
        articleState:
            await state.articleState.fetchArticles(state.userState.user!));
    stopLoadingArticles();

    // }
  }

  /// > Selects a category by index
  ///
  /// Args:
  ///   index (int): The index of the category to select.
  selectCategory(int index) {
    updateState(articleState: state.articleState.selectCategory(index));
  }

  /// It updates the state of the articleState.
  ///
  /// Args:
  ///   query (String): The search query
  search(String query) async {
    updateState(articleState: await state.articleState.search(query));
  }

  //*****************************************************************************************************/
  //*                                                                                                   */
  //*                                 MyArticles State controllers                                      */
  //*                                                                                                   */
  //*****************************************************************************************************/

  /// > The function `startUploadingArticle()` is called when the user clicks the upload button
  startUploadingArticle() {
    updateState(myArticleState: state.myArticleState.startUploadingArticle());
  }

  /// It stops uploading the article.
  stopUploadingArticle() {
    updateState(myArticleState: state.myArticleState.stopUploadingArticle());
  }

  /// It updates the state of the myArticleState to startFetchingMyArticles.
  startFetchingMyArticles() {
    updateState(myArticleState: state.myArticleState.startFetchingMyArticles());
  }

  /// > Stop fetching my articles
  stopFetchingMyArticles() {
    updateState(myArticleState: state.myArticleState.stopFetchingMyArticles());
  }

  /// It updates the state of the app to start fetching saved articles.
  startFetchingSavedArticles() {
    updateState(
        myArticleState: state.myArticleState.startFetchingSavedArticles());
  }

  /// It stops fetching saved articles.
  stopFetchingSavedArticles() {
    updateState(
        myArticleState: state.myArticleState.stopFetchingSavedArticles());
  }

  /// It stops fetching the draft articles
  startFetchingDraftArticles() {
    updateState(
        myArticleState: state.myArticleState.startFetchingDraftArticles());
  }

  /// It stops fetching the draft articles.
  stopFetchingDraftArticles() {
    updateState(
        myArticleState: state.myArticleState.stopFetchingSavedArticles());
  }

  /// It changes the category of the article and updates the state
  ///
  /// Args:
  ///   newCategory (String): The new category to change to.
  changeCategory(String newCategory) {
    updateState(
        myArticleState: state.myArticleState.changeCategory(newCategory));
  }

  /// "Add a text field to the article."
  ///
  /// The function is called with a string, which is the text to be added to the article
  ///
  /// Args:
  ///   text (String): The text to be added to the text field.
  addTextField(String? text) {
    updateState(myArticleState: state.myArticleState.addTextField(text));
  }

  /// "Add an image field to the article."
  ///
  /// The function is called from the UI when the user clicks the "Add Image" button
  ///
  /// Args:
  ///   file (CroppedFile): The file that was cropped.
  ///   imageUrl (String): The url of the image to be displayed in the image field.
  addImageField(CroppedFile? file, String? imageUrl) {
    updateState(
        myArticleState: state.myArticleState.addImageField(file, imageUrl));
  }

  /// It removes the image from the list of images.
  ///
  /// Args:
  ///   sublist (List<BodyComponent>): The list of BodyComponent objects that you want to remove.
  removeImage(List<BodyComponent> sublist) {
    updateState(myArticleState: state.myArticleState.removeImage(sublist));
  }

  /// It clears the form.
  clearForm() {
    updateState(myArticleState: state.myArticleState.clearForm());
  }

  /// It clears the full form of the article.
  clearFullForm() {
    updateState(myArticleState: state.myArticleState.clearFullForm());
  }

  /// > It starts uploading an article, then updates the state with the result of the `publishArticle`
  /// function, and finally stops uploading an article
  ///
  /// Args:
  ///   userId (String): The userId of the user who is publishing the article.
  ///   title (String): The title of the article
  ///   tags (List<String>): List of tags that the article will be associated with.
  publishArticle({
    required String userId,
    required String title,
    required List<String> tags,
  }) async {
    startUploadingArticle();
    await updateState(
        myArticleState: await state.myArticleState
            .publishArticle(userId: userId, title: title, tags: tags));
    stopUploadingArticle();
  }

  /// It fetches the articles that the user has written.
  ///
  /// Args:
  ///   myUid (String): The uid of the user whose articles are to be fetched.

  fetchMyArticles(String myUid) async {
    startFetchingMyArticles();
    await updateState(
        myArticleState: await state.myArticleState.fetchMyArticles(myUid));
    stopFetchingMyArticles();
  }

  /// > Save an article to the user's list of saved articles
  ///
  /// Args:
  ///   article: The article to be saved.
  saveArticle({required article}) {
    updateState(
        myArticleState: state.myArticleState.saveArticle(article: article));
  }

  unsaveArticle({required String authorId, required String articleId}) {
    updateState(
        myArticleState: state.myArticleState
            .unsaveArticle(authorId: authorId, articleId: articleId));
  }

  /// It fetches the saved articles of the current user.
  ///
  /// Args:
  ///   currentUser (User): The current user object.
  fetchSavedArticles(um.User currentUser) async {
    startFetchingSavedArticles();
    await updateState(
        myArticleState:
            await state.myArticleState.fetchSavedArticles(currentUser));
    stopFetchingSavedArticles();
  }

  /// It deletes an article from the database.
  ///
  /// Args:
  ///   myUid (String): The uid of the user who is deleting the article.
  ///   articleId (String): The id of the article you want to delete.
  deleteThisArticle({required String myUid, required String articleId}) async {
    await updateState(
        myArticleState: await state.myArticleState
            .deleteThisArticle(myUid: myUid, articleId: articleId));
  }

  /// It updates the state of the myArticleState.
  ///
  /// Args:
  ///   myUid (String): The user's id.
  ///   articleId (String): The id of the article.
  deleteDraftArticle({required String myUid, required String articleId}) async {
    updateState(
        myArticleState: await state.myArticleState
            .deleteDraftArticle(myUid: myUid, articleId: articleId));
  }

  /// It updates the state of the myArticleState.
  ///
  /// Args:
  ///   userId (String): The user's id.
  ///   title (String): The title of the article
  ///   tags (List<String>): List of tags that the article will be associated with.
  draftMyArticle({
    required String userId,
    required String title,
    required List<String> tags,
  }) async {
    updateState(
        myArticleState: await state.myArticleState
            .draftMyArticle(userId: userId, title: title, tags: tags));
  }

  /// It starts fetching draft articles, then updates the state with the fetched articles, and finally
  /// stops fetching draft articles
  ///
  /// Args:
  ///   myUid (String): The uid of the user whose articles are to be fetched.
  fetchDraftArticles(String myUid) async {
    startFetchingDraftArticles();
    await updateState(
        myArticleState: await state.myArticleState.fetchDraftArticles(myUid));
    stopFetchingDraftArticles();
  }
}

final stateController =
    StateNotifierProvider<GlobalStateNotifier, GlobalState>((ref) {
  return GlobalStateNotifier();
});
