import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/view/screens/ExploreScreen/components/search_box.dart';

class FollowingScreen extends StatelessWidget {
  final User user;
  const FollowingScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: authBackground,
        title: const Text('Following',style: TextStyle(fontFamily: "Fira",fontSize: 15),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SearchBox(),
          ),
          Expanded(
            child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: 15,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext, context) 
                  {
                  return Container(
                    height: 70,
                    width: 100,
                    color: Colors.white60,
                    margin:  EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:   [
                       Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.amber,
                          ),
                        ),
                        Text('Kakashi Hatake', style: TextStyle(fontWeight: FontWeight.w700,fontSize: 17.5),),
                        MaterialButton(onPressed: () {
                          
                        },
                        color: authMaterialButtonColor,
                        shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                               ),
                          child: Text('Following',style: TextStyle(fontSize: 15.5),),
                        ),
                      ],
                    ),
                  );
                },),
          ),
        ],
      ),
    );
  }
}
