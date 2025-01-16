import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_shared/parking_shared.dart';
import 'package:parking_shared/src/blocs/vehicle/vehicles_bloc.dart';

import '../mocks/mock_repositories.dart';

void main() {
  group('VehiclesBloc', () {
    late MockVehicleRepository vehicleRepository;

    setUp(() {
      vehicleRepository = MockVehicleRepository();
    });

    setUpAll(() {
      registerFallbackValue(
          Vehicle('ABC111', 'Typetest', Person('Nametest', 123)));
    });

    group("create vehicle", () {
      Vehicle newVehicle =
          Vehicle('ABC111', 'Typetest', Person('Nametest', 123));

      blocTest<VehiclesBloc, VehiclesState>("create vehicle test",
          setUp: () {
            when(() => vehicleRepository.add(any()))
                .thenAnswer((_) async => newVehicle);
            when(() => vehicleRepository.getAll())
                .thenAnswer((_) async => [newVehicle]);
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () => VehiclesLoaded(vehicles: []),
          act: (bloc) => bloc.add(CreateVehicle(vehicle: newVehicle)),
          expect: () => [
                VehiclesLoaded(vehicles: [newVehicle], pending: newVehicle),
                VehiclesLoaded(vehicles: [newVehicle], pending: null)
              ],
          verify: (_) {
            verify(() => vehicleRepository.add(newVehicle)).called(1);
          });

      blocTest<VehiclesBloc, VehiclesState>("create vehicle test error",
          setUp: () {
            when(() => vehicleRepository.add(any()))
                .thenThrow(Exception("Fail to create vehicle"));
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () => VehiclesLoaded(vehicles: []),
          act: (bloc) => bloc.add(CreateVehicle(vehicle: newVehicle)),
          expect: () => [
                VehiclesLoaded(vehicles: [newVehicle], pending: newVehicle),
                VehiclesError(
                    message: Exception("Fail to create vehicle").toString())
              ],
          verify: (_) {
            verify(() => vehicleRepository.add(newVehicle)).called(1);
          });
    });

    group("read vehicles", () {
      Vehicle vehicle1 = Vehicle('ABC111', 'typeTest', Person('nameTest', 123));
      Vehicle vehicle2 =
          Vehicle('ABC222', 'typeTest2', Person('nameTest2', 123));
      blocTest<VehiclesBloc, VehiclesState>("read vehicles succeess",
          setUp: () {
            when(() => vehicleRepository.getAll())
                .thenAnswer((_) async => [vehicle1, vehicle2]);
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () => VehiclesInitial(),
          act: (bloc) => bloc.add(LoadVehicles()),
          expect: () => [
                VehiclesLoading(),
                VehiclesLoaded(vehicles: [vehicle1, vehicle2]),
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
      Vehicle vehicle1 = Vehicle('ABC111', 'typeTest', Person('nameTest', 111));
      Vehicle vehicle2 = Vehicle('ABC112', 'typeTest', Person('nameTest', 222));
      String registrationNumber = 'ABB111';
      vehicle2.registrationNumber = registrationNumber;
      blocTest<VehiclesBloc, VehiclesState>("update vehicle succeess",
          setUp: () {
            when(() => vehicleRepository.update(any()))
                .thenAnswer((_) async => vehicle2);
            when(() => vehicleRepository.getAll())
                .thenAnswer((_) async => [vehicle1, vehicle2]);
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () => VehiclesLoaded(vehicles: [vehicle1, vehicle2]),
          act: (bloc) => bloc.add(UpdateVehicle(vehicle: vehicle2)),
          expect: () => [
                VehiclesLoaded(
                    vehicles: [vehicle1, vehicle2], pending: vehicle2),
                VehiclesLoaded(vehicles: [vehicle1, vehicle2], pending: null),
              ],
          verify: (_) {
            verify(() => vehicleRepository.update(vehicle2)).called(1);
          });
      blocTest<VehiclesBloc, VehiclesState>("update vehicle failure",
          setUp: () {
            when(() => vehicleRepository.update(vehicle2))
                .thenThrow(Exception("failed to update vehicle"));
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () => VehiclesLoaded(vehicles: [vehicle1, vehicle2]),
          act: (bloc) => bloc.add(UpdateVehicle(vehicle: vehicle2)),
          expect: () => [
                VehiclesLoaded(
                    vehicles: [vehicle1, vehicle2], pending: vehicle2),
                VehiclesError(
                    message: Exception("failed to update vehicle").toString())
              ],
          verify: (_) {
            verify(() => vehicleRepository.update(vehicle2)).called(1);
          });
    });

    group("delete vehicle", () {
      Vehicle vehicle1 = Vehicle('ABC111', 'typeTest', Person('nameTest', 111));
      Vehicle vehicle2 = Vehicle('ABC112', 'typeTest', Person('nameTest', 222));

      blocTest<VehiclesBloc, VehiclesState>("delete vehicle succeess",
          setUp: () {
            when(() => vehicleRepository.delete(any()))
                .thenAnswer((_) async => vehicle2);
            when(() => vehicleRepository.getAll())
                .thenAnswer((_) async => [vehicle1]);
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () => VehiclesLoaded(vehicles: [vehicle1, vehicle2]),
          act: (bloc) => bloc.add(DeleteVehicle(vehicle: vehicle2)),
          expect: () => [
                VehiclesLoaded(
                    vehicles: [vehicle1, vehicle2], pending: vehicle2),
                VehiclesLoaded(vehicles: [vehicle1], pending: null),
              ],
          verify: (_) {
            verify(() => vehicleRepository.delete(vehicle2)).called(1);
          });
      blocTest<VehiclesBloc, VehiclesState>("delete vehicle failure",
          setUp: () {
            when(() => vehicleRepository.delete(vehicle2))
                .thenThrow(Exception("failed to delete vehicle"));
          },
          build: () => VehiclesBloc(repository: vehicleRepository),
          seed: () => VehiclesLoaded(vehicles: [vehicle1, vehicle2]),
          act: (bloc) => bloc.add(DeleteVehicle(vehicle: vehicle2)),
          expect: () => [
                VehiclesLoaded(
                    vehicles: [vehicle1, vehicle2], pending: vehicle2),
                VehiclesError(
                    message: Exception("failed to delete vehicle").toString())
              ],
          verify: (_) {
            verify(() => vehicleRepository.delete(vehicle2)).called(1);
          });
    });
  });
}
