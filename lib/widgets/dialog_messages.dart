import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> okMessageDialog(BuildContext context, String title, String msg) {
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> bottomMessage(
    BuildContext context, String msg) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
    ),
  );
}
