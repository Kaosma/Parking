import 'dart:io';

import 'classes.dart';

String inputHandler(String _input) {
  print('');
  print('$_input: ');
  return stdin.readLineSync() ?? '';
}

RegExp registrationNumberExpressionValid = RegExp(r'^[a-zA-Z]{3}\d{3}$');

void searchForVehiclesByOwner(
    PersonRepository personRepository, VehicleRepository vehicleRepository) {
  String personalNumberAsString = inputHandler('Sök på en ägares personnummer');
  int? ownerPersonalNumber = int.tryParse(personalNumberAsString);

  if (ownerPersonalNumber == null ||
      !personRepository.getItems
          .any((person) => person.personalNumber == ownerPersonalNumber))
    print('Ingen ägare med det personnumret existerar');
  else if (vehicleRepository.getItems
      .any((vehicle) => vehicle.owner.personalNumber == ownerPersonalNumber))
    print(vehicleRepository.getItems
        .where((vehicle) => vehicle.owner.personalNumber == ownerPersonalNumber)
        .toString());
  else
    print('Inga fordon funna för personnummer: $personalNumberAsString');
}

void searchForParkingsByVehicle(
    VehicleRepository vehicleRepository, ParkingRepository parkingRepository) {
  String registrationNumber =
      inputHandler('Sök på ett fordons registreringsnummer');

  if (parkingRepository.getItems.any(
      (parking) => parking.vehicle.registrationNumber == registrationNumber)) {
    String parkings = parkingRepository.getItems
        .where((parking) =>
            parking.vehicle.registrationNumber == registrationNumber)
        .toString();
    print('''Parkeringar för fordon $registrationNumber:
    $parkings''');
  } else
    print('Inga parkeringar existerar på fordonet $registrationNumber');
}
