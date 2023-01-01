import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:logging/logging.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_body_model.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/saved_article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/services/api/api_services.dart';
import 'package:utopia/services/firebase/storage_service.dart';
import 'package:utopia/utils/common_api_calls.dart';
import '../utils/article_body_component.dart';
import '../view/common_ui/article_textfield.dart';

class MyArticleState {
  // Data members of the class
  ArticleUploadingStatus articleUploadingStatus =
      ArticleUploadingStatus.NOT_UPLOADING;
  List<BodyComponent> bodyComponents = [];
  List<Article> publishedArticles = [];
  List<Article> draftArticles = [];
  List<SavedArticle> savedArticles = [];
  List<Article> savedArticlesDetails = [];
  FetchingMyArticle fetchingMyArticleStatus = FetchingMyArticle.NOT_FETCHED;
  FetchingDraftArticles fetchingDraftArticlesStatus =
      FetchingDraftArticles.NOT_FETCHED;
  String? category;
  final ApiServices _apiServices = ApiServices();
  FetchingSavedArticles fetchingSavedArticlesStatus =
      FetchingSavedArticles.NOT_FETCHED;

  /// A constructor that takes in the following parameters:
  /// - bodyComponents
  /// - draftArticles
  /// - savedArticles
  /// - savedArticlesDetails
  /// - category
  /// - fetchingDraftArticlesStatus
  /// - fetchingMyArticleStatus
  /// - articleUploadingStatus
  /// - fetchingSavedArticlesStatus
  /// - publishedArticles
  MyArticleState(
      {required this.bodyComponents,
      required this.draftArticles,
      required this.savedArticles,
      required this.savedArticlesDetails,
      required this.category,
      required this.fetchingDraftArticlesStatus,
      required this.fetchingMyArticleStatus,
      required this.articleUploadingStatus,
      required this.fetchingSavedArticlesStatus,
      required this.publishedArticles});

  /// It returns a new instance of the MyArticleState class with all the properties set to their default
  /// values
  ///
  /// Returns:
  ///   A new instance of MyArticleState
  factory MyArticleState.initMyArticleState() {
    return MyArticleState(
        bodyComponents: [],
        draftArticles: [],
        savedArticles: [],
        savedArticlesDetails: [],
        category: null,
        fetchingDraftArticlesStatus: FetchingDraftArticles.NOT_FETCHED,
        fetchingMyArticleStatus: FetchingMyArticle.NOT_FETCHED,
        articleUploadingStatus: ArticleUploadingStatus.NOT_UPLOADING,
        fetchingSavedArticlesStatus: FetchingSavedArticles.NOT_FETCHED,
        publishedArticles: []);
  }

  /// It returns a new state with the updated values passed in as parameters
  ///
  /// Args:
  ///   updateBodyComponent (List<BodyComponent>): This is the list of body components that will be
  /// updated.
  ///   updatedDraftArticle (List<Article>): This is the list of draft articles that will be updated.
  ///   updatedSavedArticles (List<SavedArticle>): This is the updated list of saved articles.
  ///   updatedPublishedArticle (List<Article>): This is the list of published articles that will be
  /// updated.
  ///   updatedSavedArticleDetail (List<Article>): This is the list of articles that are saved by the
  /// user.
  ///   updatedCategory (String): This is the category that the user has selected.
  ///   updatedFetchingDraftArticlesStatus (FetchingDraftArticles): This is the status of the fetching
  /// draft articles.
  ///   updatedFetchingSavedArticlesStatus (FetchingSavedArticles): This is the status of the fetching
  /// saved articles.
  ///   updatedFetchingMyArticleStatus (FetchingMyArticle): This is the status of the fetching of the
  /// articles.
  ///   updatedArticleUploadingStatus (ArticleUploadingStatus): This is the status of the article
  /// uploading process.
  ///
  /// Returns:
  ///   A new instance of the MyArticleState class.
  MyArticleState _updateState({
    List<BodyComponent>? updateBodyComponent,
    List<Article>? updatedDraftArticle,
    List<SavedArticle>? updatedSavedArticles,
    List<Article>? updatedPublishedArticle,
    List<Article>? updatedSavedArticleDetail,
    String? updatedCategory,
    FetchingDraftArticles? updatedFetchingDraftArticlesStatus,
    FetchingSavedArticles? updatedFetchingSavedArticlesStatus,
    FetchingMyArticle? updatedFetchingMyArticleStatus,
    ArticleUploadingStatus? updatedArticleUploadingStatus,
  }) {
    return MyArticleState(
      bodyComponents: updateBodyComponent ?? bodyComponents,
      draftArticles: updatedDraftArticle ?? draftArticles,
      publishedArticles: updatedPublishedArticle ?? publishedArticles,
      savedArticles: updatedSavedArticles ?? savedArticles,
      category: updatedCategory ?? category,
      fetchingDraftArticlesStatus:
          updatedFetchingDraftArticlesStatus ?? fetchingDraftArticlesStatus,
      savedArticlesDetails: updatedSavedArticleDetail ?? savedArticlesDetails,
      fetchingMyArticleStatus:
          updatedFetchingMyArticleStatus ?? fetchingMyArticleStatus,
      fetchingSavedArticlesStatus:
          updatedFetchingSavedArticlesStatus ?? fetchingSavedArticlesStatus,
      articleUploadingStatus:
          updatedArticleUploadingStatus ?? articleUploadingStatus,
    );
  }

