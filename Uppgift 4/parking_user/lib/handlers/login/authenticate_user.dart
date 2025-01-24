import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_shared/parking_shared.dart';
import 'package:parking_user/handlers/login/auth_cubit.dart';
import 'package:provider/provider.dart';
import '../../navigation/navigation.dart';

void authenticateUser(BuildContext context, String userId) async {
  final owner = await getOwnerHandler(userId);
  if (owner != null) {
    context.read<AuthCubit>().login();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Provider<Person>.value(
              value: owner,
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
              ], child: const UserNavigation()))),
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
