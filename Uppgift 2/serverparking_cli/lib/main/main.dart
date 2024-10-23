import 'dart:io';
import '../functions/crudFunctions.dart';
import '../functions/helperFunctions.dart';

bool inSubmenu = false;
bool inSearchSubmenu = false;

int mainMenu() {
  stdout.write('''

    Välkommen till Parkeringsappen!
    Vad vill du hantera?
    1. Personer
    2. Fordon
    3. Parkeringsplatser
    4. Parkeringar
    5. Sök
    6. Avsluta

    Välj ett alternativ (1-5):
  ''');
  return getChoice();
}

Future<void> submenu(int optionNumber) async {
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
        await createInstance(optionNumber);
        break;
      case 2:
        await getAllInstances(optionNumber);
        break;
      case 3:
        await updateInstance(optionNumber);
        break;
      case 4:
        await deleteInstance(optionNumber);
        break;
      case 5:
        inSubmenu = false;
        break;
      default:
        print('Ogiltigt val. Välj gärna mellan alternativ 1-5.');
        break;
    }
  }
}

Future<void> searchSubmenu() async {
  inSearchSubmenu = true;

  while (inSearchSubmenu) {
    print('\nDu har valt att söka. Vad vill du söka på?');
    print('1. Alla fordon för en ägare (sök på personnummer)');
    print('2. Alla parkeringar för ett fordon (sök på registreringsnummer)');
    print('3. Gå tillbaka till huvudmenyn.');

    int subChoice = getChoice();

    switch (subChoice) {
      case 1:
        await searchForVehiclesByOwner();
        break;
      case 2:
        await searchForParkingsByVehicle();
        break;
      case 3:
        inSearchSubmenu = false;
        break;
      default:
        print('Ogiltigt val. Välj gärna mellan alternativ 1-3.');
        break;
    }
  }
}

Future<void> createInstance(int optionNumber) async {
  switch (optionNumber) {
    case 1:
      await createPersonHandler();
      break;
    case 2:
      await createVehicleHandler();
      break;
    case 3:
      await createParkingSpaceHandler();
      break;
    case 4:
      await createParkingHandler();
      break;
    case 5:
      inSubmenu = false;
      break;
    default:
      print('Ogiltigt val. Välj gärna mellan alternativ 1-5');
      break;
  }
}

Future<void> getAllInstances(int optionNumber) async {
  switch (optionNumber) {
    case 1:
      await getAllPersonsHandler();
      break;
    case 2:
      await getAllVehiclesHandler();
      break;
    case 3:
      await getAllParkingSpacesHandler();
      break;
    case 4:
      await getAllParkingsHandler();
      break;
    case 5:
      inSubmenu = false;
      break;
    default:
      print('Ogiltigt val. Välj gärna mellan alternativ 1-5');
      break;
  }
}

Future<void> updateInstance(int optionNumber) async {
  switch (optionNumber) {
    case 1:
      await updatePersonHandler();
      break;
    case 2:
      await updateVehicleHandler();
      break;
    case 3:
      await updateParkingSpaceHandler();
      break;
    case 4:
      await updateParkingHandler();
      break;
    case 5:
      inSubmenu = false;
      break;
    default:
      print('Ogiltigt val. Välj gärna mellan alternativ 1-5');
      break;
  }
}

Future<void> deleteInstance(int optionNumber) async {
  switch (optionNumber) {
    case 1:
      await deletePersonHandler();
      break;
    case 2:
      await deleteVehicleHandler();
      break;
    case 3:
      await deleteParkingSpaceHandler();
      break;
    case 4:
      await deleteParkingHandler();
      break;
    case 5:
      inSubmenu = false;
      break;
    default:
      print('Ogiltigt val. Välj gärna mellan alternativ 1-5');
      break;
  }
}
