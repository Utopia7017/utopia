import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:utopia/services/api/api_services.dart';
import 'package:utopia/services/firebase/storage_service.dart';
import '../utils/article_body_component.dart';
import '../utils/article_textfield.dart';

class NewArticleScreenController with ChangeNotifier {
  List<BodyComponent> bodyComponents = [];
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

  publishArticle() async {
    try {
      List<String> stringList = [];
      int index = -1;
      for (BodyComponent bc in bodyComponents) {
        index++;
        if (bc.type == 'text') {
          stringList.add(bc.textEditingController!.text);
        } else {
          String? url = await getImageUrl(File(bc.fileImage!.path), index);
          if (url != null) {
            stringList.add(url);
          }
        }
      }
      _logger.info(stringList);
    } catch (error) {
      _logger.shout(error.toString());
    }
  }

  addArticleBody() {}
}
