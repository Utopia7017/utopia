import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/article_box.dart';

class SavedArticlesScreen extends StatelessWidget {
  const SavedArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: authBackground,
        title: const Text(
          'Saved Articles',
          style: TextStyle(fontSize: 15.5),
        ),
      ),
      body: Consumer<UserController>(
        builder: (context, userController, child) {
          if (userController.profileStatus == ProfileStatus.nil) {
            userController.setUser(FirebaseAuth.instance.currentUser!.uid);
          }
          switch (userController.profileStatus) {
            case ProfileStatus.nil:
              return const Center(
                child: Text('Swipe to fetch profile'),
              );
            case ProfileStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ProfileStatus.fetched:
              return Consumer<MyArticlesController>(
                builder: (context, myArticleController, child) {
                  if (myArticleController.fetchingSavedArticlesStatus ==
                      FetchingSavedArticles.nil) {
                    myArticleController
                        .fetchSavedArticles(userController.user!);
                  }

                  switch (myArticleController.fetchingSavedArticlesStatus) {
                    case FetchingSavedArticles.nil:
                      return const Center(
                        child: Text('Swipe to fetch saved articles'),
                      );
                    case FetchingSavedArticles.fetching:
                      return const Center(child: CircularProgressIndicator());
                    case FetchingSavedArticles.fetched:
                      if (myArticleController.savedArticles.isEmpty) {
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
                      return ListView.builder(
                        // padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          return ArticleBox(
                              article: myArticleController
                                  .savedArticlesDetails[index]);
                        },
                        itemCount:
                            myArticleController.savedArticlesDetails.length,
                      );
                  }
                },
              );
          }
        },
      ),
    );
  }
}
