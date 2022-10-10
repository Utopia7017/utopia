import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart' as usermodel;
import 'package:utopia/view/common_ui/display_full_image.dart';
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
      lastLetter = initials[1].characters.first;
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
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  )
                                : Text(
                                    firstLetter.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 30,
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
                  Text(
                    widget.author.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.5,
                        fontFamily: "Fira",
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            elevation: 0.2,
            backgroundColor: primaryBackgroundColor,
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              // Options
              PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(child: Text('Report Article')),
                  PopupMenuItem(child: Text('Block Author')),
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DisplayFullImage(
                                    imageurl: widget.article.body[index]
                                        ['image']!),
                              ));
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
