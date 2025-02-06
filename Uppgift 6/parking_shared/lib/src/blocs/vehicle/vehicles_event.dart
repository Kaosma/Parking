part of 'vehicles_bloc.dart';

sealed class VehiclesEvent {}

class LoadVehicles extends VehiclesEvent {}

class ReloadVehicles extends VehiclesEvent {
  final List<Vehicle> vehicles;

  ReloadVehicles({required this.vehicles});
}

class VehiclesUpdated extends VehiclesEvent {
  final List<Vehicle> vehicles;
  VehiclesUpdated({required this.vehicles});
}

class UpdateVehicle extends VehiclesEvent {
  final Vehicle vehicle;

  UpdateVehicle({required this.vehicle});
}

class CreateVehicle extends VehiclesEvent {
  final Vehicle vehicle;

  CreateVehicle({required this.vehicle});
}

class DeleteVehicle extends VehiclesEvent {
  final Vehicle vehicle;

  DeleteVehicle({required this.vehicle});
}
