import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onButtonPressed;
  const PrimaryButton(
      {required this.text, required this.onButtonPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FilledButton(onPressed: onButtonPressed, child: Text(text)),
    );
  }
}
