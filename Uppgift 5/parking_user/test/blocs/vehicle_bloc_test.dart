import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_shared/parking_shared.dart';

void main() {
  group('VehiclesBloc', () {
    late MockVehicleRepository vehicleRepository;
    Vehicle testVehicle = Vehicle('ABC111', 'Typetest',
        Person('Nametest', 123, 'test@email.com', 'password1'));
    Vehicle secondTestVehicle = Vehicle('ABC222', 'typeTest2',
        Person('nameTest2', 123, 'test2@email.com', 'password2'));

    setUp(() {
      vehicleRepository = MockVehicleRepository();
    });

    setUpAll(() {
      registerFallbackValue(testVehicle);
    });

    group("create vehicle", () {
      blocTest<VehiclesBloc, VehiclesState>("create vehicle test",
          setUp: () {
            when(() => vehicleRepository.add(any()))
                .thenAnswer((_) async => testVehicle);
            when(() => vehicleRepository.getAll())
                .thenAnswer((_) async => [testVehicle]);
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () => VehiclesLoaded(vehicles: []),
          act: (bloc) => bloc.add(CreateVehicle(vehicle: testVehicle)),
          expect: () => [
                VehiclesLoaded(vehicles: [testVehicle], pending: testVehicle),
                VehiclesLoaded(vehicles: [testVehicle], pending: null)
              ],
          verify: (_) {
            verify(() => vehicleRepository.add(testVehicle)).called(1);
          });

      blocTest<VehiclesBloc, VehiclesState>("create vehicle test error",
          setUp: () {
            when(() => vehicleRepository.add(any()))
                .thenThrow(Exception("Fail to create vehicle"));
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () => VehiclesLoaded(vehicles: []),
          act: (bloc) => bloc.add(CreateVehicle(vehicle: testVehicle)),
          expect: () => [
                VehiclesLoaded(vehicles: [testVehicle], pending: testVehicle),
                VehiclesError(
                    message: Exception("Fail to create vehicle").toString())
              ],
          verify: (_) {
            verify(() => vehicleRepository.add(testVehicle)).called(1);
          });
    });

    group("read vehicles", () {
      blocTest<VehiclesBloc, VehiclesState>("read vehicles succeess",
          setUp: () {
            when(() => vehicleRepository.getAll())
                .thenAnswer((_) async => [testVehicle, secondTestVehicle]);
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () => VehiclesInitial(),
          act: (bloc) => bloc.add(LoadVehicles()),
          expect: () => [
                VehiclesLoading(),
                VehiclesLoaded(vehicles: [testVehicle, secondTestVehicle]),
              ],
          verify: (_) {
            verify(() => vehicleRepository.getAll()).called(1);
          });
      blocTest<VehiclesBloc, VehiclesState>("read vehicles failure",
          setUp: () {
            when(() => vehicleRepository.getAll())
                .thenThrow(Exception("failed to get vehicles"));
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () => VehiclesLoaded(vehicles: []),
          act: (bloc) => bloc.add(LoadVehicles()),
          expect: () => [
                VehiclesLoading(),
                VehiclesError(
                    message: Exception("failed to get vehicles").toString())
              ],
          verify: (_) {
            verify(() => vehicleRepository.getAll()).called(1);
          });
    });

    group("update vehicle", () {
      String registrationNumber = 'ABB111';
      secondTestVehicle.registrationNumber = registrationNumber;
      blocTest<VehiclesBloc, VehiclesState>("update vehicle succeess",
          setUp: () {
            when(() => vehicleRepository.update(any()))
                .thenAnswer((_) async => secondTestVehicle);
            when(() => vehicleRepository.getAll())
                .thenAnswer((_) async => [testVehicle, secondTestVehicle]);
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () =>
              VehiclesLoaded(vehicles: [testVehicle, secondTestVehicle]),
          act: (bloc) => bloc.add(UpdateVehicle(vehicle: secondTestVehicle)),
          expect: () => [
                VehiclesLoaded(
                    vehicles: [testVehicle, secondTestVehicle],
                    pending: secondTestVehicle),
                VehiclesLoaded(
                    vehicles: [testVehicle, secondTestVehicle], pending: null),
              ],
          verify: (_) {
            verify(() => vehicleRepository.update(secondTestVehicle)).called(1);
          });
      blocTest<VehiclesBloc, VehiclesState>("update vehicle failure",
          setUp: () {
            when(() => vehicleRepository.update(secondTestVehicle))
                .thenThrow(Exception("failed to update vehicle"));
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () =>
              VehiclesLoaded(vehicles: [testVehicle, secondTestVehicle]),
          act: (bloc) => bloc.add(UpdateVehicle(vehicle: secondTestVehicle)),
          expect: () => [
                VehiclesLoaded(
                    vehicles: [testVehicle, secondTestVehicle],
                    pending: secondTestVehicle),
                VehiclesError(
                    message: Exception("failed to update vehicle").toString())
              ],
          verify: (_) {
            verify(() => vehicleRepository.update(secondTestVehicle)).called(1);
          });
    });

    group("delete vehicle", () {
      blocTest<VehiclesBloc, VehiclesState>("delete vehicle succeess",
          setUp: () {
            when(() => vehicleRepository.delete(any()))
                .thenAnswer((_) async => secondTestVehicle);
            when(() => vehicleRepository.getAll())
                .thenAnswer((_) async => [testVehicle]);
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () =>
              VehiclesLoaded(vehicles: [testVehicle, secondTestVehicle]),
          act: (bloc) => bloc.add(DeleteVehicle(vehicle: secondTestVehicle)),
          expect: () => [
                VehiclesLoaded(
                    vehicles: [testVehicle, secondTestVehicle],
                    pending: secondTestVehicle),
                VehiclesLoaded(vehicles: [testVehicle], pending: null),
              ],
          verify: (_) {
            verify(() => vehicleRepository.delete(secondTestVehicle)).called(1);
          });
      blocTest<VehiclesBloc, VehiclesState>("delete vehicle failure",
          setUp: () {
            when(() => vehicleRepository.delete(secondTestVehicle))
                .thenThrow(Exception("failed to delete vehicle"));
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () =>
              VehiclesLoaded(vehicles: [testVehicle, secondTestVehicle]),
          act: (bloc) => bloc.add(DeleteVehicle(vehicle: secondTestVehicle)),
          expect: () => [
                VehiclesLoaded(
                    vehicles: [testVehicle, secondTestVehicle],
                    pending: secondTestVehicle),
                VehiclesError(
                    message: Exception("failed to delete vehicle").toString())
              ],
          verify: (_) {
            verify(() => vehicleRepository.delete(secondTestVehicle)).called(1);
          });
    });
  });
}
