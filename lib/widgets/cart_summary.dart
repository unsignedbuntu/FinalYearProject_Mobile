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

    return Container(
      width: 255.0,
      height: 300.0,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9), // bg-[#D9D9D9]
        borderRadius: BorderRadius.circular(8.0), // rounded-lg
        boxShadow: [
          // shadow-lg
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0), // p-4
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween, // Use Spacer for bottom alignment
        children: [
          // Title
          Text(
            "Selected products ($selectedCount)",
            style: const TextStyle(
              fontFamily: redHatDisplayFont,
              fontSize: 24.0,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0), // mb-4

          // Total Price
          Text(
            "${selectedTotalPrice.toStringAsFixed(2)} TL",
            style: const TextStyle(
              fontFamily: redHatDisplayFont,
              fontSize: 48.0,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
              height: 10.0), // Space before button (-mt-4 equivalent)

          // Complete Shopping Button
          SizedBox(
            width: 230.0,
            height: 50.0,
            child: ElevatedButton(
              onPressed: onCompleteShopping,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black, // Default text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // rounded-lg
                ),
                // Add hover simulation if needed
              ),
              child: const Text(
                "Complete shopping",
                style: TextStyle(
                  fontFamily: interFont,
                  fontSize: 24.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),

          const Spacer(), // Pushes the following content to the bottom

          // Bottom summary lines
          _buildSummaryLine(
              "Products", "${selectedTotalPrice.toStringAsFixed(2)} TL"),
          const SizedBox(height: 8.0), // mb-2
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
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: redHatDisplayFont,
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
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        if (freeShipping)
          Row(
            // Free shipping display
            children: [
              const Text(
                "Free",
                style: TextStyle(
                    fontFamily: interFont,
                    fontSize: 16,
                    color: Color(0xFF008A09)),
              ),
              const SizedBox(width: 4),
              Text(
                "${cost.toStringAsFixed(2)} TL",
                style: TextStyle(
                  fontFamily: redHatDisplayFont,
                  color: Colors.black.withOpacity(0.4),
                  decoration: TextDecoration.lineThrough, // line-through
                ),
              ),
            ],
          )
        else // Standard shipping cost
          Text(
            "${cost.toStringAsFixed(2)} TL",
            style: TextStyle(
              fontFamily: redHatDisplayFont,
              color: Colors.black.withOpacity(0.4),
            ),
          ),
      ],
    );
  }
}
