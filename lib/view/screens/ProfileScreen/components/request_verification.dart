import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/constants/image_constants.dart';

class RequestVerification extends StatelessWidget {
  const RequestVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: authBackground,
        leading: IconButton(onPressed: () {
         Navigator.pop(context); 
        }, icon: const Icon(Icons.arrow_back)),
        title: const Text('Request verification',style: TextStyle(fontFamily: "open"),),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          const Text('Apply for Utopia',style: TextStyle(fontSize: 30,fontFamily: "open",fontWeight: FontWeight.bold),),
          const SizedBox(height: 15,),
          const Text('verification',style: TextStyle(fontSize: 30,fontFamily: "open",fontWeight: FontWeight.bold),),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 60,
            width: 90,
            child: Image.asset(verifyIcon,),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
            child: Container(
              child: const Text('Verified accounts have green ticks next to their names to show that Utopia has confirmed they are real presence of public figures.',style: TextStyle(fontSize: 16,fontFamily: "open")),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Container(
                child: const Text('While applying for verification users must have more than 50 articles and 100 + followers . If the user meets our requirements then the user will be verified',style: TextStyle(fontSize: 16,fontFamily: "open")),
              ),
            ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            color: authMaterialButtonColor,
            child: const Text('Request verification'),
            onPressed: () {
            
          },)
        ],
      ),
    );
  }
}