import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/ProfileScreen/components/profile_box.dart';
import 'package:utopia/view/screens/ProfileScreen/components/top_articles_list.dart';
import 'package:utopia/view/screens/Skeletons/rec_article_skeleton.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  final space = const SizedBox(height: 10);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SizedBox(
          height: displayHeight(context),
          width: displayWidth(context),
          child: Consumer<UserController>(
            builder: (context, userController, child) {
              if (userController.profileStatus == ProfileStatus.nil) {
                userController.setUser(FirebaseAuth.instance.currentUser!.uid);
              }

              switch (userController.profileStatus) {
                case ProfileStatus.nil:
                  return const Center(
                    child: Text('Swipe to fetch profile'),
                  );
                case ProfileStatus.loading:
                  // TODO: Show shimmer effect

                  return const Center(
                    child: CircularProgressIndicator(
                        color: authMaterialButtonColor),
                  );
                case ProfileStatus.fetched:
                  // Profile is fetched
                  switch (userController.userUploadingImage) {
                    // user is uploading image
                    case UserUploadingImage.loading:
                      // todo : display good message while user is uploading image
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Center(
                              child: CircularProgressIndicator(
                                  color: authMaterialButtonColor),
                            ),
                            SizedBox(height: 10),
                            Text('Uploading image')
                          ],
                        ),
                      );
                    // user is not not uploading image
                    case UserUploadingImage.notLoading:
                      return SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile box
                            ProfileBox(user: userController.user!),
                            const SizedBox(height: 10),
                            // Recent Articles or Top 10 articles
                            TopArticlesList(user: userController.user!),
                          ],
                        ),
                      );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
