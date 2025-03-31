import 'package:flutter/material.dart';
import 'package:project/models/cart_models.dart'; // Adjust import
import 'package:project/components/icons/bin.dart';
import 'package:project/components/icons/arrow_right.dart';

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
        children: [
          // Supplier Header
          Positioned(
            left: 0,
            top: 3,
            width: 800,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Supplier: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: ralewayFont,
                            ),
                          ),
                          Text(
                            product.supplier,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: ralewayFont,
                              color: supplierColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          ArrowRightIcon(width: 16, height: 16),
                        ],
                      ),
                      if (isSelected)
                        const Text(
                          "Free shipping",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: ralewayFont,
                            color: freeShippingColor,
                          ),
                        ),
                    ],
                  ),
                  const Divider(color: dividerColor, thickness: 0.5),
                ],
              ),
            ),
          ),

          // Checkbox
          Positioned(
            left: 26,
            top: 81,
            child: SizedBox(
              width: 32,
              height: 32,
              child: Checkbox(
                value: isSelected,
                onChanged: onCheckboxChanged,
                activeColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          // Product Image
          Positioned(left: 70, top: 45, child: _buildProductImage()),

          // Product Name
          Positioned(
            left: 180,
            top: 67,
            width: 400,
            child: Text(
              product.name,
              style: const TextStyle(fontSize: 14, fontFamily: ralewayFont),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Controls (Quantity and Price)
          Positioned(
            right: 24,
            top: 67,
            child: Row(
              children: [
                if (product.quantity == 1)
                  Row(
                    children: [
                      _buildQuantityButton(
                        onPressed: () => onQuantityChanged(1),
                        icon: Icons.add,
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: onRemove,
                        child: BinIcon(width: 24, height: 24),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      _buildQuantityButton(
                        onPressed: () => onQuantityChanged(-1),
                        icon: Icons.remove,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "${product.quantity}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: ralewayFont,
                          ),
                        ),
                      ),
                      _buildQuantityButton(
                        onPressed: () => onQuantityChanged(1),
                        icon: Icons.add,
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: onRemove,
                        child: BinIcon(width: 24, height: 24),
                      ),
                    ],
                  ),
                const SizedBox(width: 16),
                Container(
                  width: 95,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${product.price.toStringAsFixed(2)} TL",
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: ralewayFont,
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

  Widget _buildQuantityButton({
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildImageWithFallback(),
      ),
    );
  }

  Widget _buildImageWithFallback() {
    // Önce network image olup olmadığını kontrol et
    if (product.image.startsWith('http')) {
      return Image.network(
        product.image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          );
        },
      );
    } else {
      // Lokal asset
      try {
        return Image.asset(
          product.image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackImage();
          },
        );
      } catch (e) {
        return _buildFallbackImage();
      }
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}
