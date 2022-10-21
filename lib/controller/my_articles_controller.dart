import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:utopia/controller/disposable_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_body_model.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/saved_article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/services/api/api_services.dart';
import 'package:utopia/services/firebase/storage_service.dart';
import '../utils/article_body_component.dart';
import '../view/common_ui/article_textfield.dart';

class MyArticlesController extends DisposableProvider {
  ArticleUploadingStatus uploadingStatus = ArticleUploadingStatus.notUploading;
  List<BodyComponent> bodyComponents = [];
  List<Article> publishedArticles = [];
  List<Article> draftArticles = [];
  List<SavedArticle> savedArticles = [];
  List<Article> savedArticlesDetails = [];
  FetchingMyArticle fetchingMyArticleStatus = FetchingMyArticle.nil;
  String? category;
  final Logger _logger = Logger("MyArticlesController");
  final ApiServices _apiServices = ApiServices();
  FetchingSavedArticles fetchingSavedArticlesStatus = FetchingSavedArticles.nil;

  // adds a new text field to body component list
  void addTextField() {
    TextEditingController textEditingController =
        TextEditingController(text: "");
    ArticleTextField textField = ArticleTextField(
      controller: textEditingController,
      isFirstTextBox: (bodyComponents.isEmpty),
    );

    bodyComponents.add(BodyComponent(
        type: "text",
        key: DateTime.now().toString(),
        textEditingController: textEditingController,
        textFormField: textField));
    notifyListeners();
  }

  // selects article category
  void changeCategory(String newCategory) {
    category = newCategory;
    notifyListeners();
  }

  // validates the article body, returns false if all the text editing controllers contains empty string
  bool validateArticleBody() {
    for (BodyComponent bc in bodyComponents) {
      if (bc.type == 'text') {
        if (bc.textEditingController != null &&
            bc.textEditingController!.text.isNotEmpty) {
          return true;
        }
      }
    }

    return false;
  }

  // adds a new image provider to body component list
  void addImageField(CroppedFile file) {
    TextEditingController imageCaptionController = TextEditingController();
    bodyComponents.add(BodyComponent(
        type: "image",
        imageCaption: imageCaptionController,
        key: DateTime.now().toString(),
        imageProvider: Image(image: FileImage(File(file.path))),
        fileImage: file));
    addTextField();
  }

  // removes the selected image and its successive body component
  void removeImage(List<BodyComponent> sublist) {
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
    notifyListeners();
  }

  // clears the new article form
  clearForm() {
    bodyComponents.clear();
    addTextField();
  }

  // publishes the article
  publishArticle({
    required String userId,
    required String title,
    required List<String> tags,
  }) async {
    uploadingStatus = ArticleUploadingStatus.uploading;
    notifyListeners();
    try {
      List<ArticleBody> articleBody = [];
      int imageIndex = 0;
      for (BodyComponent bc in bodyComponents) {
        if (bc.type == "text") {
          if (bc.textEditingController != null) {
            print("enter ${bc.textEditingController!.text}");
          }

          articleBody.add(
              ArticleBody(type: "text", text: bc.textEditingController!.text));
        } else {
          String? url = await getImageUrl(File(bc.fileImage!.path),
              'articles/$userId/$title/${imageIndex++}');
          articleBody.add(ArticleBody(type: "image", image: url,imageCaption :bc.imageCaption!.text));
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

      if (response != null) {
        final String articleId = response.data[
            'name']; // we do not need to decode as dio already does it for us.

        await _apiServices.update(
            endUrl: 'articles/$userId/$articleId.json',
            data: {'articleId': articleId},
            message: "Article published successfully",
            showMessage: true);
        clearForm();
      }
    } catch (error) {
      Logger("Publish Article Method").shout(error.toString());
    }
    uploadingStatus = ArticleUploadingStatus.notUploading;
    notifyListeners();
  }

  // Fetch my articles
  fetchMyArticles(String myUid) async {
    Logger logger = Logger("FetchMyArticles");
    fetchingMyArticleStatus = FetchingMyArticle.fetching;
    await Future.delayed(const Duration(milliseconds: 1));
    notifyListeners();
    try {
      List<Article> tempPublished = [];
      List<Article> tempDrafts = [];
      final Response? response =
          await _apiServices.get(endUrl: 'articles/$myUid.json');
      if (response != null) {
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
      _logger.shout(error.toString());
    }
    fetchingMyArticleStatus = FetchingMyArticle.fetched;
    notifyListeners();
  }

  // Save article -> Article is required
  saveArticle({required article}) {
    savedArticlesDetails.add(article);
    notifyListeners();
  }

  // Unsave article -> article id and author id are required
  unsaveArticle({required String authorId, required String articleId}) {
    int indexOfArticleToRemove = savedArticlesDetails.indexWhere((element) =>
        (element.articleId == articleId && element.authorId == authorId));
    savedArticlesDetails.removeAt(indexOfArticleToRemove);
    notifyListeners();
  }

  // Fetch details of saved articles (authorId and articleId)
  fetchSavedArticles(User currentUser) async {
    fetchingSavedArticlesStatus = FetchingSavedArticles.fetching;
    await Future.delayed(const Duration(microseconds: 1));
    notifyListeners();
    Logger logger = Logger("GetArticleDetail");
    List<Article> temp = [];
    try {
      List<dynamic> savedArticles = currentUser.savedArticles;
      for (var detail in savedArticles) {
        Article article = await getArticleDetail(
            authorId: detail['authorId'], articleId: detail['articleId']);
        temp.add(article);
      }
    } catch (error) {
      logger.shout(error.toString());
    }
    savedArticlesDetails = temp;
    fetchingSavedArticlesStatus = FetchingSavedArticles.fetched;
    notifyListeners();
  }

  // Returns detail of article, if provided authorId and articleId
  Future<Article> getArticleDetail(
      {required String authorId, required String articleId}) async {
    late Article article;
    Logger logger = Logger("GetArticleDetail");
    try {
      final Response? articleResponse =
          await _apiServices.get(endUrl: 'articles/$authorId/$articleId.json');
      if (articleResponse != null) {
        article = Article.fromJson(articleResponse.data);
      }
    } catch (error) {
      logger.shout(error.toString());
    }
    return article;
  }

  // Deletes articles
  deleteThisArticle({required String myUid, required String articleId}) async {
    Logger logger = Logger("Delete this article");
    try {
      final Response? response =
          await _apiServices.delete(endUrl: 'articles/$myUid/$articleId.json');
      if (response != null) {
        publishedArticles
            .removeWhere((element) => element.articleId == articleId);
      }
    } catch (error) {
      logger.shout(error.toString());
    }
    notifyListeners();
  }

  @override
  void disposeValues() {
    uploadingStatus = ArticleUploadingStatus.notUploading;
    bodyComponents = [];
    publishedArticles = [];
    draftArticles = [];
    savedArticles = [];
    savedArticlesDetails = [];
    fetchingMyArticleStatus = FetchingMyArticle.nil;
    category = null;
    fetchingSavedArticlesStatus = FetchingSavedArticles.nil;
  }
}
