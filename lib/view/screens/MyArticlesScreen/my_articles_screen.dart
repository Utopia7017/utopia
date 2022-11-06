import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/article_box.dart';
import 'package:utopia/view/common_ui/draft_article_box.dart';
import 'package:utopia/view/shimmers/article_shimmer.dart';

import '../../../constants/image_constants.dart';

class MyArticleScreen extends StatefulWidget {
  @override
  State<MyArticleScreen> createState() => _MyArticleScreenState();
}

class _MyArticleScreenState extends State<MyArticleScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final String myUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: authBackground.withOpacity(0.9),
        ),
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    backgroundColor: authBackground,
                    title: const Text(
                      'My Articles',
                      style: TextStyle(fontSize: 15.5),
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
                          Tab(text: 'Published'),
                          Tab(text: 'Drafts'),
                        ]),
                  ),
                ),
              ];
            },
            body: RefreshIndicator(
              onRefresh: () async {
                return await Future.delayed(Duration(seconds: 2));
              },
              backgroundColor: authBackground,
              color: Colors.white,
              child: TabBarView(controller: _tabController, children: [
                Consumer<MyArticlesController>(
                  builder: (context, controller, child) {
                    if (controller.fetchingMyArticleStatus ==
                        FetchingMyArticle.nil) {
                      controller.fetchMyArticles(myUserId);
                    }

                    switch (controller.fetchingMyArticleStatus) {
                      case FetchingMyArticle.nil:
                        return const Center(child: Text('Swipe to refresh'));
                      case FetchingMyArticle.fetching:
                        return const ShimmerForArticles();

                      case FetchingMyArticle.fetched:
                        if (controller.publishedArticles.isEmpty) {
                          return Center(
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
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.only(
                              top: displayHeight(context) * 0.07),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return InkWell(
                                onLongPress: () {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    title: "Delete this article? ",
                                    cancelBtnTextStyle:
                                    const TextStyle(color: Colors.black54),
                                    showCancelBtn: true,
                                    onConfirmBtnTap: () {
                                    controller.deleteThisArticle(
                                      myUid: controller
                                      .publishedArticles[index].authorId,
                                      articleId: controller
                                      .publishedArticles[index].articleId);
                                      Navigator.pop(context);
                                  },
                                  onCancelBtnTap: () {
                                controller.clearForm();
                                Navigator.pop(context);
                              },
                                  );
                                },
                                child: ArticleBox(
                                    article:
                                        controller.publishedArticles[index]),
                              );
                            },
                            itemCount: controller.publishedArticles.length,
                          ),
                        );
                    }
                  },
                ),
                Consumer<MyArticlesController>(
                  builder: (context, controller, child) {
                    if (controller.fetchingDraftArticlesStatus ==
                        FetchingDraftArticles.nil) {
                      controller.fetchDraftArticles(myUserId);
                    }

                    switch (controller.fetchingDraftArticlesStatus) {
                      case FetchingDraftArticles.nil:
                        return const Center(child: Text('Swipe to refresh'));
                      case FetchingDraftArticles.fetching:
                        return const Center(
                          child: CircularProgressIndicator(
                            color: authMaterialButtonColor,
                          ),
                        );
                      case FetchingDraftArticles.fetched:
                        if (controller.draftArticles.isEmpty) {
                          return Center(
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
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                              top: displayHeight(context) * 0.07),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return InkWell(
                                onLongPress: () {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    title: "Delete this article? ",
                                    cancelBtnTextStyle:
                                    const TextStyle(color: Colors.black54),
                                    showCancelBtn: true,
                                    onConfirmBtnTap: () {
                                    controller.deleteDraftArticle(
                                                    myUid: controller
                                                        .draftArticles[index]
                                                        .authorId,
                                                    articleId: controller
                                                        .draftArticles[index]
                                                        .articleId);
                                                Navigator.pop(context);
                                  },
                                  onCancelBtnTap: () {
                                controller.clearForm();
                                Navigator.pop(context);
                                   },
                                  );
                                },
                                child: DraftArticleBox(
                                    article: controller.draftArticles[index]),
                              );
                            },
                            itemCount: controller.draftArticles.length,
                          ),
                        );
                    }
                  },
                ),
              ]),
            ),
          ),
        ));
  }
}
