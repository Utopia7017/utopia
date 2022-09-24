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
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 50,
              width: 350,
              child: TextFormField(
                 keyboardType: TextInputType.name,
                 decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'search',
                  border: OutlineInputBorder(
                  borderSide: const BorderSide(),
                    borderRadius: BorderRadius.circular(30),
                    ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1),
                     borderRadius: BorderRadius.circular(30)
                  )
                 ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: 15,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext, context) 
                  {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.account_box_rounded),
                    ),
                    title: Text('Kakashi hatake'),
                    dense: true,

                    trailing:  MaterialButton(
                      onPressed: () {
                          
                        },
                        height: 30,
                        color: authMaterialButtonColor,
                        shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                               ),
                          child: Text('Following',style: TextStyle(fontSize: 15.5),),
                        ),
                  );
                },),
          ),
        ],
      ),
    );
  }
}
