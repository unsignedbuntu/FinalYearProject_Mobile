import 'package:flutter/material.dart';

class CartSuccessMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onClose;
  final VoidCallback? onViewCart;

  const CartSuccessMessage({
    super.key,
    required this.message,
    this.onClose,
    this.onViewCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.green.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.green.shade700),
                ),
              ),
              if (onClose != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: Colors.green.shade700,
                  onPressed: onClose,
                ),
            ],
          ),
          if (onViewCart != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 36),
              child: TextButton(
                onPressed: onViewCart,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  backgroundColor: Colors.green.shade100,
                ),
                child: Text(
                  'View Cart',
                  style: TextStyle(color: Colors.green.shade700),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
