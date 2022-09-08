import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/models/comment_model.dart';
import 'package:utopia/services/api/api_services.dart';
import 'package:utopia/view/screens/NewArticleScreen/new_article_screen.dart';

class BodyComponent {
  final String type;
  ArticleTextField? textFormField;
  Image? img;

  BodyComponent({required this.type, this.img, this.textFormField});
}

class NewArticleScreenController with ChangeNotifier {
  List<BodyComponent> bodyComponents = [];
  List<String> articleBody = [];
  List<TextEditingController> textControllers = [];
  List<XFile> images = [];
  final Logger _logger = Logger("NewArticleScreenController");
  final ApiServices _apiServices = ApiServices();

  addTextField() {
    TextEditingController textEditingController = TextEditingController();
    textControllers.add(textEditingController);
    ArticleTextField textField =
        ArticleTextField(controller: textControllers.last);
    bodyComponents
        .add(BodyComponent(type: "textfield", textFormField: textField));
    notifyListeners();
  }

  addImageField(XFile file) {
    bodyComponents.add(BodyComponent(
        type: "image", img: Image(image: FileImage(File(file.path)))));
    addTextField();
    // notifyListeners();
  }

  publishArticle() async {
    // try {
    //   Article article = Article(
    //       body: [
    //         ArticleBody(type: "text", image: null, text: 'new text'),
    //         ArticleBody(type: 'image', image: 'new image', text: null)
    //       ],
    //       articleCreated: DateTime.now(),
    //       articleId: 'some fake id',
    //       authorId: 'some id',
    //       comments: [
    //         Comment(
    //             comment: 'comment1',
    //             commentId: DateTime.now().toString() + 'some random',
    //             articleId: 'some fake id',
    //             userId: 'my uid')
    //       ],
    //       likes: []);
    //   final Response? response = await _apiServices.post(
    //       endUrl: 'articles.json', data: article.toJson());
    //   if (response != null) {
    //     _logger.info(response.data.toString());
    //   }
    try {
      await _apiServices
          .put(endUrl: 'articles/-NBQsMLGgkjI3GluznY4.json', data: {
        'comments': [
          Comment(
              comment: 'comment1',
              commentId: DateTime.now().toString() + 'some random',
              articleId: 'some fake',
              userId: 'my uid')
        ]
      });
    } catch (error) {
      _logger.shout(error.toString());
    }
  }

  addArticleBody() {}
}
