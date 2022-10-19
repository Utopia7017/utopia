import 'package:firebase_auth/firebase_auth.dart' as firebaseUser;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controller/articles_controller.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/top_articles_box.dart';

class TopArticlesList extends StatelessWidget {
  final User user;
  TopArticlesList({super.key, required this.user});
  final String myUid = firebaseUser.FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return (user.userId == myUid)
        ? Consumer<MyArticlesController>(
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
                                  ? myArticlesController
                                      .publishedArticles.length
                                  : 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TopArticleBox(
                                article: myArticlesController
                                    .publishedArticles[index],
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
          )
        : FutureBuilder(
            future: Provider.of<ArticlesController>(context)
                .fetchThisUsersArticles(user.userId),
            builder: (context, AsyncSnapshot<List<Article>> snapshot) {
              if (snapshot.hasData) {
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
                        itemCount: snapshot.data!.length < 10
                            ? snapshot.data!.length
                            : 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TopArticleBox(
                              article: snapshot.data![index],
                              user: user,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              } else {
                // TODO: Show shimmer effect
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
  }
}
