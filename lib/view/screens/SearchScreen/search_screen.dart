import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/article_box.dart';
import 'package:utopia/view/screens/UserProfileScreen/user_profile_screen.dart';
import 'package:utopia/view/shimmers/follower_shimmer.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final String myUserId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController queryController = TextEditingController();
  Timer? _debounce;

  @override
  WidgetRef get ref => super.ref;

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
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    toolbarHeight: displayHeight(context) * 0.1,
                    backgroundColor: authBackground,
                    title: SizedBox(
                      height: displayHeight(context) * 0.055,
                      child: TextFormField(
                        onChanged: (query) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce =
                              Timer(const Duration(milliseconds: 500), () {
                            print(query);
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
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                // Display searched articles
                dataController.articleState.searchedArticles.isEmpty
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
                        itemCount:
                            dataController.articleState.searchedArticles.length,
                        itemBuilder: (context, index) {
                          return ArticleBox(
                              article: dataController
                                  .articleState.searchedArticles[index]);
                        },
                      ),

                // Display searched authors
                (dataController.articleState.searchedAuthors.isEmpty)
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
                        itemCount:
                            dataController.articleState.searchedAuthors.length,
                        itemBuilder: (context, index) {
                          List<String> initials = dataController
                              .articleState.searchedAuthors[index].name
                              .split(" ");
                          String firstLetter = "", lastLetter = "";

                          if (initials.length == 1) {
                            firstLetter = initials[0].characters.first;
                          } else {
                            firstLetter = initials[0].characters.first;
                            lastLetter = initials[1].characters.first;
                          }
                          return Builder(
                            builder: (context) {
                              if (dataController.userState.profileStatus ==
                                  ProfileStatus.NOT_FETCHED) {
                                controller.setUser(myUserId);
                              }
                              switch (dataController.userState.profileStatus) {
                                case ProfileStatus.NOT_FETCHED:
                                  return const Center(
                                    child: Text("Something is wrong!!"),
                                  );
                                case ProfileStatus.FETCHING:
                                  return const FollowerShimmer();
                                case ProfileStatus.FETCHED:
                                  return ListTile(
                                    onTap: () {
                                      if (!dataController.articleState
                                              .searchedAuthors[index].blocked
                                              .contains(myUserId) &&
                                          dataController
                                                  .articleState
                                                  .searchedAuthors[index]
                                                  .userId !=
                                              myUserId &&
                                          !dataController
                                              .userState.user!.blocked
                                              .contains(dataController
                                                  .articleState
                                                  .searchedAuthors[index]
                                                  .userId)) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserProfileScreen(
                                                      userId: dataController
                                                          .articleState
                                                          .searchedAuthors[
                                                              index]
                                                          .userId),
                                            ));
                                      }
                                    },
                                    leading: (dataController.articleState
                                            .searchedAuthors[index].dp.isEmpty)
                                        ? CircleAvatar(
                                            backgroundColor:
                                                authMaterialButtonColor,
                                            child: Center(
                                              child: initials.length > 1
                                                  ? Text(
                                                      "$firstLetter.$lastLetter"
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white),
                                                    )
                                                  : Text(
                                                      firstLetter.toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white),
                                                    ),
                                            ),
                                          )
                                        : CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    dataController
                                                        .articleState
                                                        .searchedAuthors[index]
                                                        .dp),
                                          ),
                                    title: Row(
                                      children: [
                                        Text(dataController.articleState
                                            .searchedAuthors[index].name),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Visibility(
                                          visible: dataController
                                              .articleState
                                              .searchedAuthors[index]
                                              .isVerified,
                                          child: Image.asset(
                                            verifyIcon,
                                            height: 17.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    dense: true,
                                  );
                              }
                            },
                          );
                        },
                      )
              ],
            )),
      ),
    );
  }
}
