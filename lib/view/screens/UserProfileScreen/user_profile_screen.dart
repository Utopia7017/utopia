import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/ProfileScreen/components/profile_overview.dart';
import 'package:utopia/view/screens/UserProfileScreen/components/user_profile_cover_photo.dart';
import 'package:utopia/view/screens/UserProfileScreen/components/user_profile_display_picture.dart';
import 'package:utopia/view/screens/UserProfileScreen/components/user_profile_overview.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: false,
      child: SizedBox(
          height: displayHeight(context),
          width: displayWidth(context),
          child: FutureBuilder(
            future: Provider.of<UserController>(context, listen: false)
                .getUser(userId),
            builder: (context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Cover photo of user
                    UserProfileCoverPicture(user: snapshot.data!),

                    // Back icon for navigating back
                    Positioned(
                        top: kToolbarHeight - displayHeight(context) * 0.03,
                        left: displayWidth(context) * 0.02,
                        child: IconButton(
                            iconSize: 30,
                            color: Colors.white70,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back))),

                    // Profile overview
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: displayHeight(context) * 0.8,
                        width: displayWidth(context),
                        color: primaryBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Displays the user name , follow button and followers / followings detail
                                UserProfileOverView(user: snapshot.data!),
                                Divider(
                                  color: Colors.grey.shade100,
                                  height: displayHeight(context) * 0.06,
                                  thickness: displayHeight(context) * 0.025,
                                ),
                                // ProfileOptions(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Display picture of user
                    UserProfileDisplayPicture(user: snapshot.data!),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
    ));
  }
}
