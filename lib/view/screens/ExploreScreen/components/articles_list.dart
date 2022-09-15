import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/article_category_constants.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controlller/articles_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/view/common_ui/article_box.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticlesController>(
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
            return ListView.builder(
              itemCount: controller
                  .articles[articleCategories[controller.selectedCategory]]!
                  .length,
              itemBuilder: (context, index) {
                return ArticleBox(article: controller
                  .articles[articleCategories[controller.selectedCategory]]![index]);
              },
            );
          case ArticlesStatus.fetching:
            return const Center(
              child: CircularProgressIndicator(
                color: authMaterialButtonColor,
              ),
            );
        }
      },
    );
  }
}
