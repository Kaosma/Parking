import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.blue;
  static const Color secondary = Colors.amber;
  static const Color background = Colors.white;
}

class AppStrings {
  static String userId = '';
  static void setUserId(String newId) {
    userId = newId;
  }
}
