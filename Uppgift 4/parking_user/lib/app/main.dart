import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_shared/parking_shared.dart';
import 'package:parking_user/handlers/login/auth_cubit.dart';
import 'package:parking_user/navigation/navigation.dart';
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
    final isLoggedIn =
        context.watch<AuthCubit>().state == AuthStatus.authenticated;
    return MaterialApp(
      title: 'Parkering Användare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const UserNavigation() : const LoginPage(),
    );
  }
}
