part of 'parkings_bloc.dart';

sealed class ParkingEvent {}

class LoadParkings extends ParkingEvent {}

class ReloadParkings extends ParkingEvent {}

class UpdateParking extends ParkingEvent {
  final Parking parking;

  UpdateParking({required this.parking});
}

class CreateParking extends ParkingEvent {
  final Parking parking;

  CreateParking({required this.parking});
}

class DeleteParking extends ParkingEvent {
  final Parking parking;

  DeleteParking({required this.parking});
}
