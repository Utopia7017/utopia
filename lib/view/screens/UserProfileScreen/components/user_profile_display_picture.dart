import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';

class UserProfileDisplayPicture extends StatelessWidget {
  final User user;
  const UserProfileDisplayPicture({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> initials = user.name.split(" ");
    String firstLetter = "", lastLetter = "";

    if (initials.length == 1) {
      firstLetter = initials[0].characters.first;
    } else {
      firstLetter = initials[0].characters.first;
      lastLetter = initials[1].characters.first;
    }

    return Positioned(
      top: displayHeight(context) * 0.13,
      child: (user.dp.isEmpty)
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
              backgroundImage: CachedNetworkImageProvider(user.dp),
            ),
    );
  }
}
