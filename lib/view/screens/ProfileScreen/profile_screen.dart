import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/ProfileScreen/components/cover_photo.dart';
import 'package:utopia/view/screens/ProfileScreen/components/display_picture.dart';
import 'package:utopia/view/screens/ProfileScreen/components/profile_options.dart';
import 'package:utopia/view/screens/ProfileScreen/components/profile_overview.dart';

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
            builder: (context, controller, child) {
              if (controller.profileStatus == ProfileStatus.nil) {
                controller.setUser(FirebaseAuth.instance.currentUser!.uid);
              }

              switch (controller.profileStatus) {
                case ProfileStatus.nil:
                  return const Center(
                    child: Text('Swipe to fetch profile'),
                  );
                case ProfileStatus.loading:
                  return const Center(
                    child: CircularProgressIndicator(
                        color: authMaterialButtonColor),
                  );
                case ProfileStatus.fetched:
                  switch (controller.userUploadingImage) {
                    case UserUploadingImage.loading:
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
                    case UserUploadingImage.notLoading:
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          ProfileCoverPhoto(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ProfileOverView(),
                                      Divider(
                                        color: Colors.grey.shade100,
                                        height: displayHeight(context) * 0.06,
                                        thickness:
                                            displayHeight(context) * 0.025,
                                      ),
                                      ProfileOptions(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              top: kToolbarHeight -
                                  displayHeight(context) * 0.03,
                              left: displayWidth(context) * 0.02,
                              child: IconButton(
                                  iconSize: 30,
                                  color: Colors.white70,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back))),
                          ProfileDisplayPicture(),
                        ],
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
