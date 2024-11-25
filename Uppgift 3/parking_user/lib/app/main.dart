import 'package:flutter/material.dart';
import 'package:parking_user/navigation/pages/login_page.dart';

void main() {
  runApp(const ParkingUserApp());
}

class ParkingUserApp extends StatelessWidget {
  const ParkingUserApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking User',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
