import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_shared/parking_shared.dart';

import '../navigation/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ParkingAdminApp());
}

class ParkingAdminApp extends StatelessWidget {
  const ParkingAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Parking Admin',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MultiBlocProvider(providers: [
          BlocProvider(
              create: (context) => AuthBloc(repository: PersonRepository())),
          BlocProvider(
              create: (context) =>
                  VehiclesBloc(repository: VehicleRepository())),
          BlocProvider(
              create: (context) =>
                  ParkingSpacesBloc(repository: ParkingSpaceRepository())),
          BlocProvider(
              create: (context) =>
                  ParkingsBloc(repository: ParkingRepository()))
        ], child: const AdminNavigation()));
  }
}
