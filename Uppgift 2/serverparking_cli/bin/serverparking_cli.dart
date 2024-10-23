import 'package:serverparking_cli/main/main.dart';

void main(List<String> arguments) async {
  bool isRunning = true;

  while (isRunning) {
    int choice = mainMenu();

    switch (choice) {
      case 1:
        await submenu(1);
        break;
      case 2:
        await submenu(2);
        break;
      case 3:
        await submenu(3);
        break;
      case 4:
        await submenu(4);
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
