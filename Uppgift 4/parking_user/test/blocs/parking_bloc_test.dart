import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_shared/parking_shared.dart';

void main() {
  group('ParkingsBloc', () {
    late MockParkingRepository parkingRepository;
    Parking testParking = Parking(
        vehicle: Vehicle('ABC111', 'Typetest', Person('Nametest', 123)),
        parkingSpace: ParkingSpace('Test address', 10),
        startTime: 11111,
        endTime: 22222);
    Parking secondTestParking = Parking(
        vehicle: Vehicle('ABC222', 'typeTest2', Person('nameTest2', 123)),
        parkingSpace: ParkingSpace('Test address2', 20),
        startTime: 33333,
        endTime: 44444);

    setUp(() {
      parkingRepository = MockParkingRepository();
    });

    setUpAll(() {
      registerFallbackValue(testParking);
    });

    group("create parking", () {
      blocTest<ParkingsBloc, ParkingsState>("create parking test",
          setUp: () {
            when(() => parkingRepository.add(any()))
                .thenAnswer((_) async => testParking);
            when(() => parkingRepository.getAll())
                .thenAnswer((_) async => [testParking]);
          },
          build: () => ParkingsBloc(repository: parkingRepository),
          seed: () => ParkingsLoaded(parkings: []),
          act: (bloc) => bloc.add(CreateParking(parking: testParking)),
          expect: () => [
                ParkingsLoaded(parkings: [testParking], pending: testParking),
                ParkingsLoaded(parkings: [testParking], pending: null)
              ],
          verify: (_) {
            verify(() => parkingRepository.add(testParking)).called(1);
          });

      blocTest<ParkingsBloc, ParkingsState>("create parking test error",
          setUp: () {
            when(() => parkingRepository.add(any()))
                .thenThrow(Exception("Fail to create parking"));
          },
          build: () => ParkingsBloc(repository: parkingRepository),
          seed: () => ParkingsLoaded(parkings: []),
          act: (bloc) => bloc.add(CreateParking(parking: testParking)),
          expect: () => [
                ParkingsLoaded(parkings: [testParking], pending: testParking),
                ParkingsError(
                    message: Exception("Fail to create parking").toString())
              ],
          verify: (_) {
            verify(() => parkingRepository.add(testParking)).called(1);
          });
    });

    group("read parkings", () {
      blocTest<ParkingsBloc, ParkingsState>("read parkings succeess",
          setUp: () {
            when(() => parkingRepository.getAll())
                .thenAnswer((_) async => [testParking, secondTestParking]);
          },
          build: () => ParkingsBloc(repository: parkingRepository),
          seed: () => ParkingsInitial(),
          act: (bloc) => bloc.add(LoadParkings()),
          expect: () => [
                ParkingsLoading(),
                ParkingsLoaded(parkings: [testParking, secondTestParking]),
              ],
          verify: (_) {
            verify(() => parkingRepository.getAll()).called(1);
          });
      blocTest<ParkingsBloc, ParkingsState>("read parkings failure",
          setUp: () {
            when(() => parkingRepository.getAll())
                .thenThrow(Exception("failed to get parkings"));
          },
          build: () => ParkingsBloc(repository: parkingRepository),
          seed: () => ParkingsLoaded(parkings: []),
          act: (bloc) => bloc.add(LoadParkings()),
          expect: () => [
                ParkingsLoading(),
                ParkingsError(
                    message: Exception("failed to get parkings").toString())
              ],
          verify: (_) {
            verify(() => parkingRepository.getAll()).called(1);
          });
    });

    group("update parking", () {
      int endTime = 55555;
      secondTestParking.endTime = endTime;
      blocTest<ParkingsBloc, ParkingsState>("update parking succeess",
          setUp: () {
            when(() => parkingRepository.update(any()))
                .thenAnswer((_) async => secondTestParking);
            when(() => parkingRepository.getAll())
                .thenAnswer((_) async => [testParking, secondTestParking]);
          },
          build: () => ParkingsBloc(repository: parkingRepository),
          seed: () =>
              ParkingsLoaded(parkings: [testParking, secondTestParking]),
          act: (bloc) => bloc.add(UpdateParking(parking: secondTestParking)),
          expect: () => [
                ParkingsLoaded(
                    parkings: [testParking, secondTestParking],
                    pending: secondTestParking),
                ParkingsLoaded(
                    parkings: [testParking, secondTestParking], pending: null),
              ],
          verify: (_) {
            verify(() => parkingRepository.update(secondTestParking)).called(1);
          });
      blocTest<ParkingsBloc, ParkingsState>("update parking failure",
          setUp: () {
            when(() => parkingRepository.update(secondTestParking))
                .thenThrow(Exception("failed to update parking"));
          },
          build: () => ParkingsBloc(repository: parkingRepository),
          seed: () =>
              ParkingsLoaded(parkings: [testParking, secondTestParking]),
          act: (bloc) => bloc.add(UpdateParking(parking: secondTestParking)),
          expect: () => [
                ParkingsLoaded(
                    parkings: [testParking, secondTestParking],
                    pending: secondTestParking),
                ParkingsError(
                    message: Exception("failed to update parking").toString())
              ],
          verify: (_) {
            verify(() => parkingRepository.update(secondTestParking)).called(1);
          });
    });

    group("delete parking", () {
      blocTest<ParkingsBloc, ParkingsState>("delete parking succeess",
          setUp: () {
            when(() => parkingRepository.delete(any()))
                .thenAnswer((_) async => secondTestParking);
            when(() => parkingRepository.getAll())
                .thenAnswer((_) async => [testParking]);
          },
          build: () => ParkingsBloc(repository: parkingRepository),
          seed: () =>
              ParkingsLoaded(parkings: [testParking, secondTestParking]),
          act: (bloc) => bloc.add(DeleteParking(parking: secondTestParking)),
          expect: () => [
                ParkingsLoaded(
                    parkings: [testParking, secondTestParking],
                    pending: secondTestParking),
                ParkingsLoaded(parkings: [testParking], pending: null),
              ],
          verify: (_) {
            verify(() => parkingRepository.delete(secondTestParking)).called(1);
          });
      blocTest<ParkingsBloc, ParkingsState>("delete parking failure",
          setUp: () {
            when(() => parkingRepository.delete(secondTestParking))
                .thenThrow(Exception("failed to delete parking"));
          },
          build: () => ParkingsBloc(repository: parkingRepository),
          seed: () =>
              ParkingsLoaded(parkings: [testParking, secondTestParking]),
          act: (bloc) => bloc.add(DeleteParking(parking: secondTestParking)),
          expect: () => [
                ParkingsLoaded(
                    parkings: [testParking, secondTestParking],
                    pending: secondTestParking),
                ParkingsError(
                    message: Exception("failed to delete parking").toString())
              ],
          verify: (_) {
            verify(() => parkingRepository.delete(secondTestParking)).called(1);
          });
    });
  });
}
