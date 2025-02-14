import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:parking_shared/parking_shared.dart';
import 'package:parking_user/blocs/notification/notifications_bloc.dart';
import 'package:parking_user/handlers/login/auth_cubit.dart';
import 'package:parking_user/navigation/navigation.dart';
import 'package:parking_user/navigation/pages/login_page.dart';
import 'package:parking_user/repositories/NotificationsRepository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

late NotificationsRepository notificationsRepository;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  notificationsRepository = await NotificationsRepository.initialize();

  runApp(BlocProvider(
      create: (context) => AuthCubit()..start(),
      child: const ParkingUserApp()));
}

class ParkingUserApp extends StatelessWidget {
  const ParkingUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final isLoggedIn = authState.status == AuthStatus.authenticated;
    final owner = authState.person;

    return SafeArea(
      child: MaterialApp(
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
                          ParkingsBloc(repository: ParkingRepository())),
                  BlocProvider<NotificationBloc>(
                      create: (context) =>
                          NotificationBloc(notificationsRepository)),
                ], child: const UserNavigation()),
              )
            : const LoginPage(),
      ),
    );
  }
}
