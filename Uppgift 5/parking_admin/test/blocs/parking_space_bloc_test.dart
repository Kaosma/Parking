import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_shared/parking_shared.dart';

void main() {
  group('ParkingSpacesBloc', () {
    late MockParkingSpaceRepository parkingSpaceRepository;
    ParkingSpace testParkingSpace = ParkingSpace('Test address', 10);
    ParkingSpace secondTestParkingSpace = ParkingSpace('Test address2', 20);

    setUp(() {
      parkingSpaceRepository = MockParkingSpaceRepository();
    });

    setUpAll(() {
      registerFallbackValue(testParkingSpace);
    });

    group("create parking space", () {
      blocTest<ParkingSpacesBloc, ParkingSpacesState>(
          "create parking space test",
          setUp: () {
            when(() => parkingSpaceRepository.add(any()))
                .thenAnswer((_) async => testParkingSpace);
            when(() => parkingSpaceRepository.getAll())
                .thenAnswer((_) async => [testParkingSpace]);
          },
          build: () => ParkingSpacesBloc(repository: parkingSpaceRepository),
          seed: () => ParkingSpacesLoaded(parkingSpaces: []),
          act: (bloc) =>
              bloc.add(CreateParkingSpace(parkingSpace: testParkingSpace)),
          expect: () => [
                ParkingSpacesLoaded(
                    parkingSpaces: [testParkingSpace],
                    pending: testParkingSpace),
                ParkingSpacesLoaded(
                    parkingSpaces: [testParkingSpace], pending: null)
              ],
          verify: (_) {
            verify(() => parkingSpaceRepository.add(testParkingSpace))
                .called(1);
          });

      blocTest<ParkingSpacesBloc, ParkingSpacesState>(
          "create parking space test error",
          setUp: () {
            when(() => parkingSpaceRepository.add(any()))
                .thenThrow(Exception("Fail to create parking space"));
          },
          build: () => ParkingSpacesBloc(repository: parkingSpaceRepository),
          seed: () => ParkingSpacesLoaded(parkingSpaces: []),
          act: (bloc) =>
              bloc.add(CreateParkingSpace(parkingSpace: testParkingSpace)),
          expect: () => [
                ParkingSpacesLoaded(
                    parkingSpaces: [testParkingSpace],
                    pending: testParkingSpace),
                ParkingSpacesError(
                    message:
                        Exception("Fail to create parking space").toString())
              ],
          verify: (_) {
            verify(() => parkingSpaceRepository.add(testParkingSpace))
                .called(1);
          });
    });

    group("read parking spaces", () {
      blocTest<ParkingSpacesBloc, ParkingSpacesState>(
          "read parkingSpaces succeess",
          setUp: () {
            when(() => parkingSpaceRepository.getAll()).thenAnswer(
                (_) async => [testParkingSpace, secondTestParkingSpace]);
          },
          build: () => ParkingSpacesBloc(repository: parkingSpaceRepository),
          seed: () => ParkingSpacesInitial(),
          act: (bloc) => bloc.add(LoadParkingSpaces()),
          expect: () => [
                ParkingSpacesLoading(),
                ParkingSpacesLoaded(
                    parkingSpaces: [testParkingSpace, secondTestParkingSpace]),
              ],
          verify: (_) {
            verify(() => parkingSpaceRepository.getAll()).called(1);
          });
      blocTest<ParkingSpacesBloc, ParkingSpacesState>(
          "read parkingSpaces failure",
          setUp: () {
            when(() => parkingSpaceRepository.getAll())
                .thenThrow(Exception("failed to get parking spaces"));
          },
          build: () => ParkingSpacesBloc(repository: parkingSpaceRepository),
          seed: () => ParkingSpacesLoaded(parkingSpaces: []),
          act: (bloc) => bloc.add(LoadParkingSpaces()),
          expect: () => [
                ParkingSpacesLoading(),
                ParkingSpacesError(
                    message:
                        Exception("failed to get parking spaces").toString())
              ],
          verify: (_) {
            verify(() => parkingSpaceRepository.getAll()).called(1);
          });
    });

    group("update parking space", () {
      int price = 50;
      secondTestParkingSpace.price = price;
      blocTest<ParkingSpacesBloc, ParkingSpacesState>(
          "update parking space succeess",
          setUp: () {
            when(() => parkingSpaceRepository.update(any()))
                .thenAnswer((_) async => secondTestParkingSpace);
            when(() => parkingSpaceRepository.getAll()).thenAnswer(
                (_) async => [testParkingSpace, secondTestParkingSpace]);
          },
          build: () => ParkingSpacesBloc(repository: parkingSpaceRepository),
          seed: () => ParkingSpacesLoaded(
              parkingSpaces: [testParkingSpace, secondTestParkingSpace]),
          act: (bloc) => bloc
              .add(UpdateParkingSpace(parkingSpace: secondTestParkingSpace)),
          expect: () => [
                ParkingSpacesLoaded(
                    parkingSpaces: [testParkingSpace, secondTestParkingSpace],
                    pending: secondTestParkingSpace),
                ParkingSpacesLoaded(
                    parkingSpaces: [testParkingSpace, secondTestParkingSpace],
                    pending: null),
              ],
          verify: (_) {
            verify(() => parkingSpaceRepository.update(secondTestParkingSpace))
                .called(1);
          });
      blocTest<ParkingSpacesBloc, ParkingSpacesState>(
          "update parking space failure",
          setUp: () {
            when(() => parkingSpaceRepository.update(secondTestParkingSpace))
                .thenThrow(Exception("failed to update parking space"));
          },
          build: () => ParkingSpacesBloc(repository: parkingSpaceRepository),
          seed: () => ParkingSpacesLoaded(
              parkingSpaces: [testParkingSpace, secondTestParkingSpace]),
          act: (bloc) => bloc
              .add(UpdateParkingSpace(parkingSpace: secondTestParkingSpace)),
          expect: () => [
                ParkingSpacesLoaded(
                    parkingSpaces: [testParkingSpace, secondTestParkingSpace],
                    pending: secondTestParkingSpace),
                ParkingSpacesError(
                    message:
                        Exception("failed to update parking space").toString())
              ],
          verify: (_) {
            verify(() => parkingSpaceRepository.update(secondTestParkingSpace))
                .called(1);
          });
    });

    group("delete parking space", () {
      blocTest<ParkingSpacesBloc, ParkingSpacesState>(
          "delete parking space succeess",
          setUp: () {
            when(() => parkingSpaceRepository.delete(any()))
                .thenAnswer((_) async => secondTestParkingSpace);
            when(() => parkingSpaceRepository.getAll())
                .thenAnswer((_) async => [testParkingSpace]);
          },
          build: () => ParkingSpacesBloc(repository: parkingSpaceRepository),
          seed: () => ParkingSpacesLoaded(
              parkingSpaces: [testParkingSpace, secondTestParkingSpace]),
          act: (bloc) => bloc
              .add(DeleteParkingSpace(parkingSpace: secondTestParkingSpace)),
          expect: () => [
                ParkingSpacesLoaded(
                    parkingSpaces: [testParkingSpace, secondTestParkingSpace],
                    pending: secondTestParkingSpace),
                ParkingSpacesLoaded(
                    parkingSpaces: [testParkingSpace], pending: null),
              ],
          verify: (_) {
            verify(() => parkingSpaceRepository.delete(secondTestParkingSpace))
                .called(1);
          });
      blocTest<ParkingSpacesBloc, ParkingSpacesState>(
          "delete parking space failure",
          setUp: () {
            when(() => parkingSpaceRepository.delete(secondTestParkingSpace))
                .thenThrow(Exception("failed to delete parking space"));
          },
          build: () => ParkingSpacesBloc(repository: parkingSpaceRepository),
          seed: () => ParkingSpacesLoaded(
              parkingSpaces: [testParkingSpace, secondTestParkingSpace]),
          act: (bloc) => bloc
              .add(DeleteParkingSpace(parkingSpace: secondTestParkingSpace)),
          expect: () => [
                ParkingSpacesLoaded(
                    parkingSpaces: [testParkingSpace, secondTestParkingSpace],
                    pending: secondTestParkingSpace),
                ParkingSpacesError(
                    message:
                        Exception("failed to delete parking space").toString())
              ],
          verify: (_) {
            verify(() => parkingSpaceRepository.delete(secondTestParkingSpace))
                .called(1);
          });
    });
  });
}
