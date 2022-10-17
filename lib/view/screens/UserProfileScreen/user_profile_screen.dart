import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/articles_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/article_box.dart';
import 'package:utopia/view/common_ui/profile_detail_box.dart';
import '../Skeletons/user_profile_overview_skeleton.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  final space = const SizedBox(height: 10);
  final verticalSpace = VerticalDivider(
    indent: 12,
    endIndent: 12,
    thickness: 0.5,
    color: Colors.grey.shade400,
    width: 15,
  );
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: Provider.of<UserController>(context, listen: false)
              .getUser(userId),
          builder: (context, AsyncSnapshot<User?> userSnapshot) {
            // If user is fetched
            if (userSnapshot.hasData) {
              User thisUser = userSnapshot.data!;
              List<String> initials = thisUser.name.split(" ");
              String firstLetter = "", lastLetter = "";

              if (initials.length == 1) {
                firstLetter = initials[0].characters.first;
              } else {
                firstLetter = initials[0].characters.first;
                lastLetter = initials[1].characters.first;
              }

              return FutureBuilder(
                future: Provider.of<ArticlesController>(context, listen: false)
                    .fetchThisUsersArticles(userId),
                builder:
                    (context, AsyncSnapshot<List<Article>> articlesSnapshot) {
                  if (articlesSnapshot.hasData) {
                    List<Article> articles = articlesSnapshot.data!;
                    List<String> tags = [];
                    for (Article art in articles) {
                      for (String tag in art.tags) {
                        if (tag.isNotEmpty) {
                          tags.add(tag);
                        }
                      }
                    }
                    return SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: displayHeight(context) * 0.3,
                            width: displayWidth(context),
                            child: Stack(
                              children: [
                                Image.network(
                                  thisUser.cp,
                                  width: displayWidth(context),
                                  height: displayHeight(context) * 0.26,
                                  fit: BoxFit.fitWidth,
                                ),
                                Container(
                                  height: displayHeight(context) * 0.28,
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                        Colors.transparent,
                                        Colors.white
                                      ],
                                          stops: [
                                        0,
                                        .8
                                      ])),
                                ),
                                Positioned(
                                  top: displayHeight(context) * 0.03,
                                  left: displayWidth(context) * 0.01,
                                  child: IconButton(
                                      iconSize: 25,
                                      color: Colors.black,
                                      onPressed: () => Navigator.pop(context),
                                      icon:
                                          const Icon(Icons.keyboard_backspace)),
                                ),
                                Positioned(
                                  top: displayHeight(context) * 0.03,
                                  right: displayWidth(context) * 0.01,
                                  child: PopupMenuButton(
                                    onSelected: (value) async {
                                      switch (value) {
                                        case 'Block Author':
                                        
                                          await Provider.of<UserController>(context,
                                                  listen: false)
                                              .blockThisUser(userId);
                                          break;
                                        case 'Report Author':
                                          print("lorem ipsum");
                                          break;
                                        default:
                                          print("lorem ipsum");
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem(
                                          height: 40,
                                          value: "Block Author",
                                          child: Text(
                                            'Block Author',
                                          )),
                                      const PopupMenuItem(
                                        height: 40,
                                        value: "Report Author",
                                        child: Text('Report Author'),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: displayHeight(context) * 0.15,
                                  left: 16,
                                  child: (thisUser.dp.isEmpty)
                                      ? CircleAvatar(
                                          radius: displayWidth(context) * 0.12,
                                          backgroundColor: Colors.orange,
                                          child: CircleAvatar(
                                            radius:
                                                displayWidth(context) * 0.117,
                                            backgroundColor: Colors.white,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  authMaterialButtonColor,
                                              radius:
                                                  displayWidth(context) * 0.11,
                                              child: Center(
                                                child: initials.length > 1
                                                    ? Text(
                                                        "$firstLetter.$lastLetter"
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : Text(
                                                        firstLetter
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: displayWidth(context) * 0.12,
                                          backgroundColor: Colors.orange,
                                          child: CircleAvatar(
                                            radius:
                                                displayWidth(context) * 0.117,
                                            backgroundColor: Colors.white,
                                            child: CircleAvatar(
                                              radius:
                                                  displayWidth(context) * 0.11,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      thisUser.dp),
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Consumer<UserController>(
                              builder: (context, controller, child) {
                            if (controller.followingUserStatus ==
                                FollowingUserStatus.no) {
                              return FutureBuilder<User?>(
                                future: controller.getUser(userId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    User user = snapshot.data!;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        space,
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            user.name,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: "Fira",
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        space,
                                        user.bio.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text(
                                                  user.bio,
                                                  style: const TextStyle(
                                                      fontSize: 13.5,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black54),
                                                ),
                                              )
                                            : const SizedBox(),
                                        user.bio.isNotEmpty
                                            ? space
                                            : const SizedBox(),
                                        Center(
                                          child: SizedBox(
                                            width: displayWidth(context) * 0.35,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        6),
                                                shape: MaterialStateProperty
                                                    .all(RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15))),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        authBackground),
                                              ),
                                              onPressed: () {
                                                if (user.followers.contains(
                                                    controller.user!.userId)) {
                                                  controller.unFollowUser(
                                                      userId: userId);
                                                } else {
                                                  controller.followUser(
                                                      userId: user.userId);
                                                }
                                              },
                                              child: Text(
                                                (user.followers.contains(
                                                        controller
                                                            .user!.userId))
                                                    ? "Unfollow"
                                                    : "Follow",
                                                style: TextStyle(
                                                    fontFamily: "",
                                                    letterSpacing: 0.4,
                                                    color: Colors.white
                                                        .withOpacity(0.85)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Container(
                                          height: displayHeight(context) * 0.1,
                                          // color: Colors.blue.shade100,
                                          width: displayWidth(context),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ProfileDetailBox(
                                                  value: user.following.length,
                                                  label: "Following",
                                                  callback: () => null),
                                              verticalSpace,
                                              ProfileDetailBox(
                                                  value: user.followers.length,
                                                  label: "Followers",
                                                  callback: () => null),
                                              verticalSpace,
                                              ProfileDetailBox(
                                                  value: 0,
                                                  label: "Articles",
                                                  callback: () => null),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  } else {
                                    return Shimmer.fromColors(
                                        baseColor: Colors.black54,
                                        highlightColor: Colors.black,
                                        enabled: true,
                                        child: UserProfileOverviewSkeleton());
                                  }
                                },
                              );
                            } else {
                              return Shimmer.fromColors(
                                  baseColor: Colors.black54,
                                  highlightColor: Colors.black,
                                  enabled: true,
                                  child: UserProfileOverviewSkeleton());
                            }
                          }),
                          space,
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text(
                              "Talks about",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Fira"),
                            ),
                          ),
                          space,
                          SizedBox(
                            height: displayHeight(context) * 0.065,
                            width: displayWidth(context),
                            // color: Colors.blue.shade100,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(left: 8),
                              itemCount: tags.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                int randomIndex =
                                    random.nextInt(listOfCardColors.length);
                                Color cardColor = listOfCardColors[randomIndex];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  color: cardColor,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12,
                                        top: 8,
                                        bottom: 8),
                                    child: Center(
                                      child: Text(
                                        tags[index],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          ListView.builder(
                            itemBuilder: (context, index) {
                              return ArticleBox(article: articles[index]);
                            },
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: articles.length,
                          )
                        ],
                      ),
                    );
                  } else {
                    // TODO : return shimmer effect for whole screen
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            }
            // if user is not fetched
            else {
              // TODO : return shimmer effect for whole screen
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
