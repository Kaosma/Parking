import 'classes.dart';
import 'dart:io';

void createPerson(
    String _name, int _personalNumber, PersonRepository _personRepository) {
  _personRepository.addItem(Person(_name, _personalNumber));
}

void createPersonHandler(PersonRepository repository) {
  print('Fyll i namn');
  String nameInput = stdin.readLineSync() ?? '';

  while (true) {
    print('Fyll i personnummer');
    String? input = stdin.readLineSync();

    // Try to parse the input as an integer
    int? personalNumber = int.tryParse(input ?? '');

    // If parsing succeeds, return the integer
    if (personalNumber != null) {
      createPerson(nameInput, personalNumber, repository);
      break;
    }

    // Otherwise, prompt the user to enter a valid integer
    print('Invalid input. Try again.');
  }
}

void createVehicle(
    String _registrationNumber,
    String _type,
    int _ownerPersonalNumber,
    VehicleRepository _vehicleRepository,
    PersonRepository _personRepository) {
  Person _owner = _personRepository.getItems
      .firstWhere((person) => person.personalNumber == _ownerPersonalNumber);
  _vehicleRepository.addItem(Vehicle(_registrationNumber, _type, _owner));
}

// TODO
void createVehicleHandler(VehicleRepository repository) {}

void createParkingSpace(String _address, int _price, int _ownerPersonalNumber,
    ParkingSpaceRepository _parkingSpaceRepository) {
  _parkingSpaceRepository.addItem(ParkingSpace(_address, _price));
}

// TODO
void createParkingSpaceHandler(ParkingSpaceRepository repository) {}

void createParking(
    String _registrationNumber,
    String _parkingSpaceAddress,
    int _startTime,
    int _endTime,
    VehicleRepository _vehicleRepository,
    ParkingSpaceRepository _parkingSpaceRepository,
    ParkingRepository _parkingRepository) {
  Vehicle _vehicle = _vehicleRepository.getItems.firstWhere(
      (vehicle) => vehicle.registrationNumber == _registrationNumber);
  ParkingSpace _parkingSpace = _parkingSpaceRepository.getItems.firstWhere(
      (parkingSpace) => parkingSpace.address == _parkingSpaceAddress);
  _parkingRepository
      .addItem(Parking(_vehicle, _parkingSpace, _startTime, _endTime));
}

// TODO
void createParkingHandler(ParkingRepository repository) {}

void getAllItemsHandler(Repository repository) {
  print(repository.getItems.map((item) => item.toString()).join('\t'));
}
