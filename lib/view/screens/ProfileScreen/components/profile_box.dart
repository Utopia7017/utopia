import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/profile_detail_box.dart';
import 'package:utopia/view/screens/ProfileScreen/components/edit_profile_dialogbox.dart';

class ProfileBox extends StatelessWidget {
  final String coverPhoto;
  final String dp;
  final String name;
  final int followers;
  final int following;
  final int numberOfArticles;
  final String bio;

  const ProfileBox(
      {super.key,
      required this.coverPhoto,
      required this.dp,
      required this.name,
      required this.followers,
      required this.following,
      required this.numberOfArticles,
      required this.bio});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: displayHeight(context) * 0.56,
          width: displayWidth(context),
          child: Stack(
            children: [
              (coverPhoto.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: coverPhoto,
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: dp,
                                height: displayHeight(context) * 0.13,
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
                                  name,
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
                                (bio.isNotEmpty)
                                    ? SizedBox(
                                        height: displayHeight(context) * 0.1,
                                        width: displayWidth(context) * 0.55,
                                        // color: Colors
                                        //     .blue.shade100,
                                        child: Text(
                                          bio,
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
                                      currentName: name, currentBio: bio);
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
