import 'package:flutter/material.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/common_ui/skeleton.dart';

class CommentBoxSkeleton extends StatelessWidget {
  const CommentBoxSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
                    children: [
                      Row(
                      children: [
                        const Skeleton(height: 35, width:35 ),
                        const SizedBox(width: 10,),
                        Skeleton(height: 20, width: displayWidth(context)*0.5),
                        const SizedBox(width: 60,),
                        Skeleton(height: 15, width: displayWidth(context)*0.1),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Skeleton(height: displayHeight(context)*0.1, width: displayWidth(context)*0.7),
                    Divider(color:Colors.black.withOpacity(0.16) ,height: 22,)
                    
                    ],
                  );
  }
}