import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/articles_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/article_box.dart';
import 'package:utopia/view/screens/UserProfileScreen/user_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  //final usermodel.User searchedAuthors;
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final String myUserId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController queryController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(headerSliverBuilder:
            (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                toolbarHeight: displayHeight(context) * 0.1,
                backgroundColor: authBackground,
                title: SizedBox(
                  height: displayHeight(context) * 0.055,
                  child: Consumer<ArticlesController>(
                    builder: (context, controller, child) {
                      return TextFormField(
                        controller: queryController,
                        onChanged: (query) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce =
                              Timer(const Duration(milliseconds: 500), () {
                            controller.search(query);
                          });
                        },
                        cursorColor: Colors.black87,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            hintText: "Search articles, users and tags",
                            hintStyle: const TextStyle(fontSize: 13.5),
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.black54,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.grey))),
                      );
                    },
                  ),
                ),
                floating: true,
                pinned: true,
                snap: false,
                elevation: 0,
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: const UnderlineTabIndicator(
                      insets: EdgeInsets.only(bottom: 8),
                    ),
                    tabs: const [
                      Tab(text: 'Articles'),
                      Tab(text: 'Authors'),
                    ]),
              ),
            ),
          ];
        }, body: Consumer<ArticlesController>(
          builder: (context, controller, child) {
            return TabBarView(
              controller: _tabController,
              children: [
                // Display searched articles
                controller.searchedArticles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              noArticleFoundIcon,
                              height: displayHeight(context) * 0.1,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "No article found",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Open"),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding:
                            EdgeInsets.only(top: displayHeight(context) * 0.06),
                        itemCount: controller.searchedArticles.length,
                        itemBuilder: (context, index) {
                          return ArticleBox(
                              article: controller.searchedArticles[index]);
                        },
                      ),

                // Display searched authors
                (controller.searchedAuthors.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              noUserFoundIcon,
                              height: displayHeight(context) * 0.1,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "No users found",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Open"),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding:
                            EdgeInsets.only(top: displayHeight(context) * 0.08),
                        itemCount: controller.searchedAuthors.length,
                        itemBuilder: (context, index) {
                          List<String> initials =
                              controller.searchedAuthors[index].name.split(" ");
                          String firstLetter = "", lastLetter = "";

                          if (initials.length == 1) {
                            firstLetter = initials[0].characters.first;
                          } else {
                            firstLetter = initials[0].characters.first;
                            lastLetter = initials[1].characters.first;
                          }
                          return ListTile(
                            onTap: () {
                              if (controller.searchedAuthors[index].userId !=
                                  myUserId) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserProfileScreen(
                                          userId: controller
                                              .searchedAuthors[index].userId),
                                    ));
                              }
                            },
                            leading: (controller
                                    .searchedAuthors[index].dp.isEmpty)
                                ? CircleAvatar(
                                    backgroundColor: authMaterialButtonColor,
                                    child: Center(
                                      child: initials.length > 1
                                          ? Text(
                                              "$firstLetter.$lastLetter"
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            )
                                          : Text(
                                              firstLetter.toUpperCase(),
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        controller.searchedAuthors[index].dp),
                                  ),
                            title: Text(controller.searchedAuthors[index].name),
                            dense: true,
                            // trailing: MaterialButton(
                            //   onPressed: () {
                            //     var searchedUser =
                            //         controller.searchedAuthors[index];
                            //     final userProvider =
                            //         Provider.of<UserController>(context,
                            //             listen: false);
                            //     if (userProvider.user!.following
                            //         .contains(searchedUser.userId)) {
                            //       // user is already following the searched user
                            //       // try to unfollow
                            //       userProvider.unFollowUser(
                            //           userId: searchedUser.userId);
                            //     } else {
                            //       userProvider.followUser(
                            //           userId: searchedUser.userId);
                            //     }
                            //     controller.search(queryController.text);
                            //   },
                            //   height: 30,
                            //   color: authBackground,
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(4),
                            //   ),
                            //   child: Text(
                            //     (controller.searchedAuthors[index].followers
                            //             .contains(currentUserId))
                            //         ? 'Following'
                            //         : 'Follow',
                            //     style: const TextStyle(
                            //       fontSize: 13,
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.normal,
                            //     ),
                            //   ),
                            // ),
                          );
                        },
                      )
              ],
            );
          },
        )),
      ),
    );
  }
}
