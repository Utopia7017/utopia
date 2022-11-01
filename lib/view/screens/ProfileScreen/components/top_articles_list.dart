import 'package:firebase_auth/firebase_auth.dart' as firebaseUser;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/articles_controller.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/top_articles_box.dart';
import 'package:utopia/view/screens/Skeletons/rec_article_skeleton.dart';
import 'package:utopia/view/shimmers/rec_article_shimmer.dart';

class TopArticlesList extends StatelessWidget {
  final User user;
  TopArticlesList({super.key, required this.user});
  final String myUid = firebaseUser.FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return (user.userId == myUid)
        // if this method is being called by the current logged in user then display articles using my article controller
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
                      const SizedBox(height: 12),
                      SizedBox(
                        height: displayHeight(context) * 0.35,
                        width: displayWidth(context),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: RecentArticleShimmer());
                          },
                        ),
                      )
                    ],
                  );

                case FetchingMyArticle.fetched:
                  if (myArticlesController.publishedArticles.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                        const SizedBox(height: 30),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                noArticleFoundIcon,
                                height: displayHeight(context) * 0.15,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "You have not published any article.",
                                style: TextStyle(
                                    color: Colors.black54, fontFamily: "Open"),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Recent articles",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87.withOpacity(0.8),
                                    fontWeight: FontWeight.bold),
                              ),
                              (myArticlesController.publishedArticles.length >=
                                      10)
                                  ? InkWell(
                                      onTap: () {},
                                      child: Row(
                                        children: const [
                                          Text(
                                            "View all",
                                            style: TextStyle(
                                                letterSpacing: 0.15,
                                                color: Colors.teal,
                                                // fontFamily: "Open",
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Icon(
                                            Icons.arrow_right_alt_rounded,
                                            color: Colors.teal,
                                          )
                                        ],
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: displayHeight(context) * 0.35,
                          width: displayWidth(context),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemCount: myArticlesController
                                        .publishedArticles.length <
                                    10
                                ? myArticlesController.publishedArticles.length
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
              }
            },
          ) //
        : FutureBuilder(
            future: Provider.of<ArticlesController>(context)
                .fetchThisUsersArticles(user.userId),
            builder: (context, AsyncSnapshot<List<Article>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      const SizedBox(height: 30),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              noArticleFoundIcon,
                              height: displayHeight(context) * 0.15,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${user.name} has not published any article.",
                              style: const TextStyle(
                                  color: Colors.black54, fontFamily: "Open"),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
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
                    const SizedBox(height: 12),
                    SizedBox(
                      height: displayHeight(context) * 0.35,
                      width: displayWidth(context),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: RecentArticleShimmer());
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
