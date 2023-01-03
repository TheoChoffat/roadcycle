// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../utility/AppColors.dart';
import 'utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

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

      final isAdminChecked = await docUser.get().then((value) {
        return value.data()!['isAdmin'];
      });

      isAdmin = isAdminChecked;

      if (isAdmin == true) {
        //Change after to
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed("/my_routes");
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
        backgroundColor: AppColors.main.orange,
        body: ListView(children: [
          Container(
            height: 80,
          ),
          Image.asset(
            'assets/images/logo_roadcycle_orange.png',
            height: 35,
          ),
          Container(
            height: 80,
          ),
          Container(
              margin: const EdgeInsets.all(16),
              height: 400,
              decoration: BoxDecoration(
                  color: AppColors.main.white,
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)!.username,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 25),
                          ),
                        ),
                        TextField(
                          controller: emailController,
                          cursorColor: Colors.white,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: "example@gmail.com",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffef4f19)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffef4f19)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)!.password,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 25),
                          ),
                        ),
                        TextField(
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            hintText: "********",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffef4f19)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffef4f19)),
                            ),
                          ),
                          obscureText: true,
                          cursorColor: AppColors.main.orange,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 60,
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.main.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            onPressed: signIn,
                            child: Text(
                              AppLocalizations.of(context)!.signIn,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          child: Text(
                            AppLocalizations.of(context)!.forgotPassword,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                              fontSize: 20,
                            ),
                          ),
                          onTap: () => Navigator.of(context)
                              .pushNamed("/forgot_password_page"),
                        ),
                        RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                              text: AppLocalizations.of(context)!.noAccount,
                              children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.of(context)
                                          .pushNamed("/register"),
                                    text: AppLocalizations.of(context)!.signUp,
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.black,
                                        fontSize: 16))
                              ]),
                        ),
                      ]))),
        ]));
  }
}
