import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controlller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/ProfileScreen/components/cover_photo.dart';
import 'package:utopia/view/screens/ProfileScreen/components/profile_options.dart';
import 'package:utopia/view/screens/ProfileScreen/components/profile_overview.dart';

import '../../../utils/image_picker.dart';

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
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              const ProfileCoverPhoto(),
              Positioned(
                  bottom: 0,
                  child: Container(
                    height: displayHeight(context) * 0.8,
                    width: displayWidth(context),
                    color: primaryBackgroundColor,
                    child: Consumer<UserController>(
                      builder: (context, controller, child) {
                        switch (controller.profileStatus) {
                          case ProfileStatus.nil:
                            return Center(
                              child: MaterialButton(
                                color: authMaterialButtonColor,
                                onPressed: () {
                                  controller.setUser(
                                      FirebaseAuth.instance.currentUser!.uid);
                                },
                                child: const Text('Refresh Profile'),
                              ),
                            );
                          case ProfileStatus.loading:
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: authMaterialButtonColor),
                            );
                          case ProfileStatus.fetched:
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 60.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ProfileOverView(),
                                    Divider(
                                      color: Colors.grey.shade100,
                                      height: displayHeight(context) * 0.06,
                                      thickness: displayHeight(context) * 0.025,
                                    ),
                                    ProfileOptions(),
                                  ],
                                ),
                              ),
                            );
                        }
                      },
                    ),
                  )),
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
              Positioned(
                top: displayHeight(context) * 0.13,
                child: InkWell(
                  onTap: () async {
                    XFile? imageFile = await pickImage(context);
                    if (imageFile != null) {

                    }

                  },
                  child: CircleAvatar(
                    radius: displayWidth(context) * 0.13,
                    backgroundImage: const NetworkImage(
                        'https://i.pinimg.com/564x/17/b0/8f/17b08fc3ad0e62df60e15ef557ec3fe1.jpg'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
