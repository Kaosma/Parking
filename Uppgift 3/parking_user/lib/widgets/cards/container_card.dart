import 'package:flutter/material.dart';

class ContainerCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const ContainerCard(
      {required this.icon, required this.title, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(text),
      ),
    );
  }
}