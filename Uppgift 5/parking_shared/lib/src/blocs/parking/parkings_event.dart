part of 'parkings_bloc.dart';

sealed class ParkingsEvent {}

class LoadParkings extends ParkingsEvent {}

class ReloadParkings extends ParkingsEvent {}

class UpdateParking extends ParkingsEvent {
  final Parking parking;

  UpdateParking({required this.parking});
}

class CreateParking extends ParkingsEvent {
  final Parking parking;

  CreateParking({required this.parking});
}

class DeleteParking extends ParkingsEvent {
  final Parking parking;

  DeleteParking({required this.parking});
}
