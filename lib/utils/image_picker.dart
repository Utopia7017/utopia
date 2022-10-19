import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<XFile?> pickImage(BuildContext context) async {
  final picker = ImagePicker();
  if (await Permission.photos.isGranted) {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile;
    }
    return null;
  }
}
