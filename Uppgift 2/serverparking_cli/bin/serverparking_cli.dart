import 'package:serverparking_cli/main.dart';

void main(List<String> arguments) async {
  bool isRunning = true;

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
        await searchSubmenu();
        break;
      case 6:
        print('Avslutar programmet... Hej då!');
        isRunning = false;
        break;
      default:
        print('Ogiltigt val. Välj gärna mellan alternativ 1-6.');
        break;
    }
  }
}
