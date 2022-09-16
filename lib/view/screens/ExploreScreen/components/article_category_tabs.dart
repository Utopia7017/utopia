import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/controlller/articles_controller.dart';
import 'package:utopia/utils/device_size.dart';

class ArticleCategoryTab extends StatelessWidget {
  const ArticleCategoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: displayHeight(context) * 0.06,
        width: displayWidth(context),
        child: Consumer<ArticlesController>(
          builder: (context, controller, child) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    child: Text(
                      controller.articles.keys.toList()[index],
                      style: TextStyle(
                          fontSize: 14,
                          color: controller.selectedCategory == index
                              ? Colors.black87
                              : Colors.black54,
                          fontWeight: controller.selectedCategory == index
                              ? FontWeight.w400
                              : FontWeight.normal,
                          fontFamily: "Fira"),
                    ),
                    onPressed: () {
                      controller.selectCategory(index);
                    },
                  ),
                );
              },
              itemCount: controller.articles.length,
            );
          },
        ));
  }
}
