import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final void Function()? onEdit;
  final void Function()? onDelete;
  const ListCard(
      {required this.icon,
      required this.title,
      required this.text,
      this.onEdit,
      this.onDelete,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(text),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
