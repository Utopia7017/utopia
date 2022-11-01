import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
          backgroundColor: authBackground,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Help & Support",
            style: TextStyle(fontFamily: "Open", fontSize: 14),
          ),
          actions: const [
            Padding(
              padding:  EdgeInsets.only(right: 20),
              child: Icon(Icons.live_help_outlined),
            ),
          ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 15, 10, 10),
              child: Container(
                child:  const Text('Reach us',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "open"),),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  backgroundColor: authBackground,
                  child: IconButton(onPressed:  () {
                    
                  }, icon: const Icon(Icons.discord,color: Colors.white,)),
                ),
                CircleAvatar(
                  backgroundColor: authBackground,
                  child: IconButton(onPressed: () {
                    
                  }, icon: const Icon(Icons.facebook,color: Colors.white,)),
                ),
                CircleAvatar(
                  backgroundColor: authBackground,
                  child: IconButton(onPressed: () {
                    
                  }, icon: const Icon(Icons.email,color: Colors.white,)),
                ),
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('Discord',style: TextStyle(fontFamily: "open"),),
                Text('Facebook',style: TextStyle(fontFamily: "open"),),
                Text('Email',style: TextStyle(fontFamily: "open"),)
              ],
            ),
            const SizedBox(
              height: 40,
            ),
           const Padding(
              padding:  EdgeInsets.only(left: 30),
              child: Text('Write your feedbacks here:',style: TextStyle(fontSize: 18,fontFamily: "open"),),
            ),
            const SizedBox(height: 15,),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(30, 2, 30, 2),
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //       hintText: 'feedback',hintStyle: const TextStyle(fontFamily: "open"),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),  
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 2, 30, 2),
              child: DropdownButtonFormField(
                        isExpanded: true,
                        value: "Feedback",
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white54),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        hint: const Text("Feedback"),
                 items: ['Feedback','Complaints',"Suggetions (Feature/Bug fixes)"].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                 onChanged: (value) {
                
              },),
            ),
            const SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 2, 30, 2),
              child: TextFormField(
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'Enter your message here',hintStyle: const TextStyle(fontFamily: "open"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),  
                  )
                ),
              ),
            ),
             const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 2, 30, 2),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',hintStyle: const TextStyle(fontFamily: "open"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),  
                  )
                ),
              ),
            ),
            const SizedBox(height: 15,),
            Center(
              child: MaterialButton(
                child:  const Text('Send Feedback',style: TextStyle(fontFamily: "open"),),
                color: authMaterialButtonColor,
                onPressed: () {
                
              },),
            )
          ],
        ),
      ),
    );
  }
}