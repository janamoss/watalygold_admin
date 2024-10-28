import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

void showErrorFlushbar(BuildContext context, String title, String message) {
  Flushbar(
    title: title,
    message: message,
    messageColor: Colors.red.shade300,
    titleColor: Colors.red.shade300,
    borderRadius: BorderRadius.circular(10),
    margin: EdgeInsets.all(15),
    maxWidth: 600,
    icon: Icon(
      Icons.error_rounded,
      size: 28,
      color: Colors.red.shade400,
    ),
    duration: const Duration(seconds: 3),
    leftBarIndicatorColor: Colors.red.shade400,
    backgroundColor: Colors.white,
    flushbarPosition: FlushbarPosition.TOP,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  ).show(context);
}

void showSuccessFlushbar(BuildContext context, String title, String message) {
  Flushbar(
    title: title,
    message: message,
    messageColor: Colors.green.shade300,
    titleColor: Colors.green.shade300,
    borderRadius: BorderRadius.circular(10),
    margin: EdgeInsets.all(15),
    maxWidth: 600,
    icon: Icon(
      Icons.check_circle_rounded,
      size: 28,
      color: Colors.green.shade400,
    ),
    duration: const Duration(seconds: 3),
    leftBarIndicatorColor: Colors.green.shade400,
    backgroundColor: Colors.white,
    flushbarPosition: FlushbarPosition.TOP,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  ).show(context);
}
