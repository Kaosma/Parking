import 'package:hydrated_bloc/hydrated_bloc.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
}

class AuthCubit extends HydratedCubit<AuthStatus> {
  AuthCubit() : super(AuthStatus.unauthenticated);

  login() async {
    emit(AuthStatus.authenticating);
    try {
      emit(AuthStatus.authenticated);
    } catch (e) {
      emit(AuthStatus.unauthenticated);
    }
  }

  void logout() {
    emit(AuthStatus.unauthenticated);
  }

  @override
  AuthStatus? fromJson(Map<String, dynamic> json) {
    return switch (json["authenticated"]) {
      true => AuthStatus.authenticated,
      _ => AuthStatus.unauthenticated,
    };
  }

  @override
  Map<String, dynamic>? toJson(AuthStatus state) {
    return {
      "authenticated": switch (state) {
        AuthStatus.unauthenticated || AuthStatus.authenticating => false,
        AuthStatus.authenticated => true,
      }
    };
  }
}
