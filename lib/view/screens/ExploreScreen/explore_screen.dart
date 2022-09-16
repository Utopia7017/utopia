import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/view/screens/ExploreScreen/components/article_category_tabs.dart';
import 'package:utopia/view/screens/ExploreScreen/components/articles_list.dart';
import 'package:utopia/view/screens/ExploreScreen/components/search_box.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({Key? key}) : super(key: key);
  final Logger _logger = Logger("ExploreScreen");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/newArticle');
        },
        backgroundColor: authBackground,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBox(),
          SizedBox(height: 14),
          ArticleCategoryTab(),
          SizedBox(height: 10),
          Expanded(child: ArticleList())
        ],
      ),
    );
  }
}
