part of 'auth_bloc.dart';

sealed class AuthEvent {}

class LoadPersons extends AuthEvent {}

class ReloadPersons extends AuthEvent {}

class PersonsUpdated extends AuthEvent {
  final List<Person> persons;
  PersonsUpdated({required this.persons});
}

class UpdatePerson extends AuthEvent {
  final Person user;

  UpdatePerson({required this.user});
}

class CreatePerson extends AuthEvent {
  final Person user;

  CreatePerson({required this.user});
}

class DeletePerson extends AuthEvent {
  final Person user;

  DeletePerson({required this.user});
}
