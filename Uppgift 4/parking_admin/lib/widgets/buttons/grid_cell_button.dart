import 'package:flutter/material.dart';

class GridCellButton extends StatelessWidget {
  final String text;
  final VoidCallback onButtonPressed;
  const GridCellButton(
      {required this.text, required this.onButtonPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 40),
                const SizedBox(height: 4),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
