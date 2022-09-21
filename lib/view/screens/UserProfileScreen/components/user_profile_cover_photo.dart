import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';

class UserProfileCoverPicture extends StatelessWidget {
  final User user;
  const UserProfileCoverPicture({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: (user.cp.isNotEmpty)
          ? CachedNetworkImage(
              imageUrl: user.cp,
              height: displayHeight(context) * 0.2,
              width: displayWidth(context),
              fit: BoxFit.cover,
            )
          : CachedNetworkImage(
              imageUrl:
                  'https://i.pinimg.com/564x/21/65/0a/21650a0e6039a967ae95c2e03dfc3361.jpg',
              height: displayHeight(context) * 0.2,
              width: displayWidth(context),
              fit: BoxFit.cover,
            ),
    );
  }
}
