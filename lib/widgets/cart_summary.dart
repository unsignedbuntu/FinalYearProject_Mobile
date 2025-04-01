import 'package:flutter/material.dart';

// Define colors and fonts
const Color summaryBg = Color(0xFFD9D9D9); // Web'deki bg-[#D9D9D9]
const Color completeShoppingHoverBg = Color(0xFFFF9D00); // Hover rengi #FF9D00
const Color completeShoppingBg = Colors.white; // Arka plan beyaz
const Color completeShoppingText = Colors.black; // Yazı siyah
const Color freeShippingTextColor = Color(0xFF008A09); // Web'deki renk
const Color summaryTextColor = Color(
  0x66000000,
); // Web'deki text-[#000000] opacity-40
const String ralewayFont = 'Raleway';
const String redHatDisplayFont = 'RedHatDisplay';
const String interFont = 'Inter'; // Web'de buton yazısı için inter kullanılmış

class CartSummary extends StatefulWidget {
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
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    const double summaryWidth = 255.0;
    const double shippingCost = 49.99;
    bool freeShipping = widget.selectedCount > 0;

    return Container(
      width: summaryWidth,
      decoration: BoxDecoration(
        color: summaryBg,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding'i biraz azalttık
        child: Column(
          mainAxisSize: MainAxisSize.min, // İçeriğe göre boyutlan
          children: [
            // Başlık
            Text(
              "Selected products (${widget.selectedCount})",
              style: const TextStyle(
                fontFamily: redHatDisplayFont,
                fontSize: 24.0,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            // Toplam Fiyat
            Text(
              "${widget.selectedTotalPrice.toStringAsFixed(2)} TL",
              style: const TextStyle(
                fontFamily: redHatDisplayFont,
                fontSize: 48.0,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            // Buton - Web'de olduğu gibi hover efektiyle
            MouseRegion(
              onEnter: (_) => setState(() => _isHovering = true),
              onExit: (_) => setState(() => _isHovering = false),
              child: SizedBox(
                width: 230,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: widget.onCompleteShopping,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isHovering
                            ? completeShoppingHoverBg
                            : completeShoppingBg,
                    foregroundColor: completeShoppingText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 0,
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
            ),
            const SizedBox(height: 24.0), // Spacer yerine boşluk ekledik
            // Alt özet kısmı
            Column(
              children: [
                buildSummaryLine(
                  "Products",
                  widget.selectedTotalPrice,
                  textColor: summaryTextColor,
                  amountFont: redHatDisplayFont,
                  labelFont: redHatDisplayFont,
                ),
                const SizedBox(height: 8.0),
                // Shipping satırı - Web'deki gibi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shipping",
                      style: TextStyle(
                        fontFamily: redHatDisplayFont,
                        fontSize: 16.0,
                        color: summaryTextColor,
                      ),
                    ),
                    freeShipping
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Free",
                              style: TextStyle(
                                fontFamily: interFont,
                                fontSize: 16.0,
                                color: freeShippingTextColor,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              "${shippingCost.toStringAsFixed(2)} TL",
                              style: TextStyle(
                                fontFamily: redHatDisplayFont,
                                fontSize: 16.0,
                                color: summaryTextColor,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        )
                        : Text(
                          "${shippingCost.toStringAsFixed(2)} TL",
                          style: TextStyle(
                            fontFamily: redHatDisplayFont,
                            fontSize: 16.0,
                            color: summaryTextColor,
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Alt özet satırları için yardımcı widget
  Widget buildSummaryLine(
    String label,
    double amount, {
    Color? textColor,
    String? labelFont,
    String? amountFont,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: labelFont ?? ralewayFont,
            fontSize: 16.0,
            color: textColor ?? Colors.grey, // Varsayılan gri
          ),
        ),
        Text(
          "${amount.toStringAsFixed(2)} TL",
          style: TextStyle(
            fontFamily: amountFont ?? redHatDisplayFont,
            fontSize: 16.0,
            color:
                textColor ??
                Colors.black.withOpacity(0.8), // Biraz daha görünür
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
