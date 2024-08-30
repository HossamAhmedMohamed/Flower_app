import 'package:flower_app/pages/home.dart';
import 'package:flower_app/pages/sign_in.dart';

import 'package:flower_app/provider/cart.dart';
import 'package:flower_app/provider/google_signin.dart';

import 'package:flower_app/shared/snackbar.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return Cart();
        }),
        ChangeNotifierProvider(create: (context) {
          return GoogleSignInProvider();
        }),
      ],
      child: MaterialApp(
          title: "myApp",
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              } else if (snapshot.hasError) {
                return showSnackBar(context, "Something went wrong");
              } else if (snapshot.hasData) {
                // return VerifyEmailPage();
                return const Home(); // home() OR verify email
              } else {
                return const Login();
              }
            },
          )),
    );
  }
}
