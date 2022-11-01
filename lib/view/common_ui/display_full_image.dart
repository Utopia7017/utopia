import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:utopia/constants/color_constants.dart';


class DisplayFullImage extends StatelessWidget {
 
 final String imageurl;
 final String caption;
 DisplayFullImage({required this.imageurl, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(caption,style: TextStyle(color: Colors.black,fontSize: caption.length>=35?12:14),),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child:  CachedNetworkImage(
                          imageUrl: imageurl,
                          imageBuilder: (context, imageProvider) => PhotoView(
                              imageProvider: imageProvider,
                              basePosition: Alignment.center,
                              minScale: PhotoViewComputedScale.contained * 1,
                              maxScale: PhotoViewComputedScale.covered * 0.9,
                               backgroundDecoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                ),
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