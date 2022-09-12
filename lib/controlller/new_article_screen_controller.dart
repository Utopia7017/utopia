import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:utopia/models/article_body_model.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/services/api/api_services.dart';
import 'package:utopia/services/firebase/storage_service.dart';
import 'package:utopia/utils/helper_widgets.dart';
import '../utils/article_body_component.dart';
import '../utils/article_textfield.dart';

class NewArticleScreenController with ChangeNotifier {
  List<BodyComponent> bodyComponents = [];
  String? category;
  final Logger _logger = Logger("NewArticleScreenController");
  final ApiServices _apiServices = ApiServices();

  // adds a new text field to body component list
  void addTextField() {
    TextEditingController textEditingController = TextEditingController();
    ArticleTextField textField =
        ArticleTextField(controller: textEditingController);

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
      if (bc.textEditingController!.text.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  // adds a new image provider to body component list
  void addImageField(XFile file) {
    bodyComponents.add(BodyComponent(
        type: "image",
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
    ArticleTextField textField = ArticleTextField(controller: ctr);

    bodyComponents.insert(
        indexOfBodyComponentToBeUpdated,
        BodyComponent(
            type: "text",
            key: DateTime.now().toString(),
            textEditingController: ctr,
            textFormField: textField));
    notifyListeners();
  }

  publishArticle({
    required String userId,
    required String title,
    required List<String> tags,
  }) async {
    try {
      List<ArticleBody> articleBody = [];
      int imageIndex = 0;
      for (BodyComponent bc in bodyComponents) {
        if (bc.type == "text" && bc.textEditingController!.text.isNotEmpty) {
          articleBody.add(
              ArticleBody(type: "text", text: bc.textEditingController!.text));
        } else {
          String? url = await getImageUrl(File(bc.fileImage!.path),
              'articles/$userId/$title/${imageIndex++}');
          articleBody.add(ArticleBody(type: "image", image: url));
        }
      }
      Article article = Article(
          body: articleBody,
          tags: tags,
          reports: [],
          articleCreated: DateTime.now(),
          articleId: '',
          authorId: userId);
      final Response? response = await _apiServices.post(
          endUrl: 'articles/$userId.json', data: article.toJson());
      if (response != null) {
        final String articleId = response.data['name']; // we do not need to decode as dio already does it for us.

        _logger.info('article id $articleId');
        await _apiServices.update(
            endUrl: 'articles/$userId/$articleId.json',
            data: {'articleId': articleId});
        _logger.info("Article Posted Successfully");
      }
    } catch (error) {
      _logger.shout(error.toString());
    }
  }

  addArticleBody() {}
}
