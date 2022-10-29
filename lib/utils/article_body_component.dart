import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../view/common_ui/article_textfield.dart';

class BodyComponent {
  final String key;
  final String type;
  TextEditingController? textEditingController;
  ArticleTextField? textFormField;
  CroppedFile? fileImage;
  TextEditingController? imageCaption;
  Image? imageProvider;
  String? imageUrl;

  BodyComponent(
      {required this.type,
      required this.key,
      this.textFormField,
      this.imageCaption,
      this.fileImage,
      this.imageUrl,
      this.imageProvider,
      this.textEditingController});
}
