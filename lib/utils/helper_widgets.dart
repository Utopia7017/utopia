import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

drawerTile(String title, String icon, Function() callbackAction) {
  return ListTile(
    onTap: callbackAction,
    contentPadding: EdgeInsets.zero,
    leading: Image.asset(
      icon,
      height: 20,
      color: Colors.grey,
    ),
    visualDensity: const VisualDensity(vertical: -3),
    minLeadingWidth: 1,
    title: Text(
      title,
      style: const TextStyle(
          fontSize: 13.5,
          color: Colors.white,
          fontFamily: "Fira",
          letterSpacing: 0.6),
    ),
  );
}

Future<CroppedFile?> cropImage(File pickedFile) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      ]);
  if (croppedFile != null) {
    return croppedFile;
  } else {
    return null;
  }
  
}
