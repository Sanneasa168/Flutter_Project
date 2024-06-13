
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAlertDailaog {
  static void showDailaog({  
    required  BuildContext context,
    required String title, 
    required  String content,
    required Function() tapNo,
    required Function() tapYes,
  })
  {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title:  Text(title),
        content:  Text(content),
        actions: [
          CupertinoDialogAction(
            child: const Text("No"),
            onPressed: tapNo
          ),
          CupertinoDialogAction(
            child: const Text("Yes"),
            isDestructiveAction: true,
            onPressed: tapYes,
          ),
        ],
      ),
    );
  }
}