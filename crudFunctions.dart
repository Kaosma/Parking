import 'classes.dart';
import 'dart:io';

// CREATE
void createPersonHandler(PersonRepository repository) {
  print('Fyll i namn');
  String nameInput = stdin.readLineSync() ?? '';

  while (true) {
    print('Fyll i personnummer');
    String input = stdin.readLineSync() ?? '';

    int? personalNumber = int.tryParse(input);

    if (personalNumber != null) {
      repository.addItem(Person(nameInput, personalNumber));
      break;
    }
    print('Ogiltigt val. Testa igen.');
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
    String input = stdin.readLineSync() ?? '';

    int? personalNumber = int.tryParse(input);

    if (personalNumber != null &&
        _personRepository.getItems
            .any((element) => element.personalNumber == personalNumber)) {
      Person owner = _personRepository.getItems
          .firstWhere((person) => person.personalNumber == personalNumber);
      _vehicleRepository.addItem(Vehicle(registrationInput, typeInput, owner));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

void createParkingSpaceHandler(ParkingSpaceRepository repository) {
  print('Fyll i adress');
  String addressInput = stdin.readLineSync() ?? '';

  while (true) {
    print('Fyll i pris per timme (kr)');
    String input = stdin.readLineSync() ?? '';

    int? price = int.tryParse(input);

    if (price != null) {
      repository.addItem(ParkingSpace(addressInput, price));
      break;
    }
    print('Ogiltigt val. Testa igen.');
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

    print('Ogiltigt val. Testa igen.');
  }

  while (true) {
    print('Fyll i parkeringsplatsens adress');
    String addressInput = stdin.readLineSync() ?? '';

    if (_parkingSpaceRepository.getItems
        .any((element) => element.address == addressInput)) {
      address = addressInput;
      break;
    }

    print('Ogiltigt val. Testa igen.');
  }

  while (true) {
    print('Fyll i parkeringens starttid');
    String input = stdin.readLineSync() ?? '';

    int? startTimeInput = int.tryParse(input);

    if (startTimeInput != null) {
      startTime = startTimeInput;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }

  while (true) {
    print('Fyll i parkeringens sluttid');
    String input = stdin.readLineSync() ?? '';

    int? endTimeInput = int.tryParse(input);

    if (endTimeInput != null) {
      endTime = endTimeInput;
      break;
    }
    print('Ogiltigt val. Testa igen.');
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
void updatePersonHandler(PersonRepository repository) {
  int personalNumberToUpdate;
  while (true) {
    print('Fyll i personnummer på den person du vill uppdatera: ');
    String input = stdin.readLineSync() ?? '';

    int? personalNumber = int.tryParse(input);

    if (personalNumber != null &&
        repository.getItems
            .any((person) => person.personalNumber == personalNumber)) {
      personalNumberToUpdate = personalNumber;
      break;
    }
    print('Invalid input. Try again:');
  }
  Person personToUpdate = repository.getItems
      .firstWhere((person) => person.personalNumber == personalNumberToUpdate);
  Person newPerson = personToUpdate;

  while (true) {
    print('''
    Fyll i nya uppgifter för personen du vill uppdatera. Eller skriv ".samma." om du inte vill ändra den uppgiften.
    Nytt personnummer: ''');
    String input = stdin.readLineSync() ?? '';

    if (input == '.samma.') {
      break;
    }

    int? personalNumber = int.tryParse(input);

    if (personalNumber != null) {
      newPerson.personalNumber = personalNumber;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
  print('Nytt namn: ');
  String nameInput = stdin.readLineSync() ?? '';

  if (nameInput != '.samma.') newPerson.name = nameInput;
  repository.updateItem(personToUpdate, newPerson);
}

void updateVehicleHandler(
    VehicleRepository vehicleRepository, PersonRepository personRepository) {
  String registrationNumberToUpdate;
  while (true) {
    print('Fyll i registreringsnummer på det fordon du vill uppdatera: ');
    String registrationInput = stdin.readLineSync() ?? '';

    if (vehicleRepository.getItems
        .any((vehicle) => vehicle.registrationNumber == registrationInput)) {
      registrationNumberToUpdate = registrationInput;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
  Vehicle vehicleToUpdate = vehicleRepository.getItems.firstWhere(
      (vehicle) => vehicle.registrationNumber == registrationNumberToUpdate);
  Vehicle newVehicle = vehicleToUpdate;

  print('''
  Fyll i nya uppgifter för fordonet du vill uppdatera. Eller skriv ".samma." om du inte vill ändra den uppgiften.
  Nytt registreringsnummer: ''');
  String registrationInput = stdin.readLineSync() ?? '';

  if (registrationInput != '.samma.')
    newVehicle.registrationNumber = registrationInput;

  print('Nytt bilmärke: ');
  String typeInput = stdin.readLineSync() ?? '';

  if (typeInput != '.samma.') newVehicle.type = typeInput;

  while (true) {
    print('Ny ägare (personnummer): ');
    String input = stdin.readLineSync() ?? '';

    if (input == '.samma.') {
      break;
    }

    int? personalNumber = int.tryParse(input);

    if (personalNumber != null &&
        personRepository.getItems
            .any((person) => person.personalNumber == personalNumber)) {
      newVehicle.owner = personRepository.getItems
          .firstWhere((person) => person.personalNumber == personalNumber);
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

void updateParkingSpaceHandler(ParkingSpaceRepository repository) {
  String idToUpdate;
  while (true) {
    print('Fyll i id för den parkeringsplats du vill uppdatera: ');
    String idInput = stdin.readLineSync() ?? '';

    if (repository.getItems.any((parkingSpace) => parkingSpace.id == idInput)) {
      idToUpdate = idInput;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
  ParkingSpace parkingSpaceToUpdate = repository.getItems
      .firstWhere((parkingSpace) => parkingSpace.id == idToUpdate);
  ParkingSpace newParkingSpace = parkingSpaceToUpdate;

  print('''
  Fyll i nya uppgifter för parkeringsplatsen du vill uppdatera. Eller skriv ".samma." om du inte vill ändra den uppgiften.
  Ny adress: ''');
  String addressInput = stdin.readLineSync() ?? '';

  if (addressInput != '.samma.') newParkingSpace.address = addressInput;

  while (true) {
    print('Nytt pris per timme (kr): ');
    String input = stdin.readLineSync() ?? '';

    if (input == '.samma.') {
      break;
    }

    int? pricePerHour = int.tryParse(input);

    if (pricePerHour != null) {
      newParkingSpace.price = pricePerHour;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

void updateParkingHandler(
    ParkingRepository parkingRepository,
    VehicleRepository vehicleRepository,
    ParkingSpaceRepository parkingSpaceRepository) {
  String idToUpdate;
  while (true) {
    print('Fyll i id för den parkering du vill uppdatera: ');
    String idInput = stdin.readLineSync() ?? '';

    if (parkingRepository.getItems.any((parking) => parking.id == idInput)) {
      idToUpdate = idInput;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
  Parking parkingToUpdate = parkingRepository.getItems
      .firstWhere((parking) => parking.id == idToUpdate);
  Parking newParking = parkingToUpdate;

  print(
      'Fyll i nya uppgifter för parkeringsplatsen du vill uppdatera. Eller skriv ".samma." om du inte vill ändra den uppgiften.');
  while (true) {
    print('Nytt fordon (registreringsnummer): ');
    String registrationInput = stdin.readLineSync() ?? '';
    if (registrationInput == '.samma.') {
      break;
    }
    if (vehicleRepository.getItems
        .any((vehicle) => vehicle.registrationNumber == registrationInput)) {
      newParking.vehicle = vehicleRepository.getItems.firstWhere(
          (vehicle) => vehicle.registrationNumber == registrationInput);
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }

  while (true) {
    print('Ny parkeringsplats (id): ');
    String idInput = stdin.readLineSync() ?? '';
    if (idInput == '.samma.') {
      break;
    }
    if (parkingSpaceRepository.getItems
        .any((parkingSpace) => parkingSpace.id == idInput)) {
      newParking.parkingSpace = parkingSpaceRepository.getItems
          .firstWhere((parkingSpace) => parkingSpace.id == idInput);
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }

  while (true) {
    print('Ny starttid (unix timestamp): ');
    String input = stdin.readLineSync() ?? '';

    if (input == '.samma.') {
      break;
    }

    int? startTime = int.tryParse(input);

    if (startTime != null) {
      newParking.startTime = startTime;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }

  while (true) {
    print('Ny sluttid (unix timestamp): ');
    String input = stdin.readLineSync() ?? '';

    if (input == '.samma.') {
      break;
    }

    int? endTime = int.tryParse(input);

    if (endTime != null) {
      newParking.endTime = endTime;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

// DELETE
void deletePersonHandler(PersonRepository repository) {
  while (true) {
    print('Fyll i personnummer på den person du vill ta bort');
    String input = stdin.readLineSync() ?? '';

    int? personalNumber = int.tryParse(input);

    if (personalNumber != null &&
        repository.getItems
            .any((person) => person.personalNumber == personalNumber)) {
      repository.deleteItem(repository.getItems
          .firstWhere((person) => person.personalNumber == personalNumber));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

void deleteVehicleHandler(VehicleRepository repository) {
  while (true) {
    print('Fyll i registreringsnummer på det fordon du vill ta bort');
    String registrationInput = stdin.readLineSync() ?? '';

    if (repository.getItems
        .any((vehicle) => vehicle.registrationNumber == registrationInput)) {
      repository.deleteItem(repository.getItems.firstWhere(
          (vehicle) => vehicle.registrationNumber == registrationInput));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

void deleteParkingSpaceHandler(ParkingSpaceRepository repository) {
  while (true) {
    print('Fyll i adressen för den parkeringsplats du vill ta bort');
    String addressInput = stdin.readLineSync() ?? '';

    if (repository.getItems
        .any((parkingSpace) => parkingSpace.address == addressInput)) {
      repository.deleteItem(repository.getItems
          .firstWhere((parkingSpace) => parkingSpace.address == addressInput));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

void deleteParkingHandler(ParkingRepository repository) {
  while (true) {
    print('Fyll i id för den parkering du vill ta bort');
    String idInput = stdin.readLineSync() ?? '';

    if (repository.getItems.any((parking) => parking.id == idInput)) {
      repository.deleteItem(
          repository.getItems.firstWhere((parking) => parking.id == idInput));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}
