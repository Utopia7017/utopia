import 'package:flutter/material.dart';
import 'package:utopia/constants/image_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  final space = const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            //  backgroundColor:Theme.of(context).scaffoldBackgroundColor,
            ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: const NetworkImage(
                        'https://i.pinimg.com/564x/17/b0/8f/17b08fc3ad0e62df60e15ef557ec3fe1.jpg'),
                  ),
                ),
              ),
              space,
              Text(
                "Abhishek Kumar",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                "Abhishek1234@gmail.com",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              space,
              Text(
                maxLines: 2,
                textAlign: TextAlign.center,
                "I'm a positive person. I love to travel and eat.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              space,
              space,
              MaterialButton(
                onPressed: () {},
                child: Text("Follow"),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 45.3, vertical: 20),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "870",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Following",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 30, color: Colors.blueGrey),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Column(
                      children: [
                        Text(
                          "120k",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Followers",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                      ],
                    ),
                    SizedBox(width: 18),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 30, color: Colors.blueGrey),
                    ),
                    SizedBox(width: 18),
                    Column(
                      children: [
                        Text(
                          "35",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Articles",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
