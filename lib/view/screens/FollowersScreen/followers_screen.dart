import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/UserProfileScreen/user_profile_screen.dart';

class FollowersScreen extends StatelessWidget {
  final User user;
  const FollowersScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: authBackground,
        title: const Text(
          'Followers',
          style: TextStyle(fontFamily: "Fira", fontSize: 15),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Center(
            child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  alignment: Alignment.center,
                  height: displayHeight(context) * 0.068,
                  width: displayWidth(context) * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(fontSize: 13.5),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black54,
                        size: 18,
                      ),
                      border: InputBorder.none,
                    ),
                    cursorColor: Colors.black45,
                  ),
                )),
          ),
          const SizedBox(height: 10),
          Expanded(child: Consumer<UserController>(
            builder: (context, controller, child) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    builder: (context, AsyncSnapshot<User?> snapshot) {
                      if (snapshot.hasData) {
                        User followerUser = snapshot.data!;
                        List<String> initials = followerUser.name.split(" ");
                        String firstLetter = "", lastLetter = "";

                        if (initials.length == 1) {
                          firstLetter = initials[0].characters.first;
                        } else {
                          firstLetter = initials[0].characters.first;
                          lastLetter = initials[1].characters.first;
                        }
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfileScreen(
                                      userId: followerUser.userId),
                                ));
                          },
                          leading: (followerUser.dp.isEmpty)
                              ? CircleAvatar(
                                  backgroundColor: authMaterialButtonColor,
                                  child: Center(
                                    child: initials.length > 1
                                        ? Text(
                                            "$firstLetter.$lastLetter"
                                                .toUpperCase(),
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
                                  backgroundImage: CachedNetworkImageProvider(
                                      followerUser.dp),
                                ),
                          title: Text(followerUser.name),
                          dense: true,
                          trailing: MaterialButton(
                            onPressed: () {},
                            height: 30,
                            color: authMaterialButtonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Remove',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                    future: controller.getUser(user.followers[index]),
                  );
                },
                itemCount: user.followers.length,
              );
            },
          ))
        ],
      ),
    );
  }
}
