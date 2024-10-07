import 'dart:io';

void choiceHandler(String? choice) {
  switch (choice) {
    case '1':
      personMainHandler();
      break;
    case '2':
      vehicleMainHandler();
      break;
    case '3':
      parkingSpaceMainHandler();
      break;
    case '4':
      parkingMainHandler();
      break;
    case '5':
      return;
    default:
      stdout.write('''

        'Ogiltigt val. Välj gärna mellan alternativ 1-5'
      ''');
  }
}

void personMainHandler() {
  stdout.write('''

    Du har valt att hantera personer. Vad vill du göra?
    1. Skapa ny person
    2. Visa alla personer
    3. Uppdatera person
    4. Ta bort person
    5. Gå tillbaka till huvudmenyn

    Välj ett alternativ (1-5):
  ''');
  while (!validPersonInput) {
    final input = stdin.readLineSync();
    switch (input) {
      case '1':
        validatePersonInput();
        print('nu får du skapa en person!');
        break;
      case '2':
        validatePersonInput();
        print('nu visas alla personer!');
        break;
      case '3':
        validatePersonInput();
        print('nu får du uppdatera en person!');
        break;
      case '4':
        validatePersonInput();
        print('nu får du ta bort en person!');
        break;
      case '5':
        validatePersonInput();
        return;
      default:
        stdout.write('''

          'Ogiltigt val. Välj gärna mellan alternativ 1-5'
        ''');
        break;
    }
  }
}

void vehicleMainHandler() {
  stdout.write('''

    Du har valt att hantera fordon. Vad vill du göra?
    1. Lägg till nytt fordon
    2. Visa alla fordon
    3. Uppdatera fordon
    4. Ta bort fordon
    5. Gå tillbaka till huvudmenyn

    Välj ett alternativ (1-5):
  ''');
  while (!validVehicleInput) {
    final input = stdin.readLineSync();
    switch (input) {
      case '1':
        validateVehicleInput();
        print('nu får du skapa ett fordon!');
        break;
      case '2':
        validateVehicleInput();
        print('nu visas alla fordon!');
        break;
      case '3':
        validateVehicleInput();
        print('nu får du uppdatera ett fordon!');
        break;
      case '4':
        validateVehicleInput();
        print('nu får du ta bort ett fordon!');
        break;
      case '5':
        validateVehicleInput();
        return;
      default:
        stdout.write('''

          'Ogiltigt val. Välj gärna mellan alternativ 1-5'
        ''');
        break;
    }
  }
}

void parkingSpaceMainHandler() {
  stdout.write('''

    Du har valt att hantera parkeringsplatser. Vad vill du göra?
    1. Lägg till ny parkeringsplats
    2. Visa alla parkeringsplatser
    3. Uppdatera parkeringsplats
    4. Ta bort parkeringsplats
    5. Gå tillbaka till huvudmenyn

    Välj ett alternativ (1-5):
  ''');
  while (!validParkingSpaceInput) {
    final input = stdin.readLineSync();
    switch (input) {
      case '1':
        validateParkingSpaceInput();
        print('nu får du skapa en parkeringsplats!');
        break;
      case '2':
        validateParkingSpaceInput();
        print('nu visas alla parkeringsplatser!');
        break;
      case '3':
        validateParkingSpaceInput();
        print('nu får du uppdatera en parkeringsplats!');
        break;
      case '4':
        validateParkingSpaceInput();
        print('nu får du ta bort en parkeringsplats!');
        break;
      case '5':
        validateParkingSpaceInput();
        return;
      default:
        stdout.write('''

          'Ogiltigt val. Välj gärna mellan alternativ 1-5'
        ''');
        break;
    }
  }
}

void parkingMainHandler() {
  stdout.write('''

    Du har valt att hantera parkeringar. Vad vill du göra?
    1. Lägg till ny parkering
    2. Visa alla parkeringar
    3. Uppdatera parkering
    4. Ta bort parkering
    5. Gå tillbaka till huvudmenyn

    Välj ett alternativ (1-5):
  ''');
  while (!validParkingInput) {
    final input = stdin.readLineSync();
    switch (input) {
      case '1':
        validateParkingInput();
        print('nu får du skapa en parkering!');
        break;
      case '2':
        validateParkingInput();
        print('nu visas alla parkeringar!');
        break;
      case '3':
        validateParkingInput();
        print('nu får du uppdatera en parkering!');
        break;
      case '4':
        validateParkingInput();
        print('nu får du ta bort en parkering!');
        break;
      case '5':
        validateParkingInput();
        return;
      default:
        stdout.write('''

          'Ogiltigt val. Välj gärna mellan alternativ 1-5'
        ''');
        break;
    }
  }
}

bool validPersonInput = false;
void validatePersonInput() {
  validPersonInput = true;
}

bool validVehicleInput = false;
void validateVehicleInput() {
  validVehicleInput = true;
}

bool validParkingSpaceInput = false;
void validateParkingSpaceInput() {
  validParkingSpaceInput = true;
}

bool validParkingInput = false;
void validateParkingInput() {
  validParkingInput = true;
}

void main(List<String> arguments) {
  while (true) {
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

    String? input = stdin.readLineSync();
    if (input == '5') {
      stdout.write('''

        'Du har valt att avsluta, hej då!'
      ''');
      break; // Exit the program
    }
    choiceHandler(input);
  }
}
