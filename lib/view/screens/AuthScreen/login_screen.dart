import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:utopia/constants/color_constants.dart';

class LoginScreen extends StatelessWidget {
  final Logger _logger = Logger("LoginScreen");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: authBackground,
        appBar: AppBar(
        backgroundColor: authBackground,
        elevation: 0,
        leading: Icon(Icons.arrow_back,color: Colors.white,),
      ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                 fontSize: 23,
                 fontFamily: "Play",
                 letterSpacing: 1.2,
                 color: Colors.white,
                 ),
                
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: authTextBoxColor,
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white60,
                    ),
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: authTextBoxColor,
                  prefixIcon: Icon(
                    Icons.password,
                    color: Colors.white60,
                    ),
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              
              Center(
                child: SizedBox(
                   width: MediaQuery.of(context).size.width * 0.33,
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height*0.055,
                    onPressed: () {},
                    child: Text("Login"),
                    color: authMaterialButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
