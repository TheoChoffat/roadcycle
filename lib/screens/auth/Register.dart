import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utility/AppColors.dart';
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
            height: 30,
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              height: 560,
              decoration: BoxDecoration(
                  color: AppColors.main.white,
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              padding: const EdgeInsets.all(16),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                  child: Form(
                      key: formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: firstnameController,
                              cursorColor: Colors.white,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.firstname,
                                labelStyle:
                                    const TextStyle(color: Colors.black54),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffef4f19)),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffef4f19)),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (firstname) => firstname != null &&
                                      firstname.length < 2
                                  ? AppLocalizations.of(context)!.firstnameError
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: lastnameController,
                              cursorColor: Colors.white,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.lastname,
                                labelStyle:
                                    const TextStyle(color: Colors.black54),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffef4f19)),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffef4f19)),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (lastname) => lastname != null &&
                                      lastname.length < 2
                                  ? AppLocalizations.of(context)!.lastnameError
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: emailController,
                              cursorColor: Colors.white,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.email,
                                labelStyle:
                                    const TextStyle(color: Colors.black54),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffef4f19)),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffef4f19)),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (email) => email != null &&
                                      !EmailValidator.validate(email)
                                  ? AppLocalizations.of(context)!.emailError
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.passwordEnter,
                                labelStyle:
                                    const TextStyle(color: Colors.black54),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffef4f19)),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffef4f19)),
                                ),
                              ),
                              obscureText: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) =>
                                  value != null && value.length < 6
                                      ? AppLocalizations.of(context)!
                                          .passwordEnterError
                                      : null,
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
                                onPressed: signUp,
                                child: Text(
                                  AppLocalizations.of(context)!.signUp,
                                  style: const TextStyle(fontSize: 25),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            RichText(
                              text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  text: AppLocalizations.of(context)!
                                      .alreadyAccount,
                                  children: [
                                    TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => Navigator.of(context)
                                              .pushNamed("/login"),
                                        text: AppLocalizations.of(context)!
                                            .signIn,
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.black,
                                            fontSize: 16))
                                  ]),
                            )
                          ]))))
        ]));
  }
}
