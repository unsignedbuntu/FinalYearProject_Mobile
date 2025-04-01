import 'package:flutter/material.dart';
import 'package:project/models/cart_models.dart';
import 'package:project/components/icons/bin.dart';

// Define colors and fonts
const Color itemBg = Color(0xFFF2F2F2);
const Color itemBorder = Color(0xFFDFDFDF);
const Color supplierTextColor = Color(0xFF00B388);
const String ralewayFont = 'Raleway';
const String redHatDisplayFont = 'RedHatDisplay';

class ProductCartItem extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final Function(bool?) onCheckboxChanged;
  final Function(int) onQuantityChanged;
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
    // Web'de fixed genişlik kullanılıyor
    const double itemWidth = 800.0;
    const double imageSize = 120.0;

    return Container(
      width: itemWidth,
      decoration: BoxDecoration(
        color: itemBg,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: itemBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supplier Header
            Row(
              children: [
                Text(
                  "Supplier: ",
                  style: const TextStyle(
                    fontFamily: ralewayFont,
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
                Text(
                  product.supplier,
                  style: const TextStyle(
                    fontFamily: ralewayFont,
                    fontSize: 14.0,
                    color: supplierTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Right aligned delete icon
                InkWell(
                  onTap: onRemove,
                  child: const BinIcon(width: 24, height: 24),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Product Details Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                Checkbox(
                  value: isSelected,
                  onChanged: onCheckboxChanged,
                  activeColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                // Product Image
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, size: 48),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                // Product Name and Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontFamily: ralewayFont,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                // Quantity Controls
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => onQuantityChanged(1),
                      color: Colors.black,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        "${product.quantity}",
                        style: const TextStyle(
                          fontFamily: redHatDisplayFont,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed:
                          product.quantity > 1
                              ? () => onQuantityChanged(-1)
                              : null,
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(width: 16.0),
                // Price
                Text(
                  "${product.price.toStringAsFixed(2)} TL",
                  style: const TextStyle(
                    fontFamily: redHatDisplayFont,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
