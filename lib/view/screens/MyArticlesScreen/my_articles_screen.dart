import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/article_box.dart';
import 'package:utopia/view/common_ui/draft_article_box.dart';
import 'package:utopia/view/shimmers/article_shimmer.dart';
import '../../../constants/image_constants.dart';

class MyArticleScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyArticleScreen> createState() => _MyArticleScreenState();
}

class _MyArticleScreenState extends ConsumerState<MyArticleScreen>
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
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
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
                return await Future.delayed(const Duration(seconds: 2));
              },
              backgroundColor: authBackground,
              color: Colors.white,
              child: TabBarView(controller: _tabController, children: [
                Builder(
                  builder: (context) {
                    if (dataController.myArticleState.fetchingMyArticleStatus ==
                        FetchingMyArticle.NOT_FETCHED) {
                      controller.fetchMyArticles(myUserId);
                    }

                    switch (
                        dataController.myArticleState.fetchingMyArticleStatus) {
                      case FetchingMyArticle.NOT_FETCHED:
                        return const Center(child: Text('Swipe to refresh'));
                      case FetchingMyArticle.FETCHING:
                        return const ShimmerForArticles();

                      case FetchingMyArticle.FETCHED:
                        if (dataController
                            .myArticleState.publishedArticles.isEmpty) {
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
                                      fontWeight: FontWeight.w400,
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
                                          myUid: dataController
                                              .myArticleState
                                              .publishedArticles[index]
                                              .authorId,
                                          articleId: dataController
                                              .myArticleState
                                              .publishedArticles[index]
                                              .articleId);
                                      Navigator.pop(context);
                                    },
                                    onCancelBtnTap: () {
                                      controller.clearForm();
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                child: ArticleBox(
                                    article: dataController.myArticleState
                                        .publishedArticles[index]),
                              );
                            },
                            itemCount: dataController
                                .myArticleState.publishedArticles.length,
                          ),
                        );
                    }
                  },
                ),
                Builder(
                  builder: (context) {
                    if (dataController
                            .myArticleState.fetchingDraftArticlesStatus ==
                        FetchingDraftArticles.NOT_FETCHED) {
                      controller.fetchDraftArticles(myUserId);
                    }

                    switch (dataController
                        .myArticleState.fetchingDraftArticlesStatus) {
                      case FetchingDraftArticles.NOT_FETCHED:
                        return const Center(child: Text('Swipe to refresh'));
                      case FetchingDraftArticles.FETCHING:
                        return const Center(
                          child: CircularProgressIndicator(
                            color: authMaterialButtonColor,
                          ),
                        );
                      case FetchingDraftArticles.FETCHED:
                        if (dataController
                            .myArticleState.draftArticles.isEmpty) {
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
                                  "No drafts found",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
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
                                    title: "Delete this draft? ",
                                    cancelBtnTextStyle:
                                        const TextStyle(color: Colors.black54),
                                    showCancelBtn: true,
                                    onConfirmBtnTap: () {
                                      controller.deleteDraftArticle(
                                          myUid: dataController.myArticleState
                                              .draftArticles[index].authorId,
                                          articleId: dataController
                                              .myArticleState
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
                                    article: dataController
                                        .myArticleState.draftArticles[index]),
                              );
                            },
                            itemCount: dataController
                                .myArticleState.draftArticles.length,
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
