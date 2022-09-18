import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controlller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/services/firebase/storage_service.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/image_picker.dart';

class ProfileCoverPhoto extends StatelessWidget {
  const ProfileCoverPhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, controller , child) {
        if(controller.userUploadingImage == UserUploadingImage.notLoading){
          return InkWell(
            onTap: ()  async {
              XFile? imageFile = await pickImage(context);
              if (imageFile != null) {
                controller.changedp(imageFile);
              }
            },
            child: Positioned(
              top: 0,
              child: Image.network(
                'https://i.pinimg.com/564x/4b/c3/2a/4bc32a8918286626035f8cbcec113637.jpg',
                height: displayHeight(context) * 0.2,
                width: displayWidth(context),
                fit: BoxFit.cover,
              ),
            ),
          );
        }
        else{
          return CircularProgressIndicator();
        }

      },

    );
  }
}
