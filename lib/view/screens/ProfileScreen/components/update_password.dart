import 'package:flutter/material.dart';
import 'package:utopia/constants/color_constants.dart';
import 'package:utopia/view/common_ui/auth_textfields.dart';

class UpdatePassword extends StatelessWidget {
 
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: authBackground,
      appBar: AppBar(
        backgroundColor: authBackground,
        title: const Text('Update password',style: TextStyle(fontFamily: "open"),),
        leading: IconButton(onPressed: () {
          
        }, icon: const Icon(Icons.arrow_back)),
      ),
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 130),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthTextField(
                  controller: emailController, 
                  label: "Email", 
                  visible: true, 
                  prefixIcon: const Icon(Icons.email,color: Colors.white60,), 
                  validator: (val) {
                          if (val!.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                  ),
                const SizedBox(
                  height: 40,
                ),
                AuthTextField(
                  controller: passwordController, 
                  label: "Old password", 
                  visible: false, 
                  prefixIcon: const Icon(Icons.key,color: Colors.white60,), 
                  validator: (val) {
                              if (val!.isEmpty) {
                                return "Cannot be empty";
                              }
                              return null;
                            },
                  ),
                const SizedBox(
                  height: 40,
                ),
                AuthTextField(
                  controller: passwordController, 
                  label: "New password", 
                  visible: false, 
                  prefixIcon: const Icon(Icons.key,color: Colors.white60,), 
                  validator: (val) {
                              if (val!.isEmpty) {
                                return "Cannot be empty";
                              }
                              return null;
                            },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: MaterialButton(
                      child: const Text('Update Password',style: TextStyle(fontFamily: "open"),),
                      color: authMaterialButtonColor,
                      shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                      onPressed: () {
                      
                    },),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}