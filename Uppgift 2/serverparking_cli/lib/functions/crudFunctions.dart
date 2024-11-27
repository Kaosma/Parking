import 'package:serverparking_shared/serverparking_shared.dart';

import '../repositories/parkingSpace_repository.dart';
import '../repositories/parking_repository.dart';
import '../repositories/person_repository.dart';

import '../repositories/vehicle_repository.dart';
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
      await personRepository.add(Person(nameInput, personalNumber));
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
    String idInput = inputHandler('Fyll i en ägares id');
    final owner = await personRepository.getById(idInput);
    if (owner != null) {
      await vehicleRepository.add(Vehicle(registrationInput, typeInput, owner));
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
      await parkingSpaceRepository.add(ParkingSpace(addressInput, price));
      break;
    }
    print('Ogiltigt val. Testa igen.');
  }
}

Future<void> createParkingHandler() async {
  int startTime;
  int endTime;
  String vehicleId = inputHandler('Fyll i fordonets id');
  String parkingSpaceId = inputHandler('Fyll i parkeringsplatsens id');

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
  final vehicle = await vehicleRepository.getById(vehicleId);
  final parkingSpace = await parkingSpaceRepository.getById(parkingSpaceId);

  if (vehicle != null && parkingSpace != null) {
    parkingRepository.add(Parking(
        vehicle: vehicle,
        parkingSpace: parkingSpace,
        startTime: startTime,
        endTime: endTime));
  }
}

// READ
Future<void> getAllPersonsHandler() async {
  final items = await personRepository.getAll();
  print('');
  print(items.map((item) => item.toString()).join('\n'));
}

Future<void> getAllVehiclesHandler() async {
  final items = await vehicleRepository.getAll();
  print('');
  print(items.map((item) => item.toString()).join('\n'));
}

Future<void> getAllParkingSpacesHandler() async {
  final items = await parkingSpaceRepository.getAll();
  print('');
  print(items.map((item) => item.toString()).join('\n'));
}

Future<void> getAllParkingsHandler() async {
  final items = await parkingRepository.getAll();
  print('');
  print(items.map((item) => item.toString()).join('\n'));
}

// UPDATE
Future<void> updatePersonHandler() async {
  String idInput = inputHandler('Fyll i id på den person du vill uppdatera');
  Person newPerson;
  final personToUpdate = await personRepository.getById(idInput);

  if (personToUpdate != null) {
    newPerson = personToUpdate;

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
    if (newPerson != false) {
      await personRepository.update(idInput, newPerson);
    }
  }
}

Future<void> updateVehicleHandler() async {
  String idInput = inputHandler('Fyll i id på det fordon du vill uppdatera');
  final newVehicle = await vehicleRepository.getById(idInput);

  if (newVehicle != null) {
    print(
        'Fyll i nya uppgifter för fordonet du vill uppdatera. Eller skriv ".samma." om du inte vill ändra den uppgiften.');
    String registrationInput;
    while (true) {
      registrationInput = inputHandler('Uppdatera registreringsnummer');
      if (registrationNumberExpressionValid.hasMatch(registrationInput)) break;
    }

    if (registrationInput != '.samma.') {
      newVehicle.registrationNumber = registrationInput;
    }

    String typeInput = inputHandler('Uppdatera fordonstyp');

    if (typeInput != '.samma.') newVehicle.type = typeInput;

    while (true) {
      String idInput = inputHandler('Uppdatera ägare (id)');

      if (idInput == '.samma.') {
        break;
      }

      final newOwner = await personRepository.getById(idInput);
      if (newOwner != null) {
        newVehicle.owner = newOwner;
        break;
      }
      print('Ogiltigt val. Testa igen.');

      await vehicleRepository.update(idInput, newVehicle);
    }
  }
}

Future<void> updateParkingSpaceHandler() async {
  String idToUpdate;
  final repositoryItems = await parkingSpaceRepository.getAll();
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
  await parkingSpaceRepository.update(idToUpdate, newParkingSpace);
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
  final parkingToUpdate = await parkingRepository.getById(idToUpdate);
  if (parkingToUpdate != null) {
    Parking newParking = parkingToUpdate;

    print(
        'Fyll i nya uppgifter för parkeringsplatsen du vill uppdatera. Eller skriv ".samma." om du inte vill ändra den uppgiften.');
    while (true) {
      String vehicleIdInput = inputHandler('Uppdatera fordon (id)');
      if (vehicleIdInput == '.samma.') {
        break;
      }
      final vehicle = await vehicleRepository.getById(vehicleIdInput);
      if (vehicle != null) {
        newParking.vehicle = vehicle;
        break;
      }
      print('Ogiltigt val. Testa igen.');
    }

    while (true) {
      String idInput = inputHandler('Uppdatera parkeringsplats (id)');
      if (idInput == '.samma.') {
        break;
      }
      final repositoryItems = await parkingSpaceRepository.getAll();
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
    await parkingRepository.update(idToUpdate, newParking);
  }
}

// DELETE
Future<void> deletePersonHandler() async {
  String input = inputHandler('Fyll i id på den person du vill ta bort');
  await personRepository.delete(input);
}

Future<void> deleteVehicleHandler() async {
  String input = inputHandler('Fyll i id på det fordon du vill ta bort');
  await vehicleRepository.delete(input);
}

Future<void> deleteParkingSpaceHandler() async {
  String input =
      inputHandler('Fyll i id på den parkeringsplats du vill ta bort');
  await parkingSpaceRepository.delete(input);
}

Future<void> deleteParkingHandler() async {
  String input = inputHandler('Fyll i id på den parkering du vill ta bort');
  await parkingRepository.delete(input);
}
