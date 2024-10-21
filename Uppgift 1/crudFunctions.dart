import 'classes.dart';

import 'helperFunctions.dart';

// CREATE
void createPersonHandler(PersonRepository repository) {
  String nameInput = inputHandler('Fyll i namn');

  while (true) {
    String input = inputHandler('Fyll i personnummer');

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
  String registrationInput;
  while (true) {
    registrationInput = inputHandler('Fyll i fordonets registreringsnummer');
    if (registrationNumberExpressionValid.hasMatch(registrationInput)) break;
  }

  String typeInput = inputHandler('Fyll i fordonstyp');

  while (true) {
    String input = inputHandler('Fyll i en ägares personnummer');

    int? personalNumber = int.tryParse(input);

    if (personalNumber != null &&
        _personRepository.getByPersonalNumber(personalNumber) != false) {
      Person owner = _personRepository.getByPersonalNumber(personalNumber);
      _vehicleRepository.addItem(Vehicle(registrationInput, typeInput, owner));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

void createParkingSpaceHandler(ParkingSpaceRepository repository) {
  String addressInput = inputHandler('Fyll i adress');

  while (true) {
    String input = inputHandler('Fyll i pris per timme (kr)');

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
    String registrationInput =
        inputHandler('Fyll i fordonets registreringsnummer');

    if (_vehicleRepository.getByRegistrationNumber(registrationInput) !=
        false) {
      registrationNumber = registrationInput;
      break;
    }

    print('Ogiltigt val. Testa igen.');
  }

  while (true) {
    String addressInput = inputHandler('Fyll i parkeringsplatsens adress');

    if (_parkingSpaceRepository.getByAddress(addressInput) != false) {
      address = addressInput;
      break;
    }

    print('Ogiltigt val. Testa igen.');
  }

  while (true) {
    String input = inputHandler('Fyll i parkeringens starttid');

    int? startTimeInput = int.tryParse(input);

    if (startTimeInput != null) {
      startTime = startTimeInput;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }

  while (true) {
    String input = inputHandler('Fyll i parkeringens sluttid');

    int? endTimeInput = int.tryParse(input);

    if (endTimeInput != null && endTimeInput >= startTime) {
      endTime = endTimeInput;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
  Vehicle vehicle =
      _vehicleRepository.getByRegistrationNumber(registrationNumber);
  ParkingSpace parkingSpace = _parkingSpaceRepository.getByAddress(address);
  _parkingRepository
      .addItem(Parking(vehicle, parkingSpace, startTime, endTime));
}

// READ
void getAllItemsHandler(Repository repository) {
  print('');
  print(repository.getItems.map((item) => item.toString()).join('\n'));
}

// UPDATE
void updatePersonHandler(PersonRepository repository) {
  int personalNumberToUpdate;
  while (true) {
    String input =
        inputHandler('Fyll i personnummer på den person du vill uppdatera');

    int? personalNumber = int.tryParse(input);

    if (personalNumber != null &&
        repository.getByPersonalNumber(personalNumber) != false) {
      personalNumberToUpdate = personalNumber;
      break;
    }
    print('Invalid input. Try again:');
  }
  Person personToUpdate =
      repository.getByPersonalNumber(personalNumberToUpdate);
  Person newPerson = personToUpdate;

  print(
      'Fyll i nya uppgifter för personen du vill uppdatera. Eller skriv ".samma." om du inte vill ändra den uppgiften.');
  while (true) {
    String input = inputHandler('Uppdatera personnummer');

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
  String nameInput = inputHandler('Uppdatera namn');

  if (nameInput != '.samma.') newPerson.name = nameInput;
  repository.updateItem(personToUpdate, newPerson);
}

void updateVehicleHandler(
    VehicleRepository vehicleRepository, PersonRepository personRepository) {
  String registrationNumberToUpdate;
  while (true) {
    String registrationInput = inputHandler(
        'Fyll i registreringsnummer på det fordon du vill uppdatera');

    if (vehicleRepository.getByRegistrationNumber(registrationInput) != false) {
      registrationNumberToUpdate = registrationInput;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
  Vehicle vehicleToUpdate =
      vehicleRepository.getByRegistrationNumber(registrationNumberToUpdate);
  Vehicle newVehicle = vehicleToUpdate;

  print(
      'Fyll i nya uppgifter för fordonet du vill uppdatera. Eller skriv ".samma." om du inte vill ändra den uppgiften.');
  String registrationInput;
  while (true) {
    registrationInput = inputHandler('Uppdatera registreringsnummer');
    if (registrationNumberExpressionValid.hasMatch(registrationInput)) break;
  }

  if (registrationInput != '.samma.')
    newVehicle.registrationNumber = registrationInput;

  String typeInput = inputHandler('Uppdatera bilmärke');

  if (typeInput != '.samma.') newVehicle.type = typeInput;

  while (true) {
    String input = inputHandler('Uppdatera ägare (personnummer)');

    if (input == '.samma.') {
      break;
    }

    int? personalNumber = int.tryParse(input);

    if (personalNumber != null &&
        personRepository.getByPersonalNumber(personalNumber) != false) {
      newVehicle.owner = personRepository.getByPersonalNumber(personalNumber);
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

void updateParkingSpaceHandler(ParkingSpaceRepository repository) {
  String idToUpdate;
  while (true) {
    String idInput =
        inputHandler('Fyll i id för den parkeringsplats du vill uppdatera');

    if (repository.getItems.any((parkingSpace) => parkingSpace.id == idInput)) {
      idToUpdate = idInput;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
  ParkingSpace parkingSpaceToUpdate = repository.getItems
      .firstWhere((parkingSpace) => parkingSpace.id == idToUpdate);
  ParkingSpace newParkingSpace = parkingSpaceToUpdate;

  print(
      'Fyll i nya uppgifter för parkeringsplatsen du vill uppdatera. Eller skriv ".samma." om du inte vill ändra den uppgiften.');
  String addressInput = inputHandler('Uppdatera adress');

  if (addressInput != '.samma.') newParkingSpace.address = addressInput;

  while (true) {
    String input = inputHandler('Uppdatera pris per timme (kr)');

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
    String idInput =
        inputHandler('Fyll i id för den parkering du vill uppdatera');

    if (parkingRepository.getById(idInput) != false) {
      idToUpdate = idInput;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
  Parking parkingToUpdate = parkingRepository.getById(idToUpdate);
  Parking newParking = parkingToUpdate;

  print(
      'Fyll i nya uppgifter för parkeringsplatsen du vill uppdatera. Eller skriv ".samma." om du inte vill ändra den uppgiften.');
  while (true) {
    String registrationInput =
        inputHandler('Uppdatera fordon (registreringsnummer)');
    if (registrationInput == '.samma.') {
      break;
    }
    if (vehicleRepository.getByRegistrationNumber(registrationInput) != false) {
      newParking.vehicle =
          vehicleRepository.getByRegistrationNumber(registrationInput);
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }

  while (true) {
    String idInput = inputHandler('Uppdatera parkeringsplats (id)');
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
    String input = inputHandler('Uppdatera starttid (unix timestamp)');

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
    String input = inputHandler('Uppdatera sluttid (unix timestamp)');

    if (input == '.samma.') {
      break;
    }

    int? endTimeInput = int.tryParse(input);

    if (endTimeInput != null && endTimeInput >= newParking.startTime) {
      newParking.endTime = endTimeInput;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

// DELETE
void deletePersonHandler(PersonRepository repository) {
  while (true) {
    String input =
        inputHandler('Fyll i personnummer på den person du vill ta bort');

    int? personalNumber = int.tryParse(input);

    if (personalNumber != null &&
        repository.getByPersonalNumber(personalNumber) != false) {
      repository.deleteItem(repository.getByPersonalNumber(personalNumber));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

void deleteVehicleHandler(VehicleRepository repository) {
  while (true) {
    String registrationInput = inputHandler(
        'Fyll i registreringsnummer på det fordon du vill ta bort');

    if (repository.getByRegistrationNumber(registrationInput) != false) {
      repository
          .deleteItem(repository.getByRegistrationNumber(registrationInput));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

void deleteParkingSpaceHandler(ParkingSpaceRepository repository) {
  while (true) {
    String addressInput =
        inputHandler('Fyll i adressen för den parkeringsplats du vill ta bort');

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
    String idInput =
        inputHandler('Fyll i id för den parkering du vill ta bort');

    if (repository.getById(idInput) != false) {
      repository.deleteItem(repository.getById(idInput));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}
