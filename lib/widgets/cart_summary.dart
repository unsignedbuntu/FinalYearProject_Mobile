import 'package:flutter/material.dart';

// Define colors and fonts
const Color summaryBg = Color(0xFFF2F2F2);
const Color completeShoppingBg = Color(0xFF141414);
const Color completeShoppingText = Color(0xFFFAFAFA);
const String ralewayFont = 'Raleway';
const String redHatDisplayFont = 'RedHatDisplay';

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
    // Web'de fixed genişlik kullanılıyor, responsive değil
    const double summaryWidth = 255.0;

    return Container(
      width: summaryWidth,
      decoration: BoxDecoration(
        color: summaryBg,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Selected products (${selectedCount})",
                style: const TextStyle(
                  fontFamily: ralewayFont,
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24.0),
            Center(
              child: Text(
                "${selectedTotalPrice.toStringAsFixed(2)} TL",
                style: const TextStyle(
                  fontFamily: redHatDisplayFont,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: onCompleteShopping,
                style: ElevatedButton.styleFrom(
                  backgroundColor: completeShoppingBg,
                  foregroundColor: completeShoppingText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Complete shopping",
                  style: TextStyle(fontFamily: ralewayFont, fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            buildSummaryLine("Products", selectedTotalPrice),
            const SizedBox(height: 8.0),
            buildSummaryLine("Shipping", 49.99),
          ],
        ),
      ),
    );
  }

  Widget buildSummaryLine(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: ralewayFont,
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        Text(
          "${amount.toStringAsFixed(2)} TL",
          style: const TextStyle(
            fontFamily: redHatDisplayFont,
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
