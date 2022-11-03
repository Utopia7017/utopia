
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<XFile?> pickImage(BuildContext context) async {
  final picker = ImagePicker();

  final androidInfo = await DeviceInfoPlugin().androidInfo;
  var permission = PermissionStatus.denied;
  if (androidInfo.version.sdkInt <= 32) {
    permission = await Permission.storage.request();
  } else {
    permission = await Permission.photos.request();
  }
  if (permission.isGranted) {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile;
    }
    return null;
  }
}
