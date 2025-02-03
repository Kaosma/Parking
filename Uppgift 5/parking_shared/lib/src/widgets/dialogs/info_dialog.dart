import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String text;
  final String? actionText;
  final void Function()? confirmAction;
  const InfoDialog(
      {required this.title,
      required this.text,
      this.actionText,
      this.confirmAction,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        if (confirmAction != null && actionText != null)
          ElevatedButton(
            onPressed: () {
              confirmAction?.call();
              Navigator.of(context).pop();
            },
            child: Text(actionText!),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
