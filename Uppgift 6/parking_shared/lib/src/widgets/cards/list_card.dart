import 'package:flutter/material.dart';
import 'package:glowy_borders/glowy_borders.dart';

class ListCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String text;
  final void Function()? onEdit;
  final void Function()? onDelete;
  final bool isActive;

  const ListCard({
    required this.icon,
    required this.title,
    required this.text,
    this.onEdit,
    this.onDelete,
    this.isActive = false,
    super.key,
  });

  @override
  _ListCardState createState() => _ListCardState();
}

class _ListCardState extends State<ListCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: Icon(widget.icon),
          title: Text(widget.title),
          subtitle: Text(widget.text),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: widget.onEdit,
                ),
              if (widget.onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: widget.onDelete,
                ),
            ],
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animationProgress = _controller.value;
        return AnimatedGradientBorder(
          borderSize: 1,
          glowSize: 1,
          gradientColors: [
            Colors.green.shade200,
            Colors.green.shade400,
            Colors.green,
          ],
          animationProgress: animationProgress,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 1.0),
            child: ListTile(
              leading: Icon(widget.icon),
              title: Text(widget.title),
              subtitle: Text(widget.text),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: widget.onEdit,
                    ),
                  if (widget.onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: widget.onDelete,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
