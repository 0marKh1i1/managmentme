import 'package:flutter/material.dart';
import 'package:managementme/core/constants/globals.dart';

void toast(String msg) {
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(content: Text(msg)),
  );
}
