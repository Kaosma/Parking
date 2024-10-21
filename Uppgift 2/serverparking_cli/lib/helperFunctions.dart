import 'dart:io';

import 'classes.dart';

String inputHandler(String _input) {
  print('');
  print('$_input: ');
  return stdin.readLineSync() ?? '';
}

RegExp registrationNumberExpressionValid = RegExp(r'^[a-zA-Z]{3}\d{3}$');

Future<void> searchForVehiclesByOwner(PersonRepository personRepository,
    VehicleRepository vehicleRepository) async {
  final persons = await personRepository.getItems;
  final vehicles = await vehicleRepository.getItems;
  String personalNumberAsString = inputHandler('Sök på en ägares personnummer');
  int? ownerPersonalNumber = int.tryParse(personalNumberAsString);
  if (ownerPersonalNumber == null ||
      !persons.any((person) => person.personalNumber == ownerPersonalNumber))
    print('Ingen ägare med det personnumret existerar');
  else if (vehicles
      .any((vehicle) => vehicle.owner.personalNumber == ownerPersonalNumber))
    print(vehicles
        .where((vehicle) => vehicle.owner.personalNumber == ownerPersonalNumber)
        .toString());
  else
    print('Inga fordon funna för personnummer: $personalNumberAsString');
}

Future<void> searchForParkingsByVehicle(VehicleRepository vehicleRepository,
    ParkingRepository parkingRepository) async {
  final repositoryParkings = await parkingRepository.getItems;
  String registrationNumber =
      inputHandler('Sök på ett fordons registreringsnummer');
  if (repositoryParkings.any(
      (parking) => parking.vehicle.registrationNumber == registrationNumber)) {
    String parkings = repositoryParkings
        .where((parking) =>
            parking.vehicle.registrationNumber == registrationNumber)
        .toString();
    print('''Parkeringar för fordon $registrationNumber:
    $parkings''');
  } else
    print('Inga parkeringar existerar på fordonet $registrationNumber');
}
