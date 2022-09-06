import 'package:flutter/material.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/utils/device_size.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        height: displayHeight(context) * 0.06,
        width: displayWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Search articles...',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            Image.asset(
              searchIcon,
              height: 16,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
