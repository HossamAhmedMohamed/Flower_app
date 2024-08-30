 
 import 'package:flutter/material.dart';
 



 showSnackBar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(days: 1),
      content: Text(text),
      action: SnackBarAction(label: "close", onPressed: () {}),
    ));
 }