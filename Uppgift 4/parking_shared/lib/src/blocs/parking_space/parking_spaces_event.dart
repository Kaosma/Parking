part of 'parking_spaces_bloc.dart';

sealed class ParkingSpaceEvent {}

class LoadParkingSpaces extends ParkingSpaceEvent {}

class ReloadParkingSpaces extends ParkingSpaceEvent {}

class UpdateParkingSpace extends ParkingSpaceEvent {
  final ParkingSpace parkingSpace;

  UpdateParkingSpace({required this.parkingSpace});
}

class CreateParkingSpace extends ParkingSpaceEvent {
  final ParkingSpace parkingSpace;

  CreateParkingSpace({required this.parkingSpace});
}

class DeleteParkingSpace extends ParkingSpaceEvent {
  final ParkingSpace parkingSpace;

  DeleteParkingSpace({required this.parkingSpace});
}
