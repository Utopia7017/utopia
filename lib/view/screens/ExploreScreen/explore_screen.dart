import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:utopia/constants/article_category_constants.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/articles_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/article_box.dart';
import 'package:utopia/view/common_ui/author_card.dart';
import 'package:utopia/view/screens/ExploreScreen/components/search_box.dart';
import 'package:utopia/view/shimmers/article_shimmer.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({Key? key}) : super(key: key);
  final PageController articlePageController = PageController();
  final ItemScrollController articleCategoryController = ItemScrollController();
  // RefreshController refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SearchBox(),
          // const SizedBox(height: 10),

          // ArticleCategoryTab(),
          SizedBox(
              // color: Colors.red.shade100,
              height: displayHeight(context) * 0.06,
              width: displayWidth(context),
              child: Consumer<ArticlesController>(
                builder: (context, controller, child) {
                  return ScrollablePositionedList.builder(
                    itemScrollController: articleCategoryController,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextButton(
                          child: Text(
                            controller.articles.keys.toList()[index],
                            style: TextStyle(
                                fontSize: 14,
                                color: controller.selectedCategory == index
                                    ? Colors.black87
                                    : Colors.black54,
                                fontWeight: controller.selectedCategory == index
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
                    itemCount: controller.articles.length,
                  );
                },
              )),

          const SizedBox(height: 4),

          // List Body to display articles.
          Expanded(
            child: Consumer<ArticlesController>(
              builder: (context, articleController, child) {
                return PageView.builder(
                  controller: articlePageController,
                  onPageChanged: (index) {
                    articleCategoryController.scrollTo(
                        duration: const Duration(microseconds: 5),
                        index: index,
                        alignment: 0.5);
                    articleController.selectCategory(index);
                  },
                  itemCount: articleCategoriesForDisplaying.length,
                  itemBuilder: (context, index) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await articleController.fetchArticles();
                      },
                      backgroundColor: authBackground,
                      color: Colors.white,
                      strokeWidth: 3,
                      triggerMode: RefreshIndicatorTriggerMode.anywhere,
                      child: Consumer<ArticlesController>(
                        builder: (context, controller, child) {
                          if (controller.articlesStatus == ArticlesStatus.nil) {
                            controller.fetchArticles();
                          }
                          switch (controller.articlesStatus) {
                            case ArticlesStatus.nil:
                              return const Center(
                                child: Text("Swipe to refresh"),
                              );

                            case ArticlesStatus.fetched:
                              if (controller
                                  .articles[articleCategoriesForDisplaying[
                                      controller.selectedCategory]]!
                                  .isNotEmpty) {
                                return ListView.builder(
                                  itemCount: controller
                                      .articles[articleCategoriesForDisplaying[
                                          controller.selectedCategory]]!
                                      .length,
                                  itemBuilder: (context, index) {
                                    // return ArticleSkeleton();
                                    return ArticleBox(
                                        article: controller.articles[
                                                articleCategoriesForDisplaying[
                                                    controller
                                                        .selectedCategory]]![
                                            index]);
                                  },
                                );
                              } else {
                                if (articleController.selectedCategory == 0) {
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
                                                onPressed: () {},
                                                child: const Text(
                                                  "Show more",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: displayHeight(context) * 0.45,
                                        width: displayWidth(context),
                                        child: Consumer<UserController>(
                                          builder:
                                              (context, userController, child) {
                                            if (userController
                                                    .fetchingPopularAuthors ==
                                                FetchingPopularAuthors.nil) {
                                              userController
                                                  .getPopularAuthors();
                                            }
                                            switch (userController
                                                .fetchingPopularAuthors) {
                                              case FetchingPopularAuthors.nil:
                                                return const Text("Some error");

                                              case FetchingPopularAuthors
                                                  .fetching:
                                                return Text("Loading");
                                              case FetchingPopularAuthors
                                                  .fetched:
                                                return ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: AuthorCard(
                                                          user: userController
                                                                  .popularAuthors[
                                                              index]),
                                                    );
                                                  },
                                                  itemCount: userController
                                                      .popularAuthors.length,
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

                            case ArticlesStatus.fetching:
                              return ListView.builder(
                                itemCount: 8,
                                itemBuilder: (context, index) {
                                  return const ShimmerForArticles();
                                },
                              );
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
