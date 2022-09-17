import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/view/screens/CommentScreen/comment_screen.dart';
import 'package:utopia/utils/device_size.dart';

class DisplayArticleScreen extends StatefulWidget {
  final Article article;
  final User author;
  DisplayArticleScreen({required this.article, required this.author});

  @override
  State<DisplayArticleScreen> createState() => _DisplayArticleScreenState();
}

class _DisplayArticleScreenState extends State<DisplayArticleScreen> {
  ScrollController? _hideBottomNavController;
  bool? _isVisible;
  @override
  initState() {
    super.initState();
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
      floatingActionButton: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 750),
          height: _isVisible! ? displayHeight(context) * 0.2 : 0.0,
          width: displayWidth(context) * 0.1,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Like Article
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    likeNotPressedIcon,
                    height: 18,
                  ),
                ),
              ),

              // Comment article
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentScreen(),
                          ));
                    },
                    child: Image.asset(commentArticleIcon, height: 18),
                  ),
                ),
              ),

              // Save article
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(saveArticleIcon, height: 18),
              )),
            ],
          ),
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: SafeArea(
          child: CustomScrollView(
        controller: _hideBottomNavController,
        slivers: <Widget>[
          SliverAppBar(
            title: InkWell(
              onTap: () {
                // TODO : navigate to user profile screen
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://play-lh.googleusercontent.com/nCVVCbeSI14qEvNnvvgkkbvfBJximn04qoPRw8GZjC7zeoKxOgEtjqsID_DDtNfkjyo'),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    widget.author.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
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
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // @kaizer111 Open dialog box for options
                },
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
                      child: Text(
                        widget.article.body[index]['text']!,
                        style: TextStyle(fontFamily: "Open", fontSize: 15.5),
                      ),
                    );
                  case 'image':
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 12.0, left: 20, right: 20),
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
                            style:
                                TextStyle(color: Colors.black87, fontSize: 10),
                          );
                        },
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
