import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_shared/parking_shared.dart';
import 'package:parking_user/navigation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ParkingUserApp());
}

class ParkingUserApp extends StatelessWidget {
  const ParkingUserApp({super.key});

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
