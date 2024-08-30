// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flower_app/shared/data_from_firestore.dart';
import 'package:flower_app/shared/user_img_from_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flower_app/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show basename;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final credential = FirebaseAuth.instance.currentUser;
  File? imgPath;
  String? imgName;
  CollectionReference users = FirebaseFirestore.instance.collection('userSSS');

  uploadImage2Screen() async {
    final pickedImg =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pop(context);
            },
            label: const Text(
              "logout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: appbarGreen,
        title: const Text("Profile Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(125, 78, 91, 110),
                  ),
                  child: Stack(
                    children: [
                      imgPath == null
                          ? const ImgUser()
                          : ClipOval(
                              child: Image.file(
                                imgPath!,
                                width: 145,
                                height: 145,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Positioned(
                        left: 103,
                        bottom: -10,
                        child: IconButton(
                          onPressed: () async {
                            await uploadImage2Screen();

                            if (imgPath != null) {
                              // Upload image to firebase storage
                              final storageRef = FirebaseStorage.instance
                                  .ref("users-imgs/$imgName");
                              await storageRef.putFile(imgPath!);
                              // Get img url
                              String urlll = await storageRef.getDownloadURL();

                              users.doc(credential!.uid).update({
                                "imgLink": urlll,
                              });
                            }
                          },
                          icon: const Icon(Icons.add_a_photo),
                          color: const Color.fromARGB(255, 94, 115, 128),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 33,
              ),
              Center(
                  child: Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 131, 177, 255),
                    borderRadius: BorderRadius.circular(11)),
                child: const Text(
                  "Info from firebase Auth",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    "Email: ${credential!.email}      ",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    //

                    "Created date:   ${DateFormat("MMMM d, y").format(credential!.metadata.creationTime!)}   ",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    //
                    "Last Signed In: ${DateFormat("MMMM d, y").format(credential!.metadata.lastSignInTime!)}  ",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 22,
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                      credential!.delete();

                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Delete User",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              const SizedBox(
                height: 22,
              ),
              Center(
                  child: Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 131, 177, 255),
                          borderRadius: BorderRadius.circular(11)),
                      child: const Text(
                        "Info from firebase firestore",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ))),
              GetDataFromFirestore(
                documentId: credential!.uid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