  /// It creates a new `TextEditingController` with the given text, creates a new `ArticleTextField`https://marketplace.visualstudio.com/items?itemname=mintlify.document
  /// with the new `TextEditingController`, and adds the new `ArticleTextField` to the list of
  /// `bodyComponents`
  ///
  /// Args:
  ///   text (String): The text that will be displayed in the text field.
  ///
  /// Returns:
  ///   A new instance of MyArticleState with the updated bodyComponents.
  MyArticleState addTextField(String? text) {
    TextEditingController textEditingController =
        TextEditingController(text: text);
    ArticleTextField textField = ArticleTextField(
      controller: textEditingController,
      isFirstTextBox: (bodyComponents.isEmpty),
    );

    bodyComponents.add(BodyComponent(
        type: "text",
        key: DateTime.now().toString(),
        textEditingController: textEditingController,
        textFormField: textField));
    return _updateState(
      updateBodyComponent: bodyComponents,
    );
  }

  /// ChangeCategory() returns a new MyArticleState object with the updatedCategory property set to the
  /// value of the newCategory parameter.
  ///
  /// Args:
  ///   newCategory (String): The new category to be set.
  ///
  /// Returns:
  ///   A new instance of the MyArticleState class.
  MyArticleState changeCategory(String newCategory) {
    return _updateState(updatedCategory: newCategory);
  }

  /// It adds an image to the bodyComponents list, which is a list of BodyComponent objects
  ///
  /// Args:
  ///   file (CroppedFile): The file that was cropped.
  ///   imageUrl (String): This is the url of the image that is being uploaded.
  ///
  /// Returns:
  ///   a new instance of the class.
  MyArticleState addImageField(CroppedFile? file, String? imageUrl) {
    TextEditingController imageCaptionController = TextEditingController();
    bodyComponents.add(BodyComponent(
        type: "image",
        imageUrl: imageUrl,
        imageCaption: imageCaptionController,
        key: DateTime.now().toString(),
        imageProvider: (file != null)
            ? Image(image: FileImage(File(file.path)))
            : Image(
                image: CachedNetworkImageProvider(imageUrl!),
              ),
        fileImage: file));
    if (imageUrl == null) {
      return addTextField(null);
    }

    return _updateState(
      updateBodyComponent: bodyComponents,
    );
  }

  /// > The function removes the image from the bodyComponents list and replaces it with a text field
  ///
  /// Args:
  ///   sublist (List<BodyComponent>): The list of BodyComponents that are to be removed.
  ///
  /// Returns:
  ///   A new instance of MyArticleState with the updated bodyComponents.
  MyArticleState removeImage(List<BodyComponent> sublist) {
    int indexOfBodyComponentToBeUpdated = bodyComponents
        .indexWhere((element) => element.key == sublist.first.key);
    TextEditingController ctr = TextEditingController(
        text:
            "${sublist.first.textEditingController!.text} ${sublist.last.textEditingController!.text}");
    bodyComponents.removeWhere((element) => element.key == sublist[0].key);
    bodyComponents.removeWhere((element) => element.key == sublist[1].key);
    bodyComponents.removeWhere((element) => element.key == sublist[2].key);
    ArticleTextField textField = ArticleTextField(
      controller: ctr,
      isFirstTextBox: false,
    );

    bodyComponents.insert(
        indexOfBodyComponentToBeUpdated,
        BodyComponent(
            type: "text",
            key: DateTime.now().toString(),
            textEditingController: ctr,
            textFormField: textField));
    return _updateState(updateBodyComponent: bodyComponents);
  }

  /// It clears the bodyComponents list, adds a new TextField to the list, and then updates the state
  ///
  /// Returns:
  ///   A new instance of MyArticleState with the updated bodyComponents.
  MyArticleState clearForm() {
    bodyComponents.clear();
    addTextField(null);
    return _updateState(updateBodyComponent: bodyComponents);
  }

