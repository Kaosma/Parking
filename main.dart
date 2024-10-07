import 'dart:io';

void choiceHandler(String? choice) {
  switch (choice) {
    case '1':
      personMainHandler();
      break;
    case '2':
      personMainHandler();
      break;
    case '3':
      personMainHandler();
      break;
    case '4':
      personMainHandler();
      break;
    case '5':
      print('Du har valt att avsluta, hej då!');
      return;
    default:
      print('Ogiltigt val. Välj gärna mellan alternativ 1-5');
  }
}

void personMainHandler() {
  stdout.write('''
    Du har valt att hantera Personer. Vad vill du göra?
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
        print('Ogiltigt val. Välj gärna mellan alternativ 1-5');
        break;
    }
  }
}

bool validPersonInput = false;
void validatePersonInput() {
  validPersonInput = true;
}

void main(List<String> arguments) {
  while (true) {
    print('''
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
      print('Du har valt att avsluta, hej då!');
      break; // Exit the program
    }
    choiceHandler(input);
  }
}
