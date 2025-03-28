import 'package:flutter/material.dart';

class DeleteMessageFavorites extends StatelessWidget {
  final String message;
  final VoidCallback? onClose;
  final VoidCallback? onUndo;

  const DeleteMessageFavorites({
    super.key,
    required this.message,
    this.onClose,
    this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.delete, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: TextStyle(color: Colors.red.shade700)),
          ),
          if (onUndo != null)
            TextButton(
              onPressed: onUndo,
              child: Text(
                'UNDO',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: Colors.red.shade700,
              onPressed: onClose,
            ),
        ],
      ),
    );
  }
}
