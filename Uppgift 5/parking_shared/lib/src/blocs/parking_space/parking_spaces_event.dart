part of 'parking_spaces_bloc.dart';

sealed class ParkingSpacesEvent {}

class LoadParkingSpaces extends ParkingSpacesEvent {}

class ReloadParkingSpaces extends ParkingSpacesEvent {}

class ParkingSpacesUpdated extends ParkingSpacesEvent {
  final List<ParkingSpace> parkingSpaces;
  ParkingSpacesUpdated({required this.parkingSpaces});
}

class UpdateParkingSpace extends ParkingSpacesEvent {
  final ParkingSpace parkingSpace;

  UpdateParkingSpace({required this.parkingSpace});
}

class CreateParkingSpace extends ParkingSpacesEvent {
  final ParkingSpace parkingSpace;

  CreateParkingSpace({required this.parkingSpace});
}

class DeleteParkingSpace extends ParkingSpacesEvent {
  final ParkingSpace parkingSpace;

  DeleteParkingSpace({required this.parkingSpace});
}
