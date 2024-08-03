import 'package:chatapp/Pages/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      if (emailController.text == "") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email is missing!")),
        );
      } else if (passwordController.text == "") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password is missing!")),
        );
      } else if (confirmPasswordController.text != passwordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords don't match!")),
        );
      } else {
        User? user = await authService.signUpWithEmailandPassword(
          emailController.text,
          passwordController.text,
        );
        if (user != null) {
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Your account is successfully created! Now you can login and access the app.")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Some error occurred")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  obscureText: false,
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Password"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Confirm password"),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: signUp,
                  child: Text("Sign Up"),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.fromLTRB(30, 15, 30, 15),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text("Already have an account? Login now!"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
