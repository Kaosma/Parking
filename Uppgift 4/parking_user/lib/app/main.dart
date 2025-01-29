import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:parking_shared/parking_shared.dart';
import 'package:parking_user/handlers/login/auth_cubit.dart';
import 'package:parking_user/navigation/navigation.dart';
import 'package:parking_user/navigation/pages/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(BlocProvider(
      create: (context) => AuthCubit(), child: const ParkingUserApp()));
}

class ParkingUserApp extends StatelessWidget {
  const ParkingUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final isLoggedIn = authState.status == AuthStatus.authenticated;
    final owner = authState.person;

    return MaterialApp(
      title: 'Parkering Användare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn
          ? Provider<Person>.value(
              value: owner!,
              child: MultiBlocProvider(providers: [
                BlocProvider(
                    create: (context) =>
                        AuthBloc(repository: PersonRepository())),
                BlocProvider(
                    create: (context) =>
                        VehiclesBloc(repository: VehicleRepository())),
                BlocProvider(
                    create: (context) => ParkingSpacesBloc(
                        repository: ParkingSpaceRepository())),
                BlocProvider(
                    create: (context) =>
                        ParkingsBloc(repository: ParkingRepository()))
              ], child: const UserNavigation()),
            )
          : const LoginPage(),
    );
  }
}
