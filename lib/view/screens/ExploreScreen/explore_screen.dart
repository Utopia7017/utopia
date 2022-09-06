import 'package:flutter/material.dart';
import 'package:utopia/view/screens/ExploreScreen/components/article_category_tabs.dart';
import 'package:utopia/view/screens/ExploreScreen/components/search_box.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}
