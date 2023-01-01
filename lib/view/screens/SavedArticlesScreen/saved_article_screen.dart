import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/article_box.dart';

class SavedArticlesScreen extends ConsumerWidget {
  const SavedArticlesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: authBackground,
        title: const Text(
          'Saved Articles',
          style: TextStyle(fontSize: 15.5),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (dataController.userState.profileStatus ==
              ProfileStatus.NOT_FETCHED) {
            controller.setUser(FirebaseAuth.instance.currentUser!.uid);
          }
          switch (dataController.userState.profileStatus) {
            case ProfileStatus.NOT_FETCHED:
              return const Center(
                child: Text('Swipe to fetch profile'),
              );
            case ProfileStatus.FETCHING:
              return const Center(child: CircularProgressIndicator());
            case ProfileStatus.FETCHED:
              return Builder(
                builder: (context) {
                  if (dataController
                          .myArticleState.fetchingSavedArticlesStatus ==
                      FetchingSavedArticles.NOT_FETCHED) {
                    controller
                        .fetchSavedArticles(dataController.userState.user!);
                  }

                  switch (dataController
                      .myArticleState.fetchingSavedArticlesStatus) {
                    case FetchingSavedArticles.NOT_FETCHED:
                      return const Center(
                        child: Text('Swipe to fetch saved articles'),
                      );
                    case FetchingSavedArticles.FETCHING:
                      return const Center(child: CircularProgressIndicator());
                    case FetchingSavedArticles.FETCHED:
                      if (dataController
                          .myArticleState.savedArticlesDetails.isEmpty) {
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
                      } else {
                        return ListView.builder(
                          // padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            return ArticleBox(
                                article: dataController.myArticleState
                                    .savedArticlesDetails[index]);
                          },
                          itemCount: dataController
                              .myArticleState.savedArticlesDetails.length,
                        );
                      }
                  }
                },
              );
          }
        },
      ),
    );
  }
}
