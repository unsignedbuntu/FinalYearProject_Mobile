import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/providers/cart_provider.dart'; // Adjust import path
import 'package:project/widgets/sidebar/siderbar.dart'; // Adjust import path
import 'package:project/models/cart_models.dart'; // Adjust import path
import 'package:project/widgets/product_cart_item.dart'; // Create this widget below
import 'package:project/widgets/cart_summary.dart'; // Create this widget below
import 'package:project/widgets/coupon_overlay.dart'; // Create this widget below

// Define colors and fonts
const Color couponBarBg = Color(0xFFD9D9D9);
const Color couponTextColor = Color(0xFFFF9D00);
const Color deleteTextColor =
    Color(0xFFFFF600); // Note: Yellow text might have contrast issues

const String ralewayFont = 'Raleway';
// Add other fonts (Inter, Red Hat Display) if needed

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  static const String routeName = '/cart'; // Example route name

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    // --- Build Undo Message (Example using SnackBar) ---
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cartState.showUndoMessage) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Text(cartState.lastRemovedProduct != null
                    ? '"${cartState.lastRemovedProduct!.name}" removed.'
                    : 'Products removed.'),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () => cartNotifier.undoRemove(),
                ),
                duration: const Duration(seconds: 4), // Auto-dismiss
              ),
            )
            .closed
            .then((reason) {
          // If dismissed naturally (not by UNDO), clear the flag
          if (reason != SnackBarClosedReason.action) {
            cartNotifier.dismissUndoMessage();
          }
        });
        // Reset flag immediately after triggering SnackBar to prevent multiple SnackBars
        ref.read(cartProvider.notifier).state =
            cartState.copyWith(showUndoMessage: false);
      }
      if (cartState.showCompleteShoppingMessage) {
        // Example using AlertDialog
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Select Products"),
            content: const Text(
                "Please select products before completing shopping."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  cartNotifier.showCompleteShoppingMessage(false);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
        // Reset flag immediately
        ref.read(cartProvider.notifier).state =
            cartState.copyWith(showCompleteShoppingMessage: false);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Sidebar
          const Positioned(
            left: 47.0,
            top: 55.0,
            child: Sidebar(),
          ),

          // Main Content Area (using Padding/Column instead of strict Positioned)
          Positioned(
            left: 391.0,
            top: 87.0 +
                55.0, // Adjust top based on actual layout needs (e.g., AppBar height)
            right: 372.0 + 255.0 + 20.0, // Space for summary + gap
            bottom: 0, // Allow list to scroll
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0), // mb-8 approx
                  child: Row(
                    // Use Row for alignment
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "My cart (${cartState.products.length} product${cartState.products.length != 1 ? 's' : ''})",
                        style: const TextStyle(
                          fontFamily: ralewayFont,
                          fontSize:
                              64.0, // Be careful with very large fonts on mobile
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      // Delete Button (Positioned relatively within the Row space)
                      // This positioning was absolute in React, might need adjustment
                      TextButton.icon(
                        onPressed: cartState.products.isEmpty
                            ? null // Disable if cart is empty
                            : () => cartNotifier
                                .removeAllProducts(), // Use the function matching React's apparent behavior
                        icon: SvgPicture.asset(
                          'assets/icons/bin.svg',
                          width: 24, height: 24, color: deleteTextColor,
                          // ignore: deprecated_member_use
                          colorBlendMode: BlendMode.srcIn,
                        ),
                        label: const Text(
                          "Delete products", // Consider "Delete all products" for clarity
                          style: TextStyle(
                            color: deleteTextColor,
                            fontFamily: ralewayFont,
                            fontSize: 24,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // Adjust padding if needed
                        ),
                      )
                    ],
                  ),
                ),

                // Coupon Bar
                Container(
                  width: 800, // Fixed width from React
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0), // px-6
                  decoration: BoxDecoration(
                    color: couponBarBg,
                    borderRadius: BorderRadius.circular(8.0), // rounded-lg
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/coupon.svg',
                            width: 32,
                            height: 32,
                            color: couponTextColor,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                          const SizedBox(width: 16), // gap-4
                          const Text(
                            "My coupons",
                            style: TextStyle(
                                fontFamily: ralewayFont,
                                fontSize: 32,
                                color: couponTextColor),
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.asset('assets/icons/arrow_right.svg',
                              width: 32,
                              height: 32,
                              color: Colors.black), // Assuming black arrow
                        ],
                      ),
                      TextButton(
                        onPressed: () => cartNotifier.showCouponOverlay(true),
                        child: const Text(
                          "Add coupon code +",
                          style: TextStyle(
                            fontFamily: ralewayFont,
                            fontSize: 32,
                            color: couponTextColor,
                          ),
                        ),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                    height:
                        20), // Spacing before product list mt-[100px] was large

                // Products List
                Expanded(
                  // Make list scrollable within the available space
                  child: ListView.builder(
                    itemCount: cartState.products.length,
                    itemBuilder: (context, index) {
                      final product = cartState.products[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0), // mb-4
                        child: ProductCartItem(
                          // Use the custom widget
                          product: product,
                          isSelected:
                              cartState.selectedProducts.contains(product.id),
                          onCheckboxChanged: (value) =>
                              cartNotifier.toggleProductSelection(product.id),
                          onQuantityChanged: (change) =>
                              cartNotifier.changeQuantity(product.id, change),
                          onRemove: () =>
                              cartNotifier.removeProduct(product.id),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Selected Products Summary (Positioned absolutely on the right)
          Positioned(
            // style={{width: '255px', height: '300px', right: '372px', top: '205px'}}
            right: 372.0,
            top: 205.0 + 55.0, // Adjust top
            child: CartSummary(
                // Use the custom widget
                selectedCount: cartState.selectedProducts.length,
                selectedTotalPrice: cartState.selectedTotalPrice,
                onCompleteShopping: () {
                  if (cartState.selectedProducts.isEmpty) {
                    cartNotifier.showCompleteShoppingMessage(true);
                  } else {
                    Navigator.pushNamed(
                        context, '/payment'); // Navigate to payment
                  }
                }),
          ),

          // Coupon Overlay (Conditionally rendered on top)
          if (cartState.showCouponOverlay)
            Positioned.fill(
              // Covers the whole screen
              child: CouponOverlay(
                // Use the custom widget
                coupons: cartState.currentCoupons,
                searchTerm: cartState.couponSearchTerm,
                currentPage: cartState.couponCurrentPage,
                totalPages: cartState.totalCouponPages,
                onClose: () => cartNotifier.showCouponOverlay(false),
                onSearchChanged: cartNotifier.setCouponSearchTerm,
                onPageChanged: cartNotifier.changeCouponPage,
                onUseCoupon: (coupon) {
                  // Add logic to apply coupon
                  print("Using coupon: ${coupon.code}");
                  cartNotifier
                      .showCouponOverlay(false); // Close overlay after use
                },
              ),
            ),
        ],
      ),
    );
  }
}
