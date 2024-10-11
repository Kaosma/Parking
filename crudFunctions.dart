import 'classes.dart';
import 'dart:io';

// CREATE
void createPersonHandler(PersonRepository repository) {
  print('Fyll i namn');
  String nameInput = stdin.readLineSync() ?? '';

  while (true) {
    print('Fyll i personnummer');
    String? input = stdin.readLineSync();

    int? personalNumber = int.tryParse(input ?? '');

    if (personalNumber != null) {
      repository.addItem(Person(nameInput, personalNumber));
      break;
    }
    print('Invalid input. Try again.');
  }
}

void createVehicleHandler(
    VehicleRepository _vehicleRepository, PersonRepository _personRepository) {
  // TODO: Error handling
  print('Fyll i fordonets registreringsnummer');
  String registrationInput = stdin.readLineSync() ?? '';

  print('Fyll i bilmärke');
  String typeInput = stdin.readLineSync() ?? '';

  while (true) {
    print('Fyll i en ägares personnummer');
    String? input = stdin.readLineSync();

    // Try to parse the input as an integer
    int? personalNumber = int.tryParse(input ?? '');

    // If parsing succeeds, return the integer
    if (personalNumber != null &&
        _personRepository.getItems
            .any((element) => element.personalNumber == personalNumber)) {
      Person owner = _personRepository.getItems
          .firstWhere((person) => person.personalNumber == personalNumber);
      _vehicleRepository.addItem(Vehicle(registrationInput, typeInput, owner));
      break;
    }

    // Otherwise, prompt the user to enter a valid integer
    print('Invalid input. Try again.');
  }
}

void createParkingSpaceHandler(ParkingSpaceRepository repository) {
  print('Fyll i adress');
  String addressInput = stdin.readLineSync() ?? '';

  while (true) {
    print('Fyll i pris per timme (kr)');
    String? input = stdin.readLineSync();

    // Try to parse the input as an integer
    int? price = int.tryParse(input ?? '');

    // If parsing succeeds, return the integer
    if (price != null) {
      repository.addItem(ParkingSpace(addressInput, price));
      break;
    }

    // Otherwise, prompt the user to enter a valid integer
    print('Invalid input. Try again.');
  }
}

void createParkingHandler(
    ParkingRepository _parkingRepository,
    VehicleRepository _vehicleRepository,
    ParkingSpaceRepository _parkingSpaceRepository) {
  String registrationNumber;
  String address;
  int startTime;
  int endTime;
  while (true) {
    // TODO: Error handling
    print('Fyll i fordonets registreringsnummer');
    String registrationInput = stdin.readLineSync() ?? '';

    if (_vehicleRepository.getItems
        .any((element) => element.registrationNumber == registrationInput)) {
      registrationNumber = registrationInput;
      break;
    }

    print('Invalid input. Try again.');
  }

  while (true) {
    print('Fyll i parkeringsplatsens adress');
    String addressInput = stdin.readLineSync() ?? '';

    if (_parkingSpaceRepository.getItems
        .any((element) => element.address == addressInput)) {
      address = addressInput;
      break;
    }

    print('Invalid input. Try again.');
  }

  while (true) {
    print('Fyll i parkeringens starttid');
    String? input = stdin.readLineSync();

    int? startTimeInput = int.tryParse(input ?? '');

    if (startTimeInput != null) {
      startTime = startTimeInput;
      break;
    }
    print('Invalid input. Try again.');
  }

  while (true) {
    print('Fyll i parkeringens sluttid');
    String? input = stdin.readLineSync();

    int? endTimeInput = int.tryParse(input ?? '');

    if (endTimeInput != null) {
      endTime = endTimeInput;
      break;
    }
    print('Invalid input. Try again.');
  }
  Vehicle vehicle = _vehicleRepository.getItems.firstWhere(
      (vehicle) => vehicle.registrationNumber == registrationNumber);
  ParkingSpace parkingSpace = _parkingSpaceRepository.getItems
      .firstWhere((parkingSpace) => parkingSpace.address == address);
  _parkingRepository
      .addItem(Parking(vehicle, parkingSpace, startTime, endTime));
}

// READ
void getAllItemsHandler(Repository repository) {
  print(repository.getItems.map((item) => item.toString()).join('\n'));
}

// UPDATE

// DELETE
void deletePersonHandler(PersonRepository repository) {
  while (true) {
    print('Fyll i personnummer på den person du vill ta bort');
    String? input = stdin.readLineSync();

    int? personalNumber = int.tryParse(input ?? '');

    if (personalNumber != null &&
        repository.getItems
            .any((person) => person.personalNumber == personalNumber)) {
      repository.deleteItem(repository.getItems
          .firstWhere((person) => person.personalNumber == personalNumber));
      break;
    }
    print('Invalid input. Try again.');
  }
}

void deleteVehicleHandler(VehicleRepository repository) {
  while (true) {
    print('Fyll i registreringsnummer på det fordon du vill ta bort');
    String? registrationInput = stdin.readLineSync();

    if (repository.getItems
        .any((vehicle) => vehicle.registrationNumber == registrationInput)) {
      repository.deleteItem(repository.getItems.firstWhere(
          (vehicle) => vehicle.registrationNumber == registrationInput));
      break;
    }
    print('Invalid input. Try again.');
  }
}

void deleteParkingSpaceHandler(ParkingSpaceRepository repository) {
  while (true) {
    print('Fyll i adressen för den parkeringsplats du vill ta bort');
    String? addressInput = stdin.readLineSync();

    if (repository.getItems
        .any((parkingSpace) => parkingSpace.address == addressInput)) {
      repository.deleteItem(repository.getItems
          .firstWhere((parkingSpace) => parkingSpace.address == addressInput));
      break;
    }
    print('Invalid input. Try again.');
  }
}

void deleteParkingHandler(ParkingRepository repository) {
  while (true) {
    print('Fyll i id för den parkering du vill ta bort');
    String? idInput = stdin.readLineSync();

    if (repository.getItems.any((parking) => parking.id == idInput)) {
      repository.deleteItem(
          repository.getItems.firstWhere((parking) => parking.id == idInput));
      break;
    }
    print('Invalid input. Try again.');
  }
}
