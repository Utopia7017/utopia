import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/articles_controller.dart';
import 'package:utopia/controller/my_articles_controller.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart' as usermodel;
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/DisplayArticleScreen/components/report_modal_sheet.dart';
import 'package:utopia/view/screens/UserProfileScreen/user_profile_screen.dart';
import 'components/floating_button_for_article_options.dart';

class DisplayArticleScreen extends StatefulWidget {
  final Article article;
  final usermodel.User author;
  DisplayArticleScreen({required this.article, required this.author});

  @override
  State<DisplayArticleScreen> createState() => _DisplayArticleScreenState();
}

class _DisplayArticleScreenState extends State<DisplayArticleScreen> {
  ScrollController? _hideBottomNavController;
  String firstLetter = "", lastLetter = "";
  bool? _isVisible;
  final String myUserId = FirebaseAuth.instance.currentUser!.uid;
  List<String> initials = [];

  @override
  initState() {
    super.initState();
    initials = widget.author.name.split(" ");
    if (initials.length == 1) {
      firstLetter = initials[0].characters.first;
    } else {
      firstLetter = initials[0].characters.first;
      lastLetter =
          initials[1].characters.isEmpty ? "" : initials[1].characters.first;
    }

    _isVisible = true;
    _hideBottomNavController = ScrollController();
    _hideBottomNavController!.addListener(
      () {
        if (_hideBottomNavController!.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisible!) {
            setState(() {
              _isVisible = false;
            });
          }
        }
        if (_hideBottomNavController!.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isVisible!) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      floatingActionButton: FloatingButtonForArticleOptions(
        isVisible: _isVisible!,
        article: widget.article,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: SafeArea(
          child: CustomScrollView(
        controller: _hideBottomNavController,
        slivers: <Widget>[
          SliverAppBar(
            title: InkWell(
              onTap: () {
                if (widget.author.userId != myUserId) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(
                          userId: widget.author.userId,
                        ),
                      ));
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  (widget.author.dp.isEmpty)
                      ? CircleAvatar(
                          backgroundColor: authMaterialButtonColor,
                          child: Center(
                            child: initials.length > 1
                                ? Text(
                                    "$firstLetter.$lastLetter".toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  )
                                : Text(
                                    firstLetter.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(widget.author.dp),
                        ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: displayWidth(context) * 0.2,
                    child: Text(
                      widget.author.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14.5,
                          fontFamily: "Fira",
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  (widget.author.isVerified)
                      ? Image.asset(
                          verifyIcon,
                          height: 17.5,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            elevation: 0.2,
            backgroundColor: primaryBackgroundColor,
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              PopupMenuButton(
                onSelected: (value) {
                  if (value == 'Report Article') {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ReportModalSheet(
                        articleId: widget.article.articleId,
                        articleOwnerId: widget.author.userId,
                      ),
                    );
                  } else {
                    QuickAlert.show(
                        confirmBtnText: "Yes",
                        confirmBtnTextStyle:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        cancelBtnTextStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400),
                        context: context,
                        barrierDismissible: true,
                        onCancelBtnTap: () => Navigator.pop(context),
                        onConfirmBtnTap: () async {
                          final myArticlesProvider =
                              Provider.of<MyArticlesController>(context,
                                  listen: false);
                          final articlesProvider =
                              Provider.of<ArticlesController>(context,
                                  listen: false);
                          final navigator = Navigator.of(context);
                          await myArticlesProvider.deleteThisArticle(
                              myUid: myUserId,
                              articleId: widget.article.articleId);
                          await articlesProvider.fetchArticles();

                          navigator.pop();
                          navigator.pop();
                        },
                        cancelBtnText: "No",
                        showCancelBtn: true,
                        title: "Are you sure you want to delete this article?",
                        type: QuickAlertType.warning);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: widget.author.userId == myUserId
                        ? 'Delete Article'
                        : 'Report Article',
                    child: Text(widget.author.userId == myUserId
                        ? 'Delete Article'
                        : 'Report Article'),
                  ),
                ],
              ),
            ],
            pinned: false,
            snap: false,
            floating: false,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                widget.article.title,
                style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Play",
                    fontWeight: FontWeight.w500,
                    fontSize: 22),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                switch (widget.article.body[index]['type']) {
                  case 'text':
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 12.0, left: 20, right: 20),
                      child: SelectableText(
                        widget.article.body[index]['text']!,
                        style:
                            const TextStyle(fontFamily: "Open", fontSize: 15.5),
                      ),
                    );
                  case 'image':
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 12.0, left: 20, right: 20),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              showImageViewer(
                                  context,
                                  CachedNetworkImageProvider(
                                    widget.article.body[index]['image']!,
                                    // placeholder: (context, url) {
                                    //   return const Center(
                                    //     child: CircularProgressIndicator(
                                    //       color: authMaterialButtonColor,
                                    //     ),
                                    //   );
                                    // },
                                    // errorWidget: (context, url, error) {
                                    //   return const Text(
                                    //     "Could not load image",
                                    //     style: TextStyle(
                                    //         color: Colors.black87, fontSize: 10),
                                    //   );
                                    // },
                                  ),
                                  swipeDismissible: true,
                                  doubleTapZoomable: true);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => DisplayFullImage(
                              //           caption: widget.article.body[index]
                              //               ['imageCaption'],
                              //           imageurl: widget.article.body[index]
                              //               ['image']!),
                              //     ));
                            },
                            child: CachedNetworkImage(
                              imageUrl: widget.article.body[index]['image']!,
                              placeholder: (context, url) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: authMaterialButtonColor,
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return const Text(
                                  "Could not load image",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 10),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.article.body[index]['imageCaption']!,
                            style: const TextStyle(
                                fontFamily: "Open", fontSize: 13),
                          )
                        ],
                      ),
                    );
                  default:
                    return const Text("Some data");
                }
              },
              childCount: widget.article.body.length,
            ),
          ),
        ],
      )),
    );
  }
}
