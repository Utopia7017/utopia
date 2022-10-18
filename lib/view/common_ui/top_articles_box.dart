import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/models/article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';

class TopArticleBox extends StatelessWidget {
  final Article article;
  final User user;
  const TopArticleBox({super.key, required this.article, required this.user});

  @override
  Widget build(BuildContext context) {
    String? imagePreview;
    for (Map<String, dynamic> body in article.body) {
      if (body['type'] == "image") {
        imagePreview = body['image'];
        break;
      }
    }
    dynamic articlePreview =
        article.body.firstWhere((element) => element['type'] == "text");

    return Container(
      width: displayWidth(context) * 0.45,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: (imagePreview != null)
                ? CachedNetworkImage(
                    imageUrl: imagePreview,
                    errorWidget: (context, url, error) {
                      return const Text(
                        "Could not load image",
                        style: TextStyle(color: Colors.black87, fontSize: 10),
                      );
                    },
                    placeholder: (context, url) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: authMaterialButtonColor,
                        ),
                      );
                    },
                    width: displayWidth(context) * 0.4,
                    height: displayHeight(context) * 0.18,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    defaultArticleImage,
                    width: displayWidth(context) * 0.4,
                    height: displayHeight(context) * 0.18,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: displayWidth(context) * 0.4,
            child: Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: "Open",
                  letterSpacing: 0.08,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: displayWidth(context) * 0.4,
            child: Text(
              articlePreview['text'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.grey,
                  // fontFamily: "Open",
                  letterSpacing: 0.08,
                  fontSize: 10.8,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
