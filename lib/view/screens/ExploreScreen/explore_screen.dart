import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:utopia/constants/article_category_constants.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/article_box.dart';
import 'package:utopia/view/common_ui/author_card.dart';
import 'package:utopia/view/screens/ExploreScreen/components/search_box.dart';
import 'package:utopia/view/shimmers/article_shimmer.dart';
import 'package:utopia/view/shimmers/author_card_shimmer.dart';
import 'dart:math';

class ExploreScreen extends ConsumerWidget {
  ExploreScreen({Key? key}) : super(key: key);
  final PageController articlePageController = PageController();
  final ItemScrollController articleCategoryController = ItemScrollController();
  Logger logger = Logger("Explore Screen");
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
    logger.info("reached exlore");
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/newArticle');
          },
          backgroundColor: authBackground,
          child: Image.asset(
            newArticleIcon,
            color: Colors.white,
            height: 30,
          )),
      // body: Text("Demo"),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SearchBox(),
          SizedBox(
              height: displayHeight(context) * 0.06,
              width: displayWidth(context),
              child: ScrollablePositionedList.builder(
                itemScrollController: articleCategoryController,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      child: Text(
                        dataController.articleState.articles.keys
                            .toList()[index],
                        style: TextStyle(
                            fontSize: 14,
                            color:
                                dataController.articleState.selectedCategory ==
                                        index
                                    ? Colors.black87
                                    : Colors.black54,
                            fontWeight:
                                dataController.articleState.selectedCategory ==
                                        index
                                    ? FontWeight.w400
                                    : FontWeight.normal,
                            fontFamily: "Fira"),
                      ),
                      onPressed: () {
                        controller.selectCategory(index);
                        articleCategoryController.scrollTo(
                            duration: const Duration(microseconds: 2),
                            index: index,
                            alignment: 0.4);
                        articlePageController.animateToPage(index,
                            duration: const Duration(microseconds: 2),
                            curve: Curves.bounceInOut);
                      },
                    ),
                  );
                },
                itemCount: dataController.articleState.articles.length,
              )),

          const SizedBox(height: 4),

          // List Body to display articles.
          Expanded(
            child: PageView.builder(
              controller: articlePageController,
              onPageChanged: (index) {
                articleCategoryController.scrollTo(
                    duration: const Duration(microseconds: 5),
                    index: index,
                    alignment: 0.5);
                controller.selectCategory(index);
              },
              itemCount: articleCategoriesForDisplaying.length,
              itemBuilder: (context, index) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchArticles();
                    // await controller.getPopularAuthors();
                  },
                  backgroundColor: authBackground,
                  color: Colors.white,
                  strokeWidth: 3,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  child: Builder(
                    builder: (context) {
                      // if (dataController.articleState.articlesStatus ==
                      //     ArticlesStatus.NOT_FETCHED) {
                      //   logger.shout("Lets fetch articles");
                      //   controller.fetchArticles();
                      // }
                      switch (dataController.articleState.articlesStatus) {
                        case ArticlesStatus.NOT_FETCHED:
                          return const Center(
                            child: Text("Swipe to refresh"),
                          );
                        case ArticlesStatus.FETCHING:
                          return ListView.builder(
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              return const ShimmerForArticles();
                            },
                          );
                        case ArticlesStatus.FETCHED:
                          if (dataController
                              .articleState
                              .articles[articleCategoriesForDisplaying[
                                  dataController
                                      .articleState.selectedCategory]]!
                              .isNotEmpty) {
                            return ListView.builder(
                              itemCount: dataController
                                  .articleState
                                  .articles[articleCategoriesForDisplaying[
                                      dataController
                                          .articleState.selectedCategory]]!
                                  .length,
                              itemBuilder: (context, index) {
                                // return ArticleSkeleton();
                                return ArticleBox(
                                    article: dataController
                                            .articleState.articles[
                                        articleCategoriesForDisplaying[
                                            dataController.articleState
                                                .selectedCategory]]![index]);
                              },
                            );
                          } else {
                            if (dataController.articleState.selectedCategory ==
                                0) {
                              return ListView(
                                children: [
                                  SizedBox(
                                    height: displayHeight(context) * 0.1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Popular Authors",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.5,
                                              fontFamily: "Open"),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/popAuthors');
                                            },
                                            child: const Text(
                                              "Show more",
                                              style: TextStyle(fontSize: 12),
                                            ))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: displayHeight(context) * 0.5,
                                      minHeight: displayHeight(context) * 0.3,
                                      maxWidth: double.infinity,
                                      minWidth: double.infinity,
                                    ),
                                    // height: displayHeight(context) * 0.5,

                                    child: Builder(
                                      builder: (context) {
                                        if (dataController.userState
                                                .fetchingPopularAuthors ==
                                            FetchingPopularAuthors
                                                .NOT_FETCHED) {
                                          controller.getPopularAuthors();
                                        }
                                        switch (dataController
                                            .userState.fetchingPopularAuthors) {
                                          case FetchingPopularAuthors
                                              .NOT_FETCHED:
                                            return const Text("Some error");

                                          case FetchingPopularAuthors.FETCHING:
                                            return ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child:
                                                        ShimmerForAuthorCard());
                                              },
                                              itemCount: 10,
                                            );
                                          case FetchingPopularAuthors.FETCHED:
                                            return ListView.builder(
                                              // shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: AuthorCard(
                                                      mainScreen: false,
                                                      user: dataController
                                                              .userState
                                                              .popularAuthors![
                                                          index]),
                                                );
                                              },
                                              itemCount: min(
                                                  dataController.userState
                                                      .popularAuthors!.length,
                                                  10),
                                            );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return ListView(
                                children: [
                                  SizedBox(
                                    height: displayHeight(context) * 0.2,
                                  ),
                                  Image.asset(
                                    noArticleFoundIcon,
                                    height: displayHeight(context) * 0.1,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    "No articles found",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: "Open"),
                                  )
                                ],
                              );
                            }
                          }
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
