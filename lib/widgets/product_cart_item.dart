import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/models/cart_models.dart'; // Adjust import

// Define colors and fonts
const Color itemBg = Color(0xFFD9D9D9);
const Color supplierColor = Color(0xFF00FFB7);
const Color dividerColor = Color(0xFF665F5F);
const Color freeShippingColor = Color(0xFF008A09);
const String ralewayFont = 'Raleway';

class ProductCartItem extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final ValueChanged<bool?> onCheckboxChanged;
  final ValueChanged<int> onQuantityChanged; // +1 or -1
  final VoidCallback onRemove;

  const ProductCartItem({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onCheckboxChanged,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 150,
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        // Using Stack for overlaying elements like in React
        children: [
          // Supplier Header
          Positioned(
            left: 24, // px-6 approx
            right: 24,
            top: 12, // top-3 approx
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      // Supplier info
                      children: [
                        const Text("Supplier: ",
                            style: TextStyle(
                                fontFamily: ralewayFont, fontSize: 16)),
                        Text(product.supplier,
                            style: const TextStyle(
                                fontFamily: ralewayFont,
                                fontSize: 16,
                                color: supplierColor)),
                        const SizedBox(width: 4),
                        SvgPicture.asset('assets/icons/arrow_right.svg',
                            width: 16, height: 16),
                      ],
                    ),
                    if (isSelected) // Show free shipping only if selected
                      const Text(
                        "Free shipping",
                        style: TextStyle(
                            fontFamily: ralewayFont,
                            fontSize: 20,
                            color: freeShippingColor),
                      ),
                  ],
                ),
                const SizedBox(height: 8), // mt-2
                const Divider(color: dividerColor, height: 0.5, thickness: 0.5),
              ],
            ),
          ),

          // Main Content (Checkbox, Image, Name) - Positioned below header
          Positioned(
            left: 20,
            top:
                55, // Estimate top position below header/divider (top-[45px] was from container top)
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align items to top
              children: [
                // Checkbox needs padding/sizing adjustment
                SizedBox(
                  width: 40, // Space for checkbox
                  height: 100, // Match image height roughly
                  child: Checkbox(
                    value: isSelected,
                    onChanged: onCheckboxChanged,
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // Reduce tap area
                    visualDensity: VisualDensity.compact,
                    // Add custom styling if needed
                  ),
                ),
                // Image
                ClipRRect(
                  // For rounded corners on image
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    // Or Image.network if URL
                    product.image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        size: 50), // Placeholder on error
                  ),
                ),
                const SizedBox(width: 16), // ml-4
                // Product Name (Constrained width)
                SizedBox(
                  width: 350, // max-w-[400px] approx, adjusted for space
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontFamily: ralewayFont,
                      fontSize: 14,
                      // height: 1.2, // leading-tight
                    ),
                    maxLines: 4, // Allow multiple lines
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Controls (Quantity, Price, Remove) - Positioned right
          Positioned(
            right: 24, // right-6
            top: 65, // top-[45px] was from container top, adjust vertically
            child: Row(
              children: [
                // Quantity Buttons & Remove
                _buildQuantityControls(),
                const SizedBox(width: 16), // gap-4 approx
                // Price
                Container(
                  width: 95,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Center(
                    child: Text(
                      "${product.price.toStringAsFixed(2)} TL",
                      style: const TextStyle(
                          fontFamily: ralewayFont, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for quantity controls
  Widget _buildQuantityControls() {
    return Row(
      children: [
        // Decrease Button
        SizedBox(
          width: 30,
          height: 30,
          child: Material(
            // For InkWell effect
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => onQuantityChanged(-1),
              child: const Center(child: Text("-")),
            ),
          ),
        ),
        // Quantity or Bin Icon
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8.0), // Spacing around quantity
          child: (product.quantity > 1)
              ? Text(product.quantity.toString())
              : IconButton(
                  // Show Bin icon if quantity is 1
                  icon: SvgPicture.asset('assets/icons/bin.svg',
                      width: 24, height: 24),
                  onPressed: onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(), // Remove default padding
                  tooltip: "Remove",
                ),
        ),
        // Increase Button
        SizedBox(
          width: 30,
          height: 30,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => onQuantityChanged(1),
              child: const Center(child: Text("+")),
            ),
          ),
        ),
        // Always show Bin Icon if quantity > 1 (as per React logic)
        if (product.quantity > 1)
          IconButton(
            icon:
                SvgPicture.asset('assets/icons/bin.svg', width: 24, height: 24),
            onPressed: onRemove,
            padding: const EdgeInsets.only(left: 8.0), // ml-2
            constraints: const BoxConstraints(),
            tooltip: "Remove",
          ),
      ],
    );
  }
}