  /// It clears the bodyComponents list and then calls the _updateState function with the updated
  /// bodyComponents list
  ///
  /// Returns:
  ///   A new instance of MyArticleState with the updated bodyComponents.
  MyArticleState clearFullForm() {
    bodyComponents.clear();
    return _updateState(updateBodyComponent: bodyComponents);
  }

  /// When the user clicks the upload button, we want to update the state to reflect that the article is
  /// uploading.
  ///
  /// Returns:
  ///   A new instance of the state with the updatedArticleUploadingStatus set to
  /// ArticleUploadingStatus.uploading
  MyArticleState startUploadingArticle() {
    return _updateState(
        updatedArticleUploadingStatus: ArticleUploadingStatus.UPLOADING);
  }

  /// It updates the state of the article to not uploading.
  ///
  /// Returns:
  ///   A new instance of MyArticleState with the updatedArticleUploadingStatus set to
  /// ArticleUploadingStatus.notUploading
  MyArticleState stopUploadingArticle() {
    return _updateState(
        updatedArticleUploadingStatus: ArticleUploadingStatus.NOT_UPLOADING);
  }

  /// > This function returns a new state object with the updatedFetchingMyArticleStatus set to
  /// FetchingMyArticle.fetching
  ///
  /// Returns:
  ///   A new instance of the MyArticleState class.
  MyArticleState startFetchingMyArticles() {
    return _updateState(
        updatedFetchingMyArticleStatus: FetchingMyArticle.FETCHING);
  }

  /// > This function is called when the user has successfully fetched all the articles that they have
  /// written
  ///
  /// Returns:
  ///   A new instance of the MyArticleState class.
  MyArticleState stopFetchingMyArticles() {
    return _updateState(
        updatedFetchingMyArticleStatus: FetchingMyArticle.FETCHED);
  }

  /// When the user clicks the 'Saved Articles' button, we want to update the state to reflect that we
  /// are fetching the saved articles.
  ///
  /// Returns:
  ///   A new instance of MyArticleState with the updatedFetchingSavedArticlesStatus set to
  /// FetchingSavedArticles.fetching.
  MyArticleState startFetchingSavedArticles() {
    return _updateState(
        updatedFetchingSavedArticlesStatus: FetchingSavedArticles.FETCHING);
  }

  /// It updates the state of the app.
  ///
  /// Returns:
  ///   A new instance of MyArticleState with the updatedFetchingSavedArticlesStatus set to
  /// FetchingSavedArticles.fetched.
  MyArticleState stopFetchingSavedArticles() {
    return _updateState(
        updatedFetchingSavedArticlesStatus: FetchingSavedArticles.FETCHED);
  }

  /// "When the user clicks the 'Fetch Draft Articles' button, we want to update the state to indicate
  /// that we're fetching draft articles."
  ///
  /// The `_updateState` function is a helper function that we'll use to update the state. It takes in a
  /// bunch of optional parameters, and returns a new state object
  ///
  /// Returns:
  ///   A new instance of MyArticleState with the updatedFetchingDraftArticlesStatus set to
  /// FetchingDraftArticles.fetching.
  MyArticleState startFetchingDraftArticles() {
    return _updateState(
        updatedFetchingDraftArticlesStatus: FetchingDraftArticles.FETCHING);
  }

  /// Stop fetching draft articles
  ///
  /// Returns:
  ///   A new instance of MyArticleState with the updatedFetchingDraftArticlesStatus set to
  /// FetchingDraftArticles.fetched.
  MyArticleState stopFetchingDraftArticles() {
    return _updateState(
        updatedFetchingDraftArticlesStatus: FetchingDraftArticles.FETCHED);
  }

