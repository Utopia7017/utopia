import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utopia/constants/color_constants.dart';

drawerTile(String title, String icon, Function() callbackAction) {
  return ListTile(
    onTap: callbackAction,
    contentPadding: EdgeInsets.zero,
    leading: Image.asset(
      icon,
      height: 20,
      color: Colors.grey,
    ),
    visualDensity: const VisualDensity(vertical: -3.5),
    minLeadingWidth: 1,
    title: Text(
      title,
      style: const TextStyle(
          fontSize: 13.5,
          color: Colors.white,
          fontFamily: "Open",
          letterSpacing: 0.6),
    ),
  );
}

Future<CroppedFile?> cropImage(File pickedFile) async {
  CroppedFile? croppedFile =
      await ImageCropper().cropImage(sourcePath: pickedFile.path, uiSettings: [
    AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
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
              ]),
    IOSUiSettings(
      title: 'Cropper',
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
      ],
    ),
  ]);
  if (croppedFile != null) {
    return croppedFile;
  } else {
    return null;
  }
}

// Show custom snackbar
showCustomSnackBar({
  required BuildContext context,
  required String text,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: authMaterialButtonColor,
      content: Text(
        text,
        style: const TextStyle(color: Colors.black, fontFamily: "Open"),
      )));
}

openUrl(String link) async {
  if (await launchUrl(
    Uri.parse(link),
    mode: LaunchMode.externalApplication,
  )) {}
}

mailTo() {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'starcoding7@gmail.com',
  );
  launchUrl(emailLaunchUri);
}
