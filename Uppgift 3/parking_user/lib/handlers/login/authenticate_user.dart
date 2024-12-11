import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';
import '../../navigation/navigation.dart';

void authenticateUser(BuildContext context, String userId) async {
  AppStrings.setUserId(userId);
  final owner = await getOwnerHandler(userId);
  if (owner != null) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserNavigation(userId: userId)),
    );
  }
}

// void _login() {
//   if (_formKey.currentState!.validate()) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const UserNavigation()),
//     );
//   }
// }
