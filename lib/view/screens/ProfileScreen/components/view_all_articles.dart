import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/view/common_ui/article_box.dart';

class ViewAllArticles extends StatelessWidget {
  List<Article> articles;

  ViewAllArticles({required this.articles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All articles',
          style: TextStyle(fontFamily: "open"),
        ),
        backgroundColor: authBackground,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return ArticleBox(
                article: articles[index]);
          }),
    );
  }
}
