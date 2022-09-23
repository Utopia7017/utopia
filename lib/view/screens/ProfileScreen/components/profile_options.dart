import 'package:flutter/material.dart';
import 'package:utopia/view/screens/MyArticlesScreen/My_articles_screen.dart';

class ProfileOptions extends StatelessWidget {
  Widget tile(String label, Icon icon, Function() callback) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -2.5),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
        leading: icon,
        onTap: callback,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        tile("My Articles", const Icon(Icons.book), () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyArticleScreen(),))),

        tile("Blocked Authors", const Icon(Icons.block_outlined), () => null),
      //  const Divider(),
        tile("Sign out", const Icon(Icons.logout), () => null),
        // Divider(),
      ],
    );
  }
}
