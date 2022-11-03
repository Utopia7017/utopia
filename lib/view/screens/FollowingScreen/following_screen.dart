import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/UserProfileScreen/user_profile_screen.dart';
import 'package:utopia/view/shimmers/follower_shimmer.dart';

class FollowingScreen extends StatelessWidget {
  final User user;
  FollowingScreen({Key? key, required this.user}) : super(key: key);
  String currentuserid = firebase.FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: authBackground,
        title: const Text(
          'Following',
          style: TextStyle(fontFamily: "Fira", fontSize: 15),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: LiquidPullToRefresh(
         onRefresh: ()async {
          return await Future.delayed(Duration(seconds: 2));
        },
        backgroundColor: authBackground,
        color: Colors.white,
        height: displayHeight(context)*0.15,
        showChildOpacityTransition: false,
        child: Column(
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
                          User followingUser = snapshot.data!;
                          List<String> initials = followingUser.name.split(" ");
                          String firstLetter = "", lastLetter = "";
      
                          if (initials.length == 1) {
                            firstLetter = initials[0].characters.first;
                          } else {
                            firstLetter = initials[0].characters.first;
                            lastLetter = initials[1].characters.first;
                          }
                          return ListTile(
                            visualDensity: VisualDensity(vertical: 2.5),
                            onTap: () {
                              if (currentuserid != followingUser.userId) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserProfileScreen(
                                          userId: followingUser.userId),
                                    ));
                              }
                            },
                            leading: (followingUser.dp.isEmpty)
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
                                        followingUser.dp),
                                  ),
                            title: Row(
                              children: [
                                Text(
                                   followingUser.name
                                ),
                                SizedBox(width: 5,),
                                followingUser.isVerified?Image.asset(
                                          verifyIcon,
                                          height: 17.5,
                                        ):SizedBox(),
      
                              ],
                            ),
                            dense: true,
                            trailing: (currentuserid == user.userId)
                                ? MaterialButton(
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
                                  )
                                : null,
                          );
                        
                        } else { 
                          return const FollowerShimmer();
                        }
                      },
                      future: controller.getUser(user.following[index]),
                    );
                  },
                  itemCount: user.following.length,
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
