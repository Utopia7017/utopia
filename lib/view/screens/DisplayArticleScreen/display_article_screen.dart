import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/view/screens/CommentScreen/comment_screen.dart';

class DisplayArticleScreen extends StatelessWidget {
  final Article article;
  final User author;
  DisplayArticleScreen({required this.article, required this.author});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
          child: CustomScrollView(
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
                    author.name,
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
              // Like Article
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Image.asset(
                  likeNotPressedIcon,
                  height: 10,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              // Comment article
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentScreen(),
                        ));
                  },
                  child: Image.asset(commentArticleIcon, height: 10),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              // Save article
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Image.asset(saveArticleIcon, height: 10),
              ),

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
                article.title,
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
                switch (article.body[index]['type']) {
                  case 'text':
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 12.0, left: 20, right: 20),
                      child: Text(
                        article.body[index]['text']!,
                        style: TextStyle(fontFamily: "Open", fontSize: 15.5),
                      ),
                    );
                  case 'image':
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 12.0, left: 20, right: 20),
                      child: CachedNetworkImage(
                        imageUrl: article.body[index]['image']!,
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
              childCount: article.body.length,
            ),
          ),
        ],
      )),
    );
  }
}
