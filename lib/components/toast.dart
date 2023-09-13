import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// TOAST CLASS TO ACCESS  THIS TOAST IN ENTIRE APP
class AppToast {
  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.shade300,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
