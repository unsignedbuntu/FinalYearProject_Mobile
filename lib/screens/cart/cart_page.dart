import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/cart_provider.dart'; // Adjust import path
import 'package:project/models/cart_models.dart'; // Adjust import path
import 'package:project/widgets/product_cart_item.dart'; // Create this widget below
import 'package:project/widgets/cart_summary.dart'; // Create this widget below
import 'package:project/widgets/coupon_overlay.dart'; // Create this widget below
import 'package:project/widgets/sidebar/siderbar.dart'; // Sidebar'ı geri ekliyoruz
import 'package:project/components/icons/coupon.dart';
import 'package:project/components/icons/arrow_right.dart';
import 'package:project/components/icons/bin.dart';
import 'package:project/components/messages/my_cart_message.dart';
import 'package:project/components/messages/complete_shopping_message.dart';

// Define colors and fonts
const Color couponBarBg = Color(0xFFD9D9D9);
const Color couponTextColor = Color(0xFFFF9D00);
const Color deleteTextColor = Color(0xFFFFF600);

const String ralewayFont = 'Raleway';
// Add other fonts (Inter, Red Hat Display) if needed

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  static const String routeName = '/cart'; // Example route name

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;

    // --- Build Undo Message (Example using SnackBar) ---
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cartState.showUndoMessage) {
        // Undo mesajı için MyCartMessage bileşenini kullanma
        // Burada doğrudan SnackBar yerine overlay ekleyebiliriz
        ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Text(
                  cartState.lastRemovedProduct != null
                      ? '"${cartState.lastRemovedProduct!.name}" removed.'
                      : 'Products removed.',
                ),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () => cartNotifier.undoRemove(),
                ),
                duration: const Duration(seconds: 4),
              ),
            )
            .closed
            .then((reason) {
              if (reason != SnackBarClosedReason.action) {
                cartNotifier.dismissUndoMessage();
              }
            });
        ref.read(cartProvider.notifier).state = cartState.copyWith(
          showUndoMessage: false,
        );
      }
      if (cartState.showCompleteShoppingMessage) {
        // Example using AlertDialog
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Select Products"),
                content: const Text(
                  "Please select products before completing shopping.",
                ),
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
        ref.read(cartProvider.notifier).state = cartState.copyWith(
          showCompleteShoppingMessage: false,
        );
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Sidebar - geri eklendi
          const Positioned(left: 47.0, top: 55.0, child: Sidebar()),

          // Main Content - Web'deki gibi konumlandırdık
          Positioned(
            left: 391.0,
            top: 87.0 + 55.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                SizedBox(
                  width: 800,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "My cart (${cartState.products.length} product${cartState.products.length != 1 ? 's' : ''})",
                        style: const TextStyle(
                          fontFamily: ralewayFont,
                          fontSize: 64.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      // Delete Button
                      Row(
                        children: [
                          InkWell(
                            onTap:
                                cartState.products.isEmpty
                                    ? null
                                    : () => cartNotifier.removeAllProducts(),
                            child: Row(
                              children: [
                                Text(
                                  "Delete products",
                                  style: TextStyle(
                                    color: deleteTextColor,
                                    fontFamily: ralewayFont,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                BinIcon(
                                  width: 24,
                                  height: 24,
                                  color: deleteTextColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Coupon Bar - SVG ikonlarını doğru şekilde kullanıyoruz
                Container(
                  width: 800,
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    color: couponBarBg,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CouponIcon(
                            width: 32,
                            height: 32,
                            color: couponTextColor,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            "My coupons",
                            style: TextStyle(
                              fontFamily: ralewayFont,
                              fontSize: 32,
                              color: couponTextColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ArrowRightIcon(width: 32, height: 32),
                        ],
                      ),
                      InkWell(
                        onTap: () => cartNotifier.showCouponOverlay(true),
                        child: const Text(
                          "Add coupon code +",
                          style: TextStyle(
                            fontFamily: ralewayFont,
                            fontSize: 32,
                            color: couponTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Products List
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height -
                      300, // Dinamik yükseklik
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...cartState.products
                            .map(
                              (product) => Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: ProductCartItem(
                                  product: product,
                                  isSelected: cartState.selectedProducts
                                      .contains(product.id),
                                  onCheckboxChanged:
                                      (value) => cartNotifier
                                          .toggleProductSelection(product.id),
                                  onQuantityChanged:
                                      (change) => cartNotifier.changeQuantity(
                                        product.id,
                                        change,
                                      ),
                                  onRemove:
                                      () => cartNotifier.removeProduct(
                                        product.id,
                                      ),
                                ),
                              ),
                            )
                            .toList(),
                        if (cartState.products.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 32.0),
                            child: Center(
                              child: Text(
                                "Your cart is empty",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Selected Products Summary - Web'deki gibi konumlandırıldı
          Positioned(
            right: 372.0,
            top: 205.0,
            child: CartSummary(
              selectedCount: cartState.selectedProducts.length,
              selectedTotalPrice: cartState.selectedTotalPrice,
              onCompleteShopping: () {
                if (cartState.selectedProducts.isEmpty) {
                  cartNotifier.showCompleteShoppingMessage(true);
                } else {
                  Navigator.pushNamed(context, '/payment');
                }
              },
            ),
          ),

          // Messages - MyCartMessage
          if (cartState.showUndoMessage)
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(
                child: MyCartMessage(
                  itemCount: 1,
                  total: cartState.lastRemovedProduct?.price ?? 0,
                  onViewCart: () => cartNotifier.dismissUndoMessage(),
                  onCheckout: () => cartNotifier.undoRemove(),
                ),
              ),
            ),

          // CompleteShoppingMessage
          if (cartState.showCompleteShoppingMessage)
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(
                child: CompleteShoppingMessage(
                  message: "Please select products before completing shopping.",
                  onClose:
                      () => cartNotifier.showCompleteShoppingMessage(false),
                  onComplete: null,
                ),
              ),
            ),

          // Coupon Overlay - Fix arama sorunu
          if (cartState.showCouponOverlay)
            Positioned.fill(
              child: Stack(
                children: [
                  // Background dimmer
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => cartNotifier.showCouponOverlay(false),
                      child: Container(color: Colors.black.withOpacity(0.3)),
                    ),
                  ),
                  // Coupon overlay content
                  Positioned(
                    top: 16.0,
                    right: 16.0,
                    child: CouponOverlay(
                      coupons: cartState.currentCoupons,
                      searchTerm: cartState.couponSearchTerm,
                      currentPage: cartState.couponCurrentPage,
                      totalPages: cartState.totalCouponPages,
                      onClose: () => cartNotifier.showCouponOverlay(false),
                      onSearchChanged: cartNotifier.setCouponSearchTerm,
                      onPageChanged: cartNotifier.changeCouponPage,
                      onUseCoupon: (coupon) {
                        print("Using coupon: ${coupon.code}");
                        cartNotifier.showCouponOverlay(false);
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
