import 'package:chatapp/Pages/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Services/auth_service.dart';
import 'HomePage.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    String email = emailController.text;
    String password = passwordController.text;

    try {
      User? user = await authService.signInWithEmailandPassword(email, password);

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Some error occurred")),
        );
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
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
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
                Icon(
                  Icons.chat_rounded,
                  size: 150,
                  color: Colors.blueGrey.shade400,
                ),
                const SizedBox(
                  height: 50,
                ),
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
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    signIn();
                  },
                  child: Text("Login", style: TextStyle(color: Colors.black54),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade300),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.fromLTRB(30, 15, 30, 15),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                    },
                    child: Text("Haven't created an account? Sign up now!", style: TextStyle(color: Colors.red.shade300),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
