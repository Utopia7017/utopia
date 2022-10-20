import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseUser;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/controller/user_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/utils/device_size.dart';
import 'package:utopia/view/screens/UserProfileScreen/user_profile_screen.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: authBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Blocked users",
          style: TextStyle(fontFamily: "Open", fontSize: 14),
        ),
      ),
      body: SafeArea(
        child: Consumer<UserController>(
          builder: (context, userController, child) {
            if (userController.profileStatus == ProfileStatus.nil) {
              userController
                  .setUser(firebaseUser.FirebaseAuth.instance.currentUser!.uid);
            }
            switch (userController.profileStatus) {
              case ProfileStatus.nil:
                return Text("Pull to refresh");
              case ProfileStatus.loading:
                // Todo : add shimmer effect for this screen
                return const Center(child: CircularProgressIndicator());

              case ProfileStatus.fetched:
                return Column(
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
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                          future: userController
                              .getUser(userController.user!.blocked[index]),
                          builder: (context, AsyncSnapshot<User?> snapshot) {
                            if (snapshot.hasData) {
                              User blockedUser = snapshot.data!;
                              List<String> initials =
                                  blockedUser.name.split(" ");
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
                                            userId: blockedUser.userId),
                                      ));
                                },
                                leading: (blockedUser.dp.isEmpty)
                                    ? CircleAvatar(
                                        backgroundColor:
                                            authMaterialButtonColor,
                                        child: Center(
                                          child: initials.length > 1
                                              ? Text(
                                                  "$firstLetter.$lastLetter"
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                )
                                              : Text(
                                                  firstLetter.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                blockedUser.dp),
                                      ),
                                title: Text(blockedUser.name),
                                dense: true,
                                trailing: MaterialButton(
                                  elevation: 1,
                                  onPressed: () {
                                    userController
                                        .unBlockThisUser(blockedUser.userId);
                                  },
                                  height: 30,
                                  color: authMaterialButtonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Unblock',
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
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        );
                      },
                      itemCount: userController.user!.blocked.length,
                    ))
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
