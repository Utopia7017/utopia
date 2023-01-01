import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/state_controller/state_controller.dart';
import 'package:utopia/view/common_ui/author_card.dart';
import 'package:utopia/view/shimmers/author_card_shimmer.dart';

class PopularAuthors extends ConsumerWidget {
  const PopularAuthors({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(stateController.notifier);
    final dataController = ref.watch(stateController);
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
        child: Builder(
          builder: (context) {
            if (dataController.userState.fetchingPopularAuthors ==
                FetchingPopularAuthors.NOT_FETCHED) {
              controller.getPopularAuthors();
            }
            switch (dataController.userState.fetchingPopularAuthors) {
              case FetchingPopularAuthors.NOT_FETCHED:
                return ListView(
                  children: [
                    RefreshIndicator(
                        onRefresh: () async {
                          controller.getPopularAuthors();
                        },
                        backgroundColor: authBackground,
                        color: Colors.white,
                        strokeWidth: 3,
                        triggerMode: RefreshIndicatorTriggerMode.anywhere,
                        child: const Center(child: Text("Swipe to refresh"))),
                  ],
                );
              case FetchingPopularAuthors.FETCHING:
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

              case FetchingPopularAuthors.FETCHED:
                return RefreshIndicator(
                  onRefresh: () async {
                    controller.getPopularAuthors();
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
                                    user: dataController
                                        .userState.popularAuthors![index]),
                              ),
                            ),
                          ));
                    },
                    itemCount: dataController.userState.popularAuthors!.length,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