  /// We are uploading the article to the server and then updating the article with the article id
  ///
  /// Args:
  ///   userId (String): The userId of the user who is publishing the article.
  ///   title (String): The title of the article
  ///   tags (List<String>): List of tags that the user has entered.
  ///
  /// Returns:
  ///   A Future<MyArticleState>
  Future<MyArticleState> publishArticle({
    required String userId,
    required String title,
    required List<String> tags,
  }) async {
    // call startuploading article
    try {
      List<ArticleBody> articleBody = [];
      int imageIndex = 0;
      for (BodyComponent bc in bodyComponents) {
        if (bc.type == "text") {
          articleBody.add(ArticleBody(
              type: "text", text: bc.textEditingController!.text.trim()));
        } else {
          if (bc.fileImage != null) {
            // here we are uploading image to the server and receiving back the image url
            String? url = await getImageUrl(File(bc.fileImage!.path),
                'articles/$userId/$title/${imageIndex++}');
            articleBody.add(ArticleBody(
                type: "image",
                image: url,
                imageCaption: bc.imageCaption!.text.trim()));
          } else {
            // we have already stored this image in the server and have the image url
            articleBody.add(ArticleBody(
                type: "image",
                image: bc.imageUrl,
                imageCaption: bc.imageCaption!.text.trim()));
          }
        }
      }
      Article article = Article(
          category: category!,
          title: title,
          body: articleBody,
          tags: tags,
          reports: [],
          articleCreated: DateTime.now(),
          articleId: '',
          authorId: userId);

      final Response? response = await _apiServices.post(
          endUrl: 'articles/$userId.json', data: article.toJson());

      if (response != null && response.data != null) {
        final String articleId = response.data[
            'name']; // we do not need to decode as dio already does it for us.

        await _apiServices.update(
            endUrl: 'articles/$userId/$articleId.json',
            data: {'articleId': articleId},
            message: "Article published successfully",
            showMessage: true);
        clearForm();
        return fetchMyArticles(userId); // call fetch my articles
      }

      /// > Save an article to the user's list of saved articles
      ///
      /// Args:
      ///   article: The article to be saved.
    } catch (error) {
      Logger("Publish Article Method").shout(error.toString());
    }
    // uploadingStatus = ArticleUploadingStatus.notUploading; // call stop loading
    return _updateState(updatedPublishedArticle: publishedArticles);

    /// It unsaves an article.
    ///
    /// Args:
    ///   authorId (String): The authorId of the article you want to unsave.
    ///   articleId (String): The id of the article you want to unsave.
  }

  /// It fetches the articles from the firebase database and stores it in the publishedArticles list.
  ///
  /// Args:
  ///   myUid (String): The uid of the user whose articles are to be fetched.
  ///
  /// Returns:
  ///   A Future<MyArticleState>
  Future<MyArticleState> fetchMyArticles(String myUid) async {
    Logger logger = Logger("FetchMyArticles");
    // fetchingMyArticleStatus = FetchingMyArticle.fetching;
    // call startFetchingarticles

    try {
      List<Article> tempPublished = [];
      final Response? response =
          await _apiServices.get(endUrl: 'articles/$myUid.json');
      if (response != null && response.data != null) {
        final Map<String, dynamic> responseData = response.data;
        for (var article in responseData.values) {
          Article art = Article.fromJson(article);
          tempPublished.add(art);
        }
        publishedArticles = tempPublished;
        publishedArticles
            .sort((a, b) => b.articleCreated.compareTo(a.articleCreated));
      }
    } catch (error) {
      logger.shout(error.toString());
    }
    return _updateState(updatedPublishedArticle: publishedArticles);
    // fetchingMyArticleStatus = FetchingMyArticle.fetched;
  }

  /// It adds the article to the savedArticlesDetails list.
  ///
  /// Args:
  ///   article: The article to be saved.
  ///
  /// Returns:
  ///   A new instance of MyArticleState with the updatedSavedArticleDetail property set to the new list
  /// of saved articles.
  MyArticleState saveArticle({required article}) {
    savedArticlesDetails.add(article);
    return _updateState(updatedSavedArticleDetail: savedArticlesDetails);
  }

  /// It removes the article from the list of saved articles.
  ///
  /// Args:
  ///   authorId (String): The authorId of the article to be removed from the list of saved articles.
  ///   articleId (String): The id of the article to be removed from the list of saved articles.
  ///
  /// Returns:
  ///   A new instance of MyArticleState with the updated savedArticlesDetails.
  MyArticleState unsaveArticle(
      {required String authorId, required String articleId}) {
    int indexOfArticleToRemove = savedArticlesDetails.indexWhere((element) =>
        (element.articleId == articleId && element.authorId == authorId));
    savedArticlesDetails.removeAt(indexOfArticleToRemove);
    return _updateState(updatedSavedArticleDetail: savedArticlesDetails);
  }

