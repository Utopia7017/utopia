import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:utopia/view/common_ui/auth_textfields.dart';

class SignUpScreen extends StatelessWidget {
  final Logger _logger = Logger("SignUpScreen");

  TextEditingController emailController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  final space = const SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 38, 39, 41),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create an account",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              const SizedBox(height: 40),
              AuthTextField(
                controller: nameController,
                label: "Name",
                visible: true,
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.white60,
                ),
                validator: (val) {
                  if (val!.isEmpty) return "Name cannot be empty";
                },
              ),
              space,
              AuthTextField(
                controller: emailController,
                label: "Email",
                visible: true,
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.white60,
                ),
                validator: (val) {
                  // TODO : Implement the email validator using regex @Abhi-kr21
                  if (val!.isEmpty) return "Email cannot be empty";
                },
              ),
              space,
              AuthTextField(
                controller: passwordController,
                label: "Password",
                visible: true,
                prefixIcon: const Icon(
                  Icons.key,
                  color: Colors.white60,
                ),
                validator: (val) {
                  if (val!.isEmpty) return "Password cannot be empty";
                },
              ),
              space,
              AuthTextField(
                controller: confirmPasswordController,
                label: "Confirm Password",
                visible: true,
                prefixIcon: const Icon(
                  Icons.security,
                  color: Colors.white60,
                ),
                validator: (val) {
                  if (val!.isEmpty) return "Confirm Password cannot be empty";
                },
              ),
              space,
              MaterialButton(
                onPressed: () {},
                color: Color.fromARGB(255, 255, 226, 174),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text("Create an account"),
              ),
              space,
              Row(
                children: [
                  Text("Already have an account?"),
                  SizedBox(
                    width: 5,
                  ),
                  Text("login"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
