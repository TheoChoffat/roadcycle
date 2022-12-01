import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:roadcycle/screens/auth/Register.dart';
import 'package:roadcycle/screens/my_home.dart';

import '../all_routes.dart';
import 'utils.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  //final VoidCallback onClickedSignUp;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final docUser = FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser?.uid);

      final isAdmin = await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((value) {
        return value.data()!['isAdmin'];
      });

      if (isAdmin == true) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed("/register");
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed("/my_home");
      }
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  void goToRegisterPage() {
    Navigator.of(context).pushNamed("/register");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Enter Email"),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: "Enter Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(Icons.lock_open, size: 32),
                label: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: signIn,
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    text: "No Account?  ",
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                Navigator.of(context).pushNamed("/register"),
                          text: "Sign Up",
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ))
                    ]),
              )
            ])));
  }
}
