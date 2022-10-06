import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:utopia/constants/color_constants.dart';


class DisplayFullImage extends StatelessWidget {
 
 final String imageurl;
 DisplayFullImage({required this.imageurl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child:  CachedNetworkImage(
                          imageUrl: imageurl,
                          imageBuilder: (context, imageProvider) => PhotoView(
                              imageProvider: imageProvider,
                           ),
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
      ),
    );
  }
}