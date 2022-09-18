import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/image_picker.dart';

class ProfileDisplayPicture extends StatelessWidget {
  final Logger _logger = Logger("ProfileDisplayPicture");
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: displayHeight(context) * 0.13,
      child: Consumer<UserController>(
        builder: (context, controller, child) {
          List<String> initials = controller.user!.name.split(" ");
          String firstLetter = "", lastLetter = "";

          if (initials.length == 1) {
            firstLetter = initials[0].characters.first;
          } else {
            firstLetter = initials[0].characters.first;
            lastLetter = initials[1].characters.first;
          }
          return InkWell(
            onTap: () async {
              XFile? pickCoverPhoto = await pickImage(context);
              if (pickCoverPhoto != null) {
                _logger.info("Picked valid image");
                controller.changeDisplayPhoto(pickCoverPhoto);
              } else {
                _logger.info("User did not pick any image");
              }
            },
            child: (controller.user!.dp.isEmpty)
                ? CircleAvatar(
                    backgroundColor: authMaterialButtonColor,
                    radius: displayWidth(context) * 0.13,
                    child: Center(
                      child: initials.length > 1
                          ? Text(
                              "$firstLetter.$lastLetter".toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            )
                          : Text(
                              firstLetter.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                    ),
                  )
                : CircleAvatar(
                    radius: displayWidth(context) * 0.13,
                    backgroundImage:
                        CachedNetworkImageProvider(controller.user!.dp),
                  ),
          );
        },
      ),
    );
  }
}
