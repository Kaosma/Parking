import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/Vehicle.dart';
import '../../repositories/Vehicle.repository.dart';

part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  final VehicleRepository repository;
  late StreamSubscription<List<Vehicle>> _vehiclesSubscription;

  VehiclesBloc({required this.repository}) : super(VehiclesInitial()) {
    on<VehiclesEvent>((event, emit) async {
      try {
        switch (event) {
          case LoadVehicles():
            await onLoadVehicles(emit);

          case UpdateVehicle(vehicle: final finalVehicle):
            await onUpdateVehicle(finalVehicle, emit);

          case CreateVehicle(vehicle: final finalVehicle):
            await onCreateVehicle(finalVehicle, emit);

          case DeleteVehicle(vehicle: final finalVehicle):
            await onDeleteVehicle(finalVehicle, emit);

          case ReloadVehicles():
            await onReloadVehicles(emit);

          case VehiclesUpdated():
            on<VehiclesUpdated>((event, emit) {
              emit(VehiclesLoaded(vehicles: event.vehicles));
            });
        }
      } catch (e) {
        emit(VehiclesError(message: e.toString()));
      }
    });
    _vehiclesSubscription = repository.getVehiclesStream().listen((vehicles) {
      add(VehiclesUpdated(vehicles: vehicles));
    });
  }

  Future<void> onReloadVehicles(Emitter<VehiclesState> emit) async {
    final vehiclesFromRepository = await repository.getAll();
    emit(VehiclesLoaded(vehicles: vehiclesFromRepository));
  }

  Future<void> onDeleteVehicle(
      Vehicle vehicle, Emitter<VehiclesState> emit) async {
    final currentVehicles = switch (state) {
      VehiclesLoaded(vehicles: final finalVehicles) => [...finalVehicles],
      _ => <Vehicle>[],
    };
    emit(VehiclesLoaded(vehicles: currentVehicles, pending: vehicle));

    await repository.delete(vehicle);
    final vehiclesFromRepository = await repository.getAll();
    emit(VehiclesLoaded(vehicles: vehiclesFromRepository));
  }

  Future<void> onCreateVehicle(
      Vehicle vehicle, Emitter<VehiclesState> emit) async {
    final currentVehicles = switch (state) {
      VehiclesLoaded(vehicles: final finalVehicles) => [...finalVehicles],
      _ => <Vehicle>[],
    };
    currentVehicles.add(vehicle);
    emit(VehiclesLoaded(vehicles: currentVehicles, pending: vehicle));

    await repository.add(vehicle);
    final vehiclesFromRepository = await repository.getAll();
    emit(VehiclesLoaded(vehicles: vehiclesFromRepository));
  }

  Future<void> onUpdateVehicle(
      Vehicle vehicle, Emitter<VehiclesState> emit) async {
    final currentVehicles = switch (state) {
      VehiclesLoaded(vehicles: final finalVehicles) => [...finalVehicles],
      _ => <Vehicle>[],
    };
    var index = currentVehicles.indexWhere((e) => vehicle.id == e.id);
    currentVehicles.removeAt(index);
    currentVehicles.insert(index, vehicle);
    emit(VehiclesLoaded(vehicles: currentVehicles, pending: vehicle));
    await repository.update(vehicle);
    final vehiclesFromRepository = await repository.getAll();
    emit(VehiclesLoaded(vehicles: vehiclesFromRepository));
  }

  Future<void> onLoadVehicles(Emitter<VehiclesState> emit) async {
    emit(VehiclesLoading());
    final vehiclesFromRepository = await repository.getAll();
    emit(VehiclesLoaded(vehicles: vehiclesFromRepository));
  }

  @override
  Future<void> close() {
    _vehiclesSubscription.cancel();
    return super.close();
  }
}
