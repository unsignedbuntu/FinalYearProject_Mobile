import 'package:flutter/material.dart';

class FavoritesHeader extends StatelessWidget {
  final int itemCount;
  final VoidCallback? onClearAll;

  const FavoritesHeader({super.key, required this.itemCount, this.onClearAll});

  @override
  Widget build(BuildContext context) {
    // Determine if the clear all button should be shown
    bool showClearAll = onClearAll != null && itemCount > 0;
    // Calculate a placeholder width roughly equivalent to the clear all button
    double clearAllButtonPlaceholderWidth = 100.0; // Adjust as needed

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Pushes elements apart
        children: [
          // Spacer to push content towards center from left
          const Spacer(flex: 1),

          // Content group (Icon + Text)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite, color: Colors.red.shade700, size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Favorites',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                    style: TextStyle(color: Colors.red.shade700, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),

          // Spacer to push content towards center from right
          const Spacer(flex: 1),

          // Conditionally display Clear All button or a SizedBox placeholder
          // This placeholder ensures the center content remains centered even without the button
          if (showClearAll)
            TextButton.icon(
              onPressed: onClearAll,
              icon: Icon(
                Icons.delete_sweep,
                color: Colors.red.shade700,
                size: 20,
              ),
              label: Text(
                'Clear All',
                style: TextStyle(color: Colors.red.shade700, fontSize: 15),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: const Size(10, 40),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            )
          else
            // Use a SizedBox with a specific width as a placeholder
            SizedBox(width: clearAllButtonPlaceholderWidth),
        ],
      ),
    );
  }
}
