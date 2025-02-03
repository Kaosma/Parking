import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_shared/parking_shared.dart';
import 'package:parking_user/handlers/login/auth_cubit.dart';
import 'package:provider/provider.dart';

Future<void> authenticateUser(
    BuildContext context, String email, String password) async {
  final owner = await getOwnerHandler(email, password);
  if (owner != null) {
    context.read<AuthCubit>().login(owner);
  }
}

Future<void> signOutUser(BuildContext context) async {
  await signOutHandler();
}
