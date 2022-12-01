import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../all_routes.dart';
import 'utils.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final docUser = FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser?.uid);
      final json = {
        "firstname": firstnameController.text.trim(),
        "lastname": lastnameController.text.trim(),
        "isAdmin": false
      };

      await docUser.set(json);

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AllRoutes()),
      );
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: firstnameController,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        decoration:
                            const InputDecoration(labelText: "Enter Firstname"),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (firstname) =>
                            firstname != null && firstname.length < 2
                                ? 'Enter your Firstname'
                                : null,
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: lastnameController,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        decoration:
                            const InputDecoration(labelText: "Enter Lastname"),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (lastname) =>
                            lastname != null && lastname.length < 2
                                ? 'Enter your Lastname'
                                : null,
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: emailController,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        decoration:
                            const InputDecoration(labelText: "Enter Email"),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: passwordController,
                        textInputAction: TextInputAction.done,
                        decoration:
                            const InputDecoration(labelText: "Enter Password"),
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'Enter min. 6 Characters'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        icon: const Icon(Icons.lock_open, size: 32),
                        label: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 24),
                        ),
                        onPressed: signUp,
                      ),
                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            text: "Already have an Account?  ",
                            children: [
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.of(context)
                                        .pushNamed("/login"),
                                  text: "Sign In",
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.black,
                                  ))
                            ]),
                      )
                    ]))));
  }
}