  /// It fetches the saved articles of the current user.
  ///
  /// Args:
  ///   currentUser (User): The current user object.
  ///
  /// Returns:
  ///   A Future<MyArticleState>
  Future<MyArticleState> fetchSavedArticles(User currentUser) async {
    // fetchingSavedArticlesStatus = FetchingSavedArticles.fetching;
    // call startfetchingsavedarticles
    List<Article> temp = [];
    try {
      List<dynamic> savedArticles = currentUser.savedArticles;
      for (var detail in savedArticles) {
        Article article = await getArticleDetail(
            authorId: detail['authorId'], articleId: detail['articleId']);
        temp.add(article);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    savedArticlesDetails = temp;
    return _updateState(updatedSavedArticleDetail: savedArticlesDetails);
    // fetchingSavedArticlesStatus = FetchingSavedArticles.fetched;
  }

  /// It deletes the article from the database and removes it from the list of published articles
  ///
  /// Args:
  ///   myUid (String): The uid of the user who is logged in.
  ///   articleId (String): The id of the article to be deleted.
  ///
  /// Returns:
  ///   A Future<MyArticleState>
  Future<MyArticleState> deleteThisArticle(
      {required String myUid, required String articleId}) async {
    try {
      final Response? response =
          await _apiServices.delete(endUrl: 'articles/$myUid/$articleId.json');
      if (response != null) {
        publishedArticles
            .removeWhere((element) => element.articleId == articleId);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return _updateState(updatedPublishedArticle: publishedArticles);
  }

  /// It deletes the article from the firebase database and removes it from the list of draft articles
  ///
  /// Args:
  ///   myUid (String): The user's uid.
  ///   articleId (String): The id of the article to be deleted.
  ///
  /// Returns:
  ///   The return type is a Future<MyArticleState>
  Future<MyArticleState> deleteDraftArticle(
      {required String myUid, required String articleId}) async {
    Logger logger = Logger("Delete this article");
    try {
      final Response? response = await _apiServices.delete(
          endUrl: 'draft-articles/$myUid/$articleId.json');
      if (response != null) {
        draftArticles.removeWhere((element) => element.articleId == articleId);
      }
    } catch (error) {
      debugPrint(error.toString());
    }

    return _updateState(updatedDraftArticle: draftArticles);
  }

  /// It takes in a userId, title and tags and then creates an article object and saves it to the
  /// database
  ///
  /// Args:
  ///   userId (String): The userId of the user who is uploading the article.
  ///   title (String): The title of the article
  ///   tags (List<String>): List of tags
  ///
  /// Returns:
  ///   The return type is a Future<MyArticleState>
  Future<MyArticleState> draftMyArticle({
    required String userId,
    required String title,
    required List<String> tags,
  }) async {
    // uploadingStatus = ArticleUploadingStatus.uploading;
    // notifyListeners();
    // call artcile loading
    try {
      List<ArticleBody> articleBody = [];
      int imageIndex = 0;
      for (BodyComponent bc in bodyComponents) {
        if (bc.type == "text") {
          if (bc.textEditingController != null) {}

          articleBody.add(
              ArticleBody(type: "text", text: bc.textEditingController!.text));
        } else {
          String? url = await getImageUrl(File(bc.fileImage!.path),
              'articles/$userId/$title/${imageIndex++}');
          articleBody.add(ArticleBody(
              type: "image", image: url, imageCaption: bc.imageCaption!.text));
        }
      }
      Article article = Article(
          category: "draft",
          title: title,
          body: articleBody,
          tags: tags,
          reports: [],
          articleCreated: DateTime.now(),
          articleId: '',
          authorId: userId);

      final Response? response = await _apiServices.post(
          endUrl: 'draft-articles/$userId.json', data: article.toJson());

      if (response != null) {
        final String articleId = response.data[
            'name']; // we do not need to decode as dio already does it for us.

        await _apiServices.update(
            endUrl: 'draft-articles/$userId/$articleId.json',
            data: {'articleId': articleId},
            message: "Article saved as draft ",
            showMessage: true);
        clearForm();
      }
    } catch (error) {
      Logger("Draft Article Method").shout(error.toString());
    }
    return await fetchDraftArticles(userId);
    // call stopuploadingarticle
  }

  /// It fetches the draft articles from the firebase database.
  ///
  /// Args:
  ///   myUid (String): The uid of the user who is logged in.
  ///
  /// Returns:
  ///   A Future<MyArticleState>
  Future<MyArticleState> fetchDraftArticles(String myUid) async {
    // start fetchingdraftarticle
    try {
      List<Article> tempDrafts = [];
      final Response? response =
          await _apiServices.get(endUrl: 'draft-articles/$myUid.json');
      if (response != null && response.data != null) {
        final Map<String, dynamic> responseData = response.data;
        for (var article in responseData.values) {
          Article art = Article.fromJson(article);
          tempDrafts.add(art);
        }
        draftArticles = tempDrafts;
        draftArticles
            .sort((a, b) => b.articleCreated.compareTo(a.articleCreated));
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return _updateState(updatedDraftArticle: draftArticles);
    // stopfetchingdraft article
  }
}
