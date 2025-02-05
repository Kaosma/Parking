import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/Person.dart';
import '../../repositories/Person.repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final PersonRepository repository;
  late StreamSubscription<List<Person>> _personsSubscription;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      try {
        switch (event) {
          case LoadPersons():
            await onLoadPersons(emit);

          case UpdatePerson(user: final person):
            await onUpdatePerson(person, emit);

          case CreatePerson(user: final person):
            await onCreatePerson(person, emit);

          case DeletePerson(user: final person):
            await onDeletePerson(person, emit);

          case ReloadPersons():
            await onReloadPersons(emit);

          case PersonsUpdated():
            on<PersonsUpdated>((event, emit) {
              emit(AuthLoaded(users: event.persons));
            });
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });
    _personsSubscription = repository.getPersonsStream().listen((persons) {
      add(PersonsUpdated(persons: persons));
    });
  }

  Future<void> onReloadPersons(Emitter<AuthState> emit) async {
    final persons = await repository.getAll();
    emit(AuthLoaded(users: persons));
  }

  Future<void> onDeletePerson(Person person, Emitter<AuthState> emit) async {
    final currentPersons = switch (state) {
      AuthLoaded(users: final persons) => [...persons],
      _ => <Person>[],
    };
    emit(AuthLoaded(users: currentPersons, pending: person));

    await repository.delete(person);
    final persons = await repository.getAll();
    emit(AuthLoaded(users: persons));
  }

  Future<void> onCreatePerson(Person person, Emitter<AuthState> emit) async {
    final currentPersons = switch (state) {
      AuthLoaded(users: final persons) => [...persons],
      _ => <Person>[],
    };
    currentPersons.add(person);
    emit(AuthLoaded(users: currentPersons, pending: person));

    await repository.add(person);
    final persons = await repository.getAll();
    emit(AuthLoaded(users: persons));
  }

  Future<void> onUpdatePerson(Person person, Emitter<AuthState> emit) async {
    final currentPersons = switch (state) {
      AuthLoaded(users: final persons) => [...persons],
      _ => <Person>[],
    };
    var index = currentPersons.indexWhere((e) => person.id == e.id);
    currentPersons.removeAt(index);
    currentPersons.insert(index, person);
    emit(AuthLoaded(users: currentPersons, pending: person));
    await repository.update(person);
    final persons = await repository.getAll();
    emit(AuthLoaded(users: persons));
  }

  Future<void> onLoadPersons(Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final persons = await repository.getAll();
    emit(AuthLoaded(users: persons));
  }

  @override
  Future<void> close() {
    _personsSubscription.cancel();
    return super.close();
  }
}
