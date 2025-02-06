import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_shared/parking_shared.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
}

class AuthState {
  final AuthStatus status;
  Person? person;
  AuthState({required this.status, this.person});
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState(status: AuthStatus.unauthenticated));

  login(Person owner) async {
    emit(AuthState(status: AuthStatus.authenticating));
    try {
      emit(AuthState(status: AuthStatus.authenticated, person: owner));
    } catch (e) {
      emit(AuthState(status: AuthStatus.unauthenticated));
    }
  }

  void start() async {
    await for (final authUser in userStream) {
      if (authUser == null) {
        emit(AuthState(status: AuthStatus.unauthenticated));
      } else {
        emit(AuthState(status: AuthStatus.authenticated, person: authUser));
      }
    }
  }

  void logout() {
    emit(AuthState(status: AuthStatus.unauthenticated));
  }
}
