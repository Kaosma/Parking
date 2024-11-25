import 'package:flutter/material.dart';
import 'package:parking_admin/widgets/cards/grid_cell_card.dart';

import '../../widgets/buttons/grid_cell_button.dart';

class ParkingSpacesPage extends StatelessWidget {
  const ParkingSpacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    openDialog() => print('wqfqfx');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisSpacing: 8.0, // Spacing between columns
        mainAxisSpacing: 8.0, // Spacing between rows
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 3,
        children: <Widget>[
          GridCellButton(
            text: 'Lägg till parkeringsplats',
            onButtonPressed: openDialog,
          ),
          const GridCellCard(
            title: 'parking space 1',
            text: 'This is a parking space',
          ),
          const GridCellCard(
            title: 'parking space 2',
            text: 'This is a parking space',
          ),
        ],
      ),
    );
  }
}
