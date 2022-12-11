import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/view/common_ui/author_card.dart';
import 'package:utopia/view/shimmers/author_card_shimmer.dart';

class PopularAuthors extends StatelessWidget {
  const PopularAuthors({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: authBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Popular Authors",
          style: TextStyle(fontFamily: "Open", fontSize: 14),
        ),
      ),
      body: SafeArea(
        child: Consumer<UserController>(
          builder: (context, userController, child) {
            if (userController.fetchingPopularAuthors ==
                FetchingPopularAuthors.nil) {
              userController.getPopularAuthors();
            }
            switch (userController.fetchingPopularAuthors) {
              case FetchingPopularAuthors.nil:
                return ListView(
                  children: [
                    RefreshIndicator(
                        onRefresh: () async {
                          userController.getPopularAuthors();
                        },
                        backgroundColor: authBackground,
                        color: Colors.white,
                        strokeWidth: 3,
                        triggerMode: RefreshIndicatorTriggerMode.anywhere,
                        child: const Center(child: Text("Swipe to refresh"))),
                  ],
                );
              case FetchingPopularAuthors.fetching:
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.62, crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                        position: index,
                        columnCount: 2,
                        child: const SlideAnimation(
                          verticalOffset: 50.0,
                          curve: Curves.bounceIn,
                          child: ScaleAnimation(
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ShimmerForAuthorCard()),
                          ),
                        ));
                  },
                  itemCount: 10,
                );

              case FetchingPopularAuthors.fetched:
                return RefreshIndicator(
                  onRefresh: () async {
                    userController.getPopularAuthors();
                  },
                  backgroundColor: authBackground,
                  color: Colors.white,
                  strokeWidth: 3,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.62, crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredGrid(
                          position: index,
                          columnCount: 2,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            curve: Curves.bounceIn,
                            child: ScaleAnimation(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AuthorCard(
                                    mainScreen: true,
                                    user: userController.popularAuthors[index]),
                              ),
                            ),
                          ));
                    },
                    itemCount: userController.popularAuthors.length,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
