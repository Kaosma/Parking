import 'package:flutter/material.dart';

import '../../navigation/pages/login_page.dart';

Future<void> signOutUser(BuildContext context) async {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
  // try {
  //   await FirebaseAuth.instance.signOut();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('You have successfully signed out!')),
  //   );
  //   // Navigator.pushReplacementNamed(context, '/login');
  // } catch (e) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Sign-out failed. Please try again.')),
  //   );
  //   print('Error signing out: $e');
  // }
}
