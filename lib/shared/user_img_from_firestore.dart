 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ImgUser extends StatefulWidget {
  const ImgUser({
    Key? key,
  }) : super(key: key);

  @override
  State<ImgUser> createState() => _ImgUserState();
}

class _ImgUserState extends State<ImgUser> {
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('userSSS');

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userSSS');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(credential!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          // ${data['title']}
          return CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 225, 225, 225),
            radius: 71,
            // backgroundImage: AssetImage("assets/img/avatar.png"),
            backgroundImage: NetworkImage(data["imgLink"]),
          );
        }

        return const Text("loading");
      },
    );
  }
}
