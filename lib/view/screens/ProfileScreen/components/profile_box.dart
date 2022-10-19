import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/utils/helper_widgets.dart';
import 'package:utopia/utils/image_picker.dart';
import 'package:utopia/view/common_ui/profile_detail_box.dart';
import 'package:utopia/view/screens/ProfileScreen/components/edit_profile_dialogbox.dart';

class ProfileBox extends StatelessWidget {
  final User user;
  const ProfileBox({
    super.key,
    required this.user,
  });

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
    return Column(
      children: [
        SizedBox(
          height: displayHeight(context) * 0.56,
          width: displayWidth(context),
          child: Stack(
            children: [
              InkWell(
                onTap: () async {
                  // update cover photo
                  final sms = ScaffoldMessenger.of(context);
                  final userController =
                  Provider.of<UserController>(context,
                      listen: false);
                  XFile? pickCoverPhoto =
                  await pickImage(context);
                  if (pickCoverPhoto != null) {
                    CroppedFile? croppedFile = await cropImage(
                        File(pickCoverPhoto.path));
                    if (croppedFile != null) {
                      userController
                          .changeCoverPhoto(croppedFile);
                    } else {
                      // nothing to be done
                    }
                  } else {
                    sms.showSnackBar(const SnackBar(
                        content: Text("No image picked")));
                  }
                },
                child: (user.cp.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: user.cp,
                        height: displayHeight(context) * 0.25,
                        width: displayWidth(context),
                        fit: BoxFit.fitWidth,
                      )
                    : CachedNetworkImage(
                        imageUrl:
                            'https://i.pinimg.com/564x/21/65/0a/21650a0e6039a967ae95c2e03dfc3361.jpg',
                        width: displayWidth(context),
                        height: displayHeight(context) * 0.25,
                        fit: BoxFit.fitWidth,
                      ),
              ),
              Positioned(
                  top: displayHeight(context) * 0.03,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_outlined),
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  )),
              Positioned(
                left: displayWidth(context) * 0.05,
                right: displayWidth(context) * 0.05,
                top: displayHeight(context) * 0.18,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 1,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    height: displayHeight(context) * 0.3605,
                    width: displayWidth(context) * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // user dp
                            InkWell(
                              onTap: () async {
                                // update dp
                                final sms = ScaffoldMessenger.of(context);
                                final userController =
                                    Provider.of<UserController>(context,
                                        listen: false);
                                XFile? pickDisplayPhoto =
                                    await pickImage(context);
                                if (pickDisplayPhoto != null) {
                                  CroppedFile? croppedFile = await cropImage(
                                      File(pickDisplayPhoto.path));
                                  if (croppedFile != null) {
                                    userController
                                        .changeDisplayPhoto(croppedFile);
                                  } else {
                                    // nothing to be done
                                  }
                                } else {
                                  sms.showSnackBar(const SnackBar(
                                      content: Text("No image picked")));
                                }
                              },
                              child: (user.dp.isEmpty)
                                  ? Container(
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xfb7F7FD5),
                                                Color(0xfb86A8E7),
                                                Color(0xfb91EAE4),
                                              ],
                                              begin: Alignment.bottomLeft,
                                              end: Alignment.topRight),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height: displayHeight(context) * 0.13,
                                      width: displayWidth(context) * 0.22,
                                      alignment: Alignment.center,
                                      child: initials.length > 1
                                          ? Text(
                                              "$firstLetter.$lastLetter"
                                                  .toUpperCase(),
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
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: user.dp,
                                        height: displayHeight(context) * 0.13,
                                        width: displayWidth(context) * 0.22,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: displayWidth(context) * 0.04,
                            ),
                            // user name and bio
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                    // fontFamily: "Fira",
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                (user.bio.isNotEmpty)
                                    ? SizedBox(
                                        height: displayHeight(context) * 0.1,
                                        width: displayWidth(context) * 0.55,
                                        // color: Colors
                                        //     .blue.shade100,
                                        child: Text(
                                          user.bio,
                                          style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 12.2,
                                              // fontFamily:
                                              //     "Open",
                                              wordSpacing: 0.4),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: displayHeight(context) * 0.08,
                          width: displayWidth(context) * 0.6,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade100.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.only(
                              top: 4, left: 12, right: 12, bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileDetailBox(
                                value: 127,
                                label: "Followings",
                                callback: () {},
                              ),
                              ProfileDetailBox(
                                value: 500,
                                label: "Followers",
                                callback: () {},
                              ),
                              ProfileDetailBox(
                                value: 785,
                                label: "Articles",
                                callback: () {},
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: displayWidth(context) * 0.5,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(6),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              backgroundColor:
                                  MaterialStateProperty.all(authBackground),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return EditProfileDialogbox(
                                      currentName: user.name,
                                      currentBio: user.bio);
                                },
                              );
                            },
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                  fontFamily: "",
                                  letterSpacing: 0.4,
                                  color: Colors.white.withOpacity(0.85)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
