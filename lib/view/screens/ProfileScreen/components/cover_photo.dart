import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/image_picker.dart';

class ProfileCoverPhoto extends StatelessWidget {
  final Logger _logger = Logger("ProfileCoverPhoto");

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: Consumer<UserController>(
        builder: (context, controller, child) {
          return InkWell(
            onTap: () async {
              XFile? pickCoverPhoto = await pickImage(context);
              if (pickCoverPhoto != null) {
                _logger.info("Picked valid image");
                controller.changeCoverPhoto(pickCoverPhoto);
              } else {
                _logger.info("User did not pick any image");
              }
            },
            child: (controller.user!.cp.isNotEmpty)
                ? CachedNetworkImage(
                    imageUrl: controller.user!.cp,
                    height: displayHeight(context) * 0.3,
                    width: displayWidth(context),
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl:
                        'https://i.pinimg.com/564x/21/65/0a/21650a0e6039a967ae95c2e03dfc3361.jpg',
                    height: displayHeight(context) * 0.3,
                    width: displayWidth(context),
                    fit: BoxFit.cover,
                  ),
          );
        },
      ),
    );
  }
}
