import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/view/screens/ExploreScreen/components/article_category_tabs.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 18.0, right: 18, top: 6),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SearchBox(),
            SizedBox(
              height: 14,
            ),
            ArticleCategoryTab()
          ],
        ),
      ),
    );
  }
}
