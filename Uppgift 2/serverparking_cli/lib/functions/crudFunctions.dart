import '../classes/Parking.dart';
import '../classes/ParkingSpace.dart';
import '../classes/Person.dart';
import '../classes/Repository.dart';
import '../classes/Vehicle.dart';

import 'helperFunctions.dart';

var personRepository = PersonRepository();
var vehicleRepository = VehicleRepository();
var parkingSpaceRepository = ParkingSpaceRepository();
var parkingRepository = ParkingRepository();

// CREATE
Future<void> createPersonHandler() async {
  String nameInput = inputHandler('Fyll i namn');

  while (true) {
    String input = inputHandler('Fyll i personnummer');

    int? personalNumber = int.tryParse(input);

    if (personalNumber != null) {
      personRepository.addItem(Person(nameInput, personalNumber));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

Future<void> createVehicleHandler() async {
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
        await personRepository.getByPersonalNumber(personalNumber) != false) {
      Person owner = await personRepository.getByPersonalNumber(personalNumber);
      vehicleRepository.addItem(Vehicle(registrationInput, typeInput, owner));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

Future<void> createParkingSpaceHandler() async {
  String addressInput = inputHandler('Fyll i adress');

  while (true) {
    String input = inputHandler('Fyll i pris per timme (kr)');

    int? price = int.tryParse(input);

    if (price != null) {
      parkingSpaceRepository.addItem(ParkingSpace(addressInput, price));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

Future<void> createParkingHandler() async {
  String registrationNumber;
  String address;
  int startTime;
  int endTime;
  while (true) {
    String registrationInput =
        inputHandler('Fyll i fordonets registreringsnummer');

    if (vehicleRepository.getByRegistrationNumber(registrationInput) != false) {
      registrationNumber = registrationInput;
      break;
    }

    print('Ogiltigt val. Testa igen.');
  }

  while (true) {
    String addressInput = inputHandler('Fyll i parkeringsplatsens adress');

    if (parkingSpaceRepository.getByAddress(addressInput) != false) {
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
      await vehicleRepository.getByRegistrationNumber(registrationNumber);
  ParkingSpace parkingSpace =
      await parkingSpaceRepository.getByAddress(address);
  parkingRepository.addItem(Parking(vehicle, parkingSpace, startTime, endTime));
}

// READ
Future<void> getAllPersonsHandler() async {
  final items = await personRepository.getItems;
  print('');
  print(items.map((item) => item.toString()).join('\n'));
}

Future<void> getAllVehiclesHandler() async {
  final items = await vehicleRepository.getItems;
  print('');
  print(items.map((item) => item.toString()).join('\n'));
}

Future<void> getAllParkingSpacesHandler() async {
  final items = await parkingSpaceRepository.getItems;
  print('');
  print(items.map((item) => item.toString()).join('\n'));
}

Future<void> getAllParkingsHandler() async {
  final items = await parkingRepository.getItems;
  print('');
  print(items.map((item) => item.toString()).join('\n'));
}

// UPDATE
Future<void> updatePersonHandler() async {
  int personalNumberToUpdate;
  while (true) {
    String input =
        inputHandler('Fyll i personnummer på den person du vill uppdatera');

    int? personalNumber = int.tryParse(input);

    if (personalNumber != null &&
        personRepository.getByPersonalNumber(personalNumber) != false) {
      personalNumberToUpdate = personalNumber;
      break;
    }
    print('Invalid input. Try again:');
  }
  Person personToUpdate =
      await personRepository.getByPersonalNumber(personalNumberToUpdate);
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
  personRepository.updateItem(personToUpdate, newPerson);
}

Future<void> updateVehicleHandler() async {
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
  Vehicle newVehicle = await vehicleRepository
      .getByRegistrationNumber(registrationNumberToUpdate);
  ;

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
        await personRepository.getByPersonalNumber(personalNumber) != false) {
      newVehicle.owner =
          await personRepository.getByPersonalNumber(personalNumber);
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

Future<void> updateParkingSpaceHandler() async {
  String idToUpdate;
  final repositoryItems = await parkingSpaceRepository.getItems;
  while (true) {
    String idInput =
        inputHandler('Fyll i id för den parkeringsplats du vill uppdatera');
    if (repositoryItems.any((parkingSpace) => parkingSpace.id == idInput)) {
      idToUpdate = idInput;
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
  ParkingSpace parkingSpaceToUpdate = repositoryItems
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

Future<void> updateParkingHandler() async {
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
  Parking parkingToUpdate = await parkingRepository.getById(idToUpdate);
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
          await vehicleRepository.getByRegistrationNumber(registrationInput);
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }

  while (true) {
    String idInput = inputHandler('Uppdatera parkeringsplats (id)');
    if (idInput == '.samma.') {
      break;
    }
    final repositoryItems = await parkingSpaceRepository.getItems;
    if (repositoryItems.any((parkingSpace) => parkingSpace.id == idInput)) {
      newParking.parkingSpace = repositoryItems
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
Future<void> deletePersonHandler() async {
  while (true) {
    String input =
        inputHandler('Fyll i personnummer på den person du vill ta bort');

    int? personalNumber = int.tryParse(input);
    if (personalNumber != null &&
        await personRepository.getByPersonalNumber(personalNumber) != false) {
      personRepository.deleteItem(
          await personRepository.getByPersonalNumber(personalNumber));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

Future<void> deleteVehicleHandler() async {
  while (true) {
    String registrationInput = inputHandler(
        'Fyll i registreringsnummer på det fordon du vill ta bort');
    final vehicle =
        await vehicleRepository.getByRegistrationNumber(registrationInput);

    if (vehicle != false) {
      vehicleRepository.deleteItem(vehicle);
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

Future<void> deleteParkingSpaceHandler() async {
  while (true) {
    String addressInput =
        inputHandler('Fyll i adressen för den parkeringsplats du vill ta bort');
    final respositoryItems = await parkingSpaceRepository.getItems;

    if (respositoryItems
        .any((parkingSpace) => parkingSpace.address == addressInput)) {
      parkingSpaceRepository.deleteItem(respositoryItems
          .firstWhere((parkingSpace) => parkingSpace.address == addressInput));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

Future<void> deleteParkingHandler() async {
  while (true) {
    String idInput =
        inputHandler('Fyll i id för den parkering du vill ta bort');
    final parking = await parkingRepository.getById(idInput);
    if (parking != false) {
      parkingRepository.deleteItem(parking);
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}
