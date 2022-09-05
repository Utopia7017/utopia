import 'package:flutter/material.dart';
import 'package:utopia/view/screens/ExploreScreen/components/search_box.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 18.0, right: 18, top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [SearchBox()],
      ),
    );
  }
}
