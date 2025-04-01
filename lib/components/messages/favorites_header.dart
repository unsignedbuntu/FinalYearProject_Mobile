import 'package:flutter/material.dart';

class FavoritesHeader extends StatelessWidget {
  final int itemCount;
  final VoidCallback? onClearAll;

  const FavoritesHeader({super.key, required this.itemCount, this.onClearAll});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Favorites',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                  style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                ),
              ],
            ),
          ),
          if (onClearAll != null && itemCount > 0)
            TextButton.icon(
              onPressed: onClearAll,
              icon: Icon(
                Icons.delete_sweep,
                color: Colors.red.shade700,
                size: 18,
              ),
              label: Text(
                'Clear All',
                style: TextStyle(color: Colors.red.shade700),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(10, 36),
              ),
            ),
        ],
      ),
    );
  }
}
