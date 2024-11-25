import 'package:flutter/material.dart';
import '../../navigation/navigation.dart';

void authenticateUser(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const UserNavigation()),
  );
}

// void _login() {
//   if (_formKey.currentState!.validate()) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const UserNavigation()),
//     );
//   }
// }
