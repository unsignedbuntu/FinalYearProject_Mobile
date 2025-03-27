import 'package:flutter/material.dart';

class MyCartMessage extends StatelessWidget {
  final int itemCount;
  final double total;
  final VoidCallback? onViewCart;
  final VoidCallback? onCheckout;

  const MyCartMessage({
    super.key,
    required this.itemCount,
    required this.total,
    this.onViewCart,
    this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.blue.shade700, size: 24),
              const SizedBox(width: 12),
              Text(
                'My Cart',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$itemCount ${itemCount == 1 ? 'item' : 'items'} in cart',
                  style: TextStyle(color: Colors.blue.shade700, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (onViewCart != null)
                      OutlinedButton(
                        onPressed: onViewCart,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue.shade700,
                          side: BorderSide(color: Colors.blue.shade700),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('View Cart'),
                      ),
                    const SizedBox(width: 12),
                    if (onCheckout != null)
                      ElevatedButton(
                        onPressed: onCheckout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Checkout'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
