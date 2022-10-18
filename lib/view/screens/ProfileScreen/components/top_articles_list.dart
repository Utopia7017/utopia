import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/top_articles_box.dart';

class TopArticlesList extends StatelessWidget {
  final User user;
  const TopArticlesList({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyArticlesController>(
      builder: (context, myArticlesController, child) {
        if (myArticlesController.fetchingMyArticleStatus ==
            FetchingMyArticle.nil) {
          myArticlesController.fetchMyArticles(user.userId);
        }
        switch (myArticlesController.fetchingMyArticleStatus) {
          case FetchingMyArticle.nil:
            return const Center(
              child: Text("Nil"),
            );
          case FetchingMyArticle.fetching:
            // TODO: Show shimmer effect
            return const Center(child: CircularProgressIndicator());

          case FetchingMyArticle.fetched:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Recent articles",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87.withOpacity(0.8),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: displayHeight(context) * 0.35,
                  width: displayWidth(context),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemCount:
                        myArticlesController.publishedArticles.length < 10
                            ? myArticlesController.publishedArticles.length
                            : 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TopArticleBox(
                          article:
                              myArticlesController.publishedArticles[index],
                          user: user,
                        ),
                      );
                    },
                  ),
                )
              ],
            );
        }
      },
    );
  }
}
