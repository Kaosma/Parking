import 'dart:io';
import 'dart:math';

import '../repositories/parking_repository.dart';
import '../repositories/person_repository.dart';
import '../repositories/vehicle_repository.dart';

var personRepository = PersonRepository();
var vehicleRepository = VehicleRepository();
var parkingRepository = ParkingRepository();

RegExp registrationNumberExpressionValid = RegExp(r'^[a-zA-Z]{3}\d{3}$');

String getOptionHeadline(int option) {
  switch (option) {
    case 1:
      return 'personer';
    case 2:
      return 'fordon';
    case 3:
      return 'parkeringsplatser';
    case 4:
      return 'parkeringar';
    default:
      return '';
  }
}

int getChoice() {
  String? input = stdin.readLineSync();
  int? choice = int.tryParse(input ?? '');
  return choice ?? -1;
}

String inputHandler(String _input) {
  print('');
  print('$_input: ');
  return stdin.readLineSync() ?? '';
}

String generateUuid() {
  final random = Random();

  String fourRandomHexDigits() {
    return random.nextInt(0x10000).toRadixString(16).padLeft(4, '0');
  }

  return '${fourRandomHexDigits()}${fourRandomHexDigits()}-${fourRandomHexDigits()}${fourRandomHexDigits()}';
}

String convertUnixToDateTime(unixTimestamp) {
  return DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000).toString();
}

Future<void> searchForVehiclesByOwner() async {
  final persons = await personRepository.getAll();
  final vehicles = await vehicleRepository.getAll();
  String personalNumberAsString = inputHandler('Sök på en ägares personnummer');
  int? ownerPersonalNumber = int.tryParse(personalNumberAsString);
  if (ownerPersonalNumber == null ||
      !persons.any((person) => person.personalNumber == ownerPersonalNumber)) {
    print('Ingen ägare med det personnumret existerar');
  } else if (vehicles
      .any((vehicle) => vehicle.owner.personalNumber == ownerPersonalNumber)) {
    print(vehicles
        .where((vehicle) => vehicle.owner.personalNumber == ownerPersonalNumber)
        .toString());
  } else {
    print('Inga fordon funna för personnummer: $personalNumberAsString');
  }
}

Future<void> searchForParkingsByVehicle() async {
  final repositoryParkings = await parkingRepository.getAll();
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
  } else {
    print('Inga parkeringar existerar på fordonet $registrationNumber');
  }
}
