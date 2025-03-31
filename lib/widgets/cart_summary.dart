import 'package:flutter/material.dart';

// Define fonts
const String redHatDisplayFont = 'RedHatDisplay'; // Make sure font is added
const String interFont = 'Inter';

class CartSummary extends StatelessWidget {
  final int selectedCount;
  final double selectedTotalPrice;
  final VoidCallback onCompleteShopping;

  const CartSummary({
    super.key,
    required this.selectedCount,
    required this.selectedTotalPrice,
    required this.onCompleteShopping,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = selectedCount > 0;
    const double shippingThreshold =
        0; // Assume free shipping always for now if selected
    const double standardShippingCost = 49.99;
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust width based on screen size
    final summaryWidth = screenWidth < 768 ? screenWidth * 0.8 : 255.0;

    return Container(
      width: summaryWidth,
      constraints: const BoxConstraints(minHeight: 280.0, maxHeight: 320.0),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Take minimum height needed
        children: [
          // Title
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Selected products ($selectedCount)",
              style: const TextStyle(
                fontFamily: redHatDisplayFont,
                fontSize: 22.0, // Slightly smaller to avoid overflow
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16.0),

          // Total Price
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "${selectedTotalPrice.toStringAsFixed(2)} TL",
              style: const TextStyle(
                fontFamily: redHatDisplayFont,
                fontSize: 38.0, // Reduced from 48 to avoid overflow
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16.0),

          // Complete Shopping Button
          SizedBox(
            width: summaryWidth - 32.0, // Adjusted based on container width
            height: 45.0, // Reduced from 50 to fit better
            child: ElevatedButton(
              onPressed: onCompleteShopping,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.zero, // Remove padding to fit text better
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Complete shopping",
                    style: TextStyle(
                      fontFamily: interFont,
                      fontSize:
                          screenWidth < 768
                              ? 18.0
                              : 22.0, // Responsive font size
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          // Bottom summary lines
          _buildSummaryLine(
            "Products",
            "${selectedTotalPrice.toStringAsFixed(2)} TL",
          ),
          const SizedBox(height: 8.0),
          _buildShippingLine(hasSelection, standardShippingCost),
        ],
      ),
    );
  }

  Widget _buildSummaryLine(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: redHatDisplayFont,
            fontSize: 14.0, // Ensure font size is not too large
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: redHatDisplayFont,
            fontSize: 14.0,
            color: Colors.black.withOpacity(0.4),
          ),
        ),
      ],
    );
  }

  Widget _buildShippingLine(bool freeShipping, double cost) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Shipping",
          style: TextStyle(
            fontFamily: redHatDisplayFont,
            fontSize: 14.0,
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        if (freeShipping)
          Row(
            // Free shipping display
            mainAxisSize: MainAxisSize.min, // Ensure it takes minimal space
            children: [
              const Text(
                "Free",
                style: TextStyle(
                  fontFamily: interFont,
                  fontSize: 14, // Reduced from 16
                  color: Color(0xFF008A09),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "${cost.toStringAsFixed(2)} TL",
                style: TextStyle(
                  fontFamily: redHatDisplayFont,
                  fontSize: 14.0,
                  color: Colors.black.withOpacity(0.4),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          )
        else // Standard shipping cost
          Text(
            "${cost.toStringAsFixed(2)} TL",
            style: TextStyle(
              fontFamily: redHatDisplayFont,
              fontSize: 14.0,
              color: Colors.black.withOpacity(0.4),
            ),
          ),
      ],
    );
  }
}
