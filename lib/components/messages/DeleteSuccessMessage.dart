import 'package:flutter/material.dart';

class DeleteSuccessMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onClose;

  const DeleteSuccessMessage({super.key, required this.message, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.delete_sweep, color: Colors.orange.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.orange.shade700),
            ),
          ),
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: Colors.orange.shade700,
              onPressed: onClose,
            ),
        ],
      ),
    );
  }
}
