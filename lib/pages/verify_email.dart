// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/pages/home.dart';
import 'package:flower_app/shared/colors.dart';
import 'package:flower_app/shared/snackbar.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        // when we click on the link that existed on yahoo
        await FirebaseAuth.instance.currentUser!.reload();

        // is email verified or not (clicked on the link or not) (true or false)
        setState(() {
          isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        });

        if (isEmailVerified) {
          timer.cancel();
        }
      });
    }
  }

  sendVerificationEmail() async {
    try {
      // await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      showSnackBar(context, "ERROR => ${e.toString()}");
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const Home()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Verify Email"),
              elevation: 0,
              backgroundColor: appbarGreen,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "A verification email has been sent to your email",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      canResendEmail ? sendVerificationEmail() : null;
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(bTNgreen),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                    ),
                    child: const Text(
                      "Resent Email",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    // style: ButtonStyle(
                    //   backgroundColor: MaterialStateProperty.all(BTNpink),
                    //   padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                    //   shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8))),
                    // ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
