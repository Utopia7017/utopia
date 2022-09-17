import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../view/common_ui/article_textfield.dart';

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