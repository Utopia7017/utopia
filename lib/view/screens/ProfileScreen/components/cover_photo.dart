import 'package:flutter/material.dart';
import 'package:utopia/utils/device_size.dart';

class ProfileCoverPhoto extends StatelessWidget {
  const ProfileCoverPhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: Image.network(
        'https://i.pinimg.com/564x/4b/c3/2a/4bc32a8918286626035f8cbcec113637.jpg',
        height: displayHeight(context) * 0.2,
        width: displayWidth(context),
        fit: BoxFit.cover,
      ),
    );
  }
}
