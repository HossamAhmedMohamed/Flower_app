
 // ignore_for_file: deprecated_member_use
 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/pages/sign_in.dart';
import 'package:flower_app/shared/colors.dart';
import 'package:flower_app/shared/contants.dart';
import 'package:flower_app/shared/snackbar.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  resetPassword() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child:   CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      if (!mounted) return;
      showSnackBar(context, "Done - Please check ur email");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    }

// Stop indicator
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  void dispose() {
   
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        elevation: 0,
        backgroundColor: appbarGreen,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(33.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Enter your email to rest your password.",
                    style:   TextStyle(fontSize: 18)),
                const SizedBox(
                  height: 33,
                ),
                TextFormField(
                    // we return "null" when something is valid
                    validator: (email) {
                      return email!.contains(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                          ? null
                          : "Enter a valid email";
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                        hintText: "Enter Your Email : ",
                        suffixIcon: const Icon(Icons.email))),
                const SizedBox(
                  height: 33,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      resetPassword();
                    } else {
                      showSnackBar(context, "ERROR");
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(bTNgreen),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Reset Password",
                          style:   TextStyle(fontSize: 19),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
