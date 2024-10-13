import 'dart:io';
import 'classes.dart';
import 'crudFunctions.dart';

var personRepository = PersonRepository();
var vehicleRepository = VehicleRepository();
var parkingSpaceRepository = ParkingSpaceRepository();
var parkingRepository = ParkingRepository();
bool inSubmenu = false;

void main(List<String> arguments) {
  bool isRunning = true;

  // Main loop
  while (isRunning) {
    int choice = mainMenu();

    switch (choice) {
      case 1:
        submenu(1);
        break;
      case 2:
        submenu(2);
        break;
      case 3:
        submenu(3);
        break;
      case 4:
        submenu(4);
        break;
      case 5:
        print('Avslutar programmet... Hej då!');
        isRunning = false;
        break;
      default:
        print('Ogiltigt val. Välj gärna mellan alternativ 1-5');
        break;
    }
  }
}

// Main menu function
int mainMenu() {
  stdout.write('''

    Välkommen till Parkeringsappen!
    Vad vill du hantera?
    1. Personer
    2. Fordon
    3. Parkeringsplatser
    4. Parkeringar
    5. Avsluta

    Välj ett alternativ (1-5):
  ''');
  return getChoice();
}

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

// Submenu function for each option
void submenu(int optionNumber) {
  var option = getOptionHeadline(optionNumber);
  inSubmenu = true;

  while (inSubmenu) {
    print('\nDu har valt att hantera $option. Vad vill du göra?');
    print('1. Skapa $option.');
    print('2. Visa alla $option.');
    print('3. Uppdatera $option.');
    print('4. Ta bort $option.');
    print('5. Gå tillbaka till huvudmenyn.');

    int subChoice = getChoice();

    switch (subChoice) {
      case 1:
        createInstance(optionNumber);
        break;
      case 2:
        getAllInstances(optionNumber);
        break;
      case 3:
        updateInstance(optionNumber);
        break;
      case 4:
        deleteInstance(optionNumber);
        break;
      case 5:
        inSubmenu = false;
        break;
      default:
        print('Ogiltigt val. Välj gärna mellan alternativ 1-5');
        break;
    }
  }
}

// Function to get the user's choice
int getChoice() {
  String? input = stdin.readLineSync();
  int? choice = int.tryParse(input ?? '');
  return choice ?? -1;
}

void createInstance(int optionNumber) {
  switch (optionNumber) {
    case 1:
      createPersonHandler(personRepository);
      break;
    case 2:
      createVehicleHandler(vehicleRepository, personRepository);
      break;
    case 3:
      createParkingSpaceHandler(parkingSpaceRepository);
      break;
    case 4:
      createParkingHandler(
          parkingRepository, vehicleRepository, parkingSpaceRepository);
      break;
    case 5:
      inSubmenu = false;
      break;
    default:
      print('Ogiltigt val. Välj gärna mellan alternativ 1-5');
      break;
  }
}

void getAllInstances(int optionNumber) {
  switch (optionNumber) {
    case 1:
      getAllItemsHandler(personRepository);
      break;
    case 2:
      getAllItemsHandler(vehicleRepository);
      break;
    case 3:
      getAllItemsHandler(parkingSpaceRepository);
      break;
    case 4:
      getAllItemsHandler(parkingRepository);
      break;
    case 5:
      inSubmenu = false;
      break;
    default:
      print('Ogiltigt val. Välj gärna mellan alternativ 1-5');
      break;
  }
}

void updateInstance(int optionNumber) {
  switch (optionNumber) {
    case 1:
      updatePersonHandler(personRepository);
      break;
    case 2:
      updateVehicleHandler(vehicleRepository, personRepository);
      break;
    case 3:
      updateParkingSpaceHandler(parkingSpaceRepository);
      break;
    case 4:
      updateParkingHandler(
          parkingRepository, vehicleRepository, parkingSpaceRepository);
      break;
    case 5:
      inSubmenu = false;
      break;
    default:
      print('Ogiltigt val. Välj gärna mellan alternativ 1-5');
      break;
  }
}

void deleteInstance(int optionNumber) {
  switch (optionNumber) {
    case 1:
      deletePersonHandler(personRepository);
      break;
    case 2:
      deleteVehicleHandler(vehicleRepository);
      break;
    case 3:
      deleteParkingSpaceHandler(parkingSpaceRepository);
      break;
    case 4:
      deleteParkingHandler(parkingRepository);
      break;
    case 5:
      inSubmenu = false;
      break;
    default:
      print('Ogiltigt val. Välj gärna mellan alternativ 1-5');
      break;
  }
}
