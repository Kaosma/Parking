import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_shared/parking_shared.dart';

void main() {
  group('AuthBloc', () {
    late MockPersonRepository personRepository;
    Person testUser = Person('Nametest', 111);
    Person secondTestUser = Person('nameTest2', 222);

    setUp(() {
      personRepository = MockPersonRepository();
    });

    setUpAll(() {
      registerFallbackValue(testUser);
    });

    group("create user", () {
      blocTest<AuthBloc, AuthState>("create user test",
          setUp: () {
            when(() => personRepository.add(any()))
                .thenAnswer((_) async => testUser);
            when(() => personRepository.getAll())
                .thenAnswer((_) async => [testUser]);
          },
          build: () => AuthBloc(repository: personRepository),
          seed: () => AuthLoaded(users: []),
          act: (bloc) => bloc.add(CreatePerson(user: testUser)),
          expect: () => [
                AuthLoaded(users: [testUser], pending: testUser),
                AuthLoaded(users: [testUser], pending: null)
              ],
          verify: (_) {
            verify(() => personRepository.add(testUser)).called(1);
          });

      blocTest<AuthBloc, AuthState>("create user test error",
          setUp: () {
            when(() => personRepository.add(any()))
                .thenThrow(Exception("Fail to create user"));
          },
          build: () => AuthBloc(repository: personRepository),
          seed: () => AuthLoaded(users: []),
          act: (bloc) => bloc.add(CreatePerson(user: testUser)),
          expect: () => [
                AuthLoaded(users: [testUser], pending: testUser),
                AuthError(message: Exception("Fail to create user").toString())
              ],
          verify: (_) {
            verify(() => personRepository.add(testUser)).called(1);
          });
    });

    group("read users", () {
      blocTest<AuthBloc, AuthState>("read users succeess",
          setUp: () {
            when(() => personRepository.getAll())
                .thenAnswer((_) async => [testUser, secondTestUser]);
          },
          build: () => AuthBloc(repository: personRepository),
          seed: () => AuthInitial(),
          act: (bloc) => bloc.add(LoadPersons()),
          expect: () => [
                AuthLoading(),
                AuthLoaded(users: [testUser, secondTestUser]),
              ],
          verify: (_) {
            verify(() => personRepository.getAll()).called(1);
          });
      blocTest<AuthBloc, AuthState>("read users failure",
          setUp: () {
            when(() => personRepository.getAll())
                .thenThrow(Exception("failed to get users"));
          },
          build: () => AuthBloc(repository: personRepository),
          seed: () => AuthLoaded(users: []),
          act: (bloc) => bloc.add(LoadPersons()),
          expect: () => [
                AuthLoading(),
                AuthError(message: Exception("failed to get users").toString())
              ],
          verify: (_) {
            verify(() => personRepository.getAll()).called(1);
          });
    });

    group("update user", () {
      int personalNumber = 333;
      secondTestUser.personalNumber = personalNumber;
      blocTest<AuthBloc, AuthState>("update user succeess",
          setUp: () {
            when(() => personRepository.update(any()))
                .thenAnswer((_) async => secondTestUser);
            when(() => personRepository.getAll())
                .thenAnswer((_) async => [testUser, secondTestUser]);
          },
          build: () => AuthBloc(repository: personRepository),
          seed: () => AuthLoaded(users: [testUser, secondTestUser]),
          act: (bloc) => bloc.add(UpdatePerson(user: secondTestUser)),
          expect: () => [
                AuthLoaded(
                    users: [testUser, secondTestUser], pending: secondTestUser),
                AuthLoaded(users: [testUser, secondTestUser], pending: null),
              ],
          verify: (_) {
            verify(() => personRepository.update(secondTestUser)).called(1);
          });
      blocTest<AuthBloc, AuthState>("update user failure",
          setUp: () {
            when(() => personRepository.update(secondTestUser))
                .thenThrow(Exception("failed to update user"));
          },
          build: () => AuthBloc(repository: personRepository),
          seed: () => AuthLoaded(users: [testUser, secondTestUser]),
          act: (bloc) => bloc.add(UpdatePerson(user: secondTestUser)),
          expect: () => [
                AuthLoaded(
                    users: [testUser, secondTestUser], pending: secondTestUser),
                AuthError(
                    message: Exception("failed to update user").toString())
              ],
          verify: (_) {
            verify(() => personRepository.update(secondTestUser)).called(1);
          });
    });

    group("delete user", () {
      blocTest<AuthBloc, AuthState>("delete user succeess",
          setUp: () {
            when(() => personRepository.delete(any()))
                .thenAnswer((_) async => secondTestUser);
            when(() => personRepository.getAll())
                .thenAnswer((_) async => [testUser]);
          },
          build: () => AuthBloc(repository: personRepository),
          seed: () => AuthLoaded(users: [testUser, secondTestUser]),
          act: (bloc) => bloc.add(DeletePerson(user: secondTestUser)),
          expect: () => [
                AuthLoaded(
                    users: [testUser, secondTestUser], pending: secondTestUser),
                AuthLoaded(users: [testUser], pending: null),
              ],
          verify: (_) {
            verify(() => personRepository.delete(secondTestUser)).called(1);
          });
      blocTest<AuthBloc, AuthState>("delete user failure",
          setUp: () {
            when(() => personRepository.delete(secondTestUser))
                .thenThrow(Exception("failed to delete user"));
          },
          build: () => AuthBloc(repository: personRepository),
          seed: () => AuthLoaded(users: [testUser, secondTestUser]),
          act: (bloc) => bloc.add(DeletePerson(user: secondTestUser)),
          expect: () => [
                AuthLoaded(
                    users: [testUser, secondTestUser], pending: secondTestUser),
                AuthError(
                    message: Exception("failed to delete user").toString())
              ],
          verify: (_) {
            verify(() => personRepository.delete(secondTestUser)).called(1);
          });
    });
  });
}
