part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoaded extends AuthState {
  final List<Person> users;

  final Person? pending;

  AuthLoaded({required this.users, this.pending});

  @override
  List<Object?> get props => [users, pending];
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
