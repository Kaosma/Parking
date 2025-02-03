import 'package:hydrated_bloc/hydrated_bloc.dart';
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

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit() : super(AuthState(status: AuthStatus.unauthenticated));

  login(Person owner) async {
    print('222222');
    emit(AuthState(status: AuthStatus.authenticating));
    try {
      print('333333, $owner');
      emit(AuthState(status: AuthStatus.authenticated, person: owner));
    } catch (e) {
      print('444444');
      emit(AuthState(status: AuthStatus.unauthenticated));
    }
  }

  void logout() {
    emit(AuthState(status: AuthStatus.unauthenticated));
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState(
        status: switch (json["authenticated"]) {
          true => AuthStatus.authenticated,
          _ => AuthStatus.unauthenticated,
        },
        person: Person.fromJSON(json["person"]));
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return {
      "authenticated": switch (state.status) {
        AuthStatus.unauthenticated || AuthStatus.authenticating => false,
        AuthStatus.authenticated => true,
      },
      "person": state.person?.toJSON()
    };
  }
}
