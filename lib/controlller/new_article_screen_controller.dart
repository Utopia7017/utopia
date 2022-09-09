import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:utopia/services/api/api_services.dart';
import 'package:utopia/view/screens/NewArticleScreen/new_article_screen.dart';

class BodyComponent {
  final String key;
  final String type;
  TextEditingController? textEditingController;
  ArticleTextField? textFormField;
  XFile? fileImage;
  Image? imageProvider;

  BodyComponent(
      {required this.type,
      required this.key,
      this.textFormField,
      this.fileImage,
      this.imageProvider,
      this.textEditingController});
}

class NewArticleScreenController with ChangeNotifier {
  List<BodyComponent> bodyComponents = [];
  final Logger _logger = Logger("NewArticleScreenController");
  final ApiServices _apiServices = ApiServices();

  addTextField() {
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

  addImageField(XFile file) {
    bodyComponents.add(BodyComponent(
        type: "image",
        key: DateTime.now().toString(),
        imageProvider: Image(image: FileImage(File(file.path))),
        fileImage: file));
    addTextField();
  }

  // copyText(int bodyComponentIndexTo, int bodyComponentIndexFrom) {}

  removeImage(List<BodyComponent> sublist) {
    _logger.info(sublist.length);
    for (BodyComponent bc in sublist) {
      print(bc.key);
    }

    int indexOfBodyComponentToBeUpdated = bodyComponents
        .indexWhere((element) => element.key == sublist.first.key);
    TextEditingController ctr = TextEditingController(
        text: "${sublist.first.textEditingController!.text} ${sublist.last.textEditingController!.text}");
    bodyComponents.removeWhere((element) => element.key == sublist[0].key);
    bodyComponents.removeWhere((element) => element.key == sublist[1].key);
    bodyComponents.removeWhere((element) => element.key == sublist[2].key);
    ArticleTextField textField =
    ArticleTextField(controller: ctr);

    bodyComponents.insert(indexOfBodyComponentToBeUpdated, BodyComponent(
        type: "text",
        key: DateTime.now().toString(),
        textEditingController: ctr,
        textFormField: textField));
    // bodyComponents.removeAt(bodyComponentIndex);
    // bodyComponents.removeAt(bodyComponentIndex + 1);
    notifyListeners();
  }

  publishArticle() async {
    try {
      List<String> stringList = [];
      for(BodyComponent bc in bodyComponents){
        if(bc.type=='text'){
          stringList.add(bc.textEditingController!.text);
        }
      }
      _logger.info(stringList);
    } catch (error) {
      _logger.shout(error.toString());
    }
  }

  addArticleBody() {}
}
