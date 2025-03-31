import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/cart_models.dart'; // Adjust import path
import 'package:collection/collection.dart'; // For firstWhereOrNull

// Represents the state of the cart page
class CartState {
  final List<Product> products;
  final List<int> selectedProducts;
  final List<CouponType> coupons; // Assuming coupons are static for now
  final bool showCouponOverlay;
  final bool showUndoMessage;
  final Product? lastRemovedProduct; // For undo functionality
  final bool showCompleteShoppingMessage;
  final int couponCurrentPage;
  final String couponSearchTerm;

  CartState({
    this.products = const [],
    this.selectedProducts = const [],
    this.coupons = const [], // Load initial coupons here or fetch them
    this.showCouponOverlay = false,
    this.showUndoMessage = false,
    this.lastRemovedProduct,
    this.showCompleteShoppingMessage = false,
    this.couponCurrentPage = 1,
    this.couponSearchTerm = "",
  });

  // Helper method for creating a new state object with updated values
  CartState copyWith({
    List<Product>? products,
    List<int>? selectedProducts,
    List<CouponType>? coupons,
    bool? showCouponOverlay,
    bool? showUndoMessage,
    Product? lastRemovedProduct,
    bool? clearLastRemoved, // Flag to explicitly nullify lastRemovedProduct
    bool? showCompleteShoppingMessage,
    int? couponCurrentPage,
    String? couponSearchTerm,
  }) {
    return CartState(
      products: products ?? this.products,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      coupons: coupons ?? this.coupons,
      showCouponOverlay: showCouponOverlay ?? this.showCouponOverlay,
      showUndoMessage: showUndoMessage ?? this.showUndoMessage,
      lastRemovedProduct: clearLastRemoved == true
          ? null
          : lastRemovedProduct ?? this.lastRemovedProduct,
      showCompleteShoppingMessage:
          showCompleteShoppingMessage ?? this.showCompleteShoppingMessage,
      couponCurrentPage: couponCurrentPage ?? this.couponCurrentPage,
      couponSearchTerm: couponSearchTerm ?? this.couponSearchTerm,
    );
  }

  // Calculated properties
  double get selectedTotalPrice => products
      .where((p) => selectedProducts.contains(p.id))
      .fold(0.0, (sum, p) => sum + (p.price * p.quantity));

  List<CouponType> get filteredCoupons => coupons
      .where((coupon) => coupon.supplier
          .toLowerCase()
          .contains(couponSearchTerm.toLowerCase()))
      .toList();

  int get totalCouponPages {
    const couponsPerPage = 4;
    return (filteredCoupons.length / couponsPerPage).ceil();
  }

  List<CouponType> get currentCoupons {
    const couponsPerPage = 4;
    final indexOfLastCoupon = couponCurrentPage * couponsPerPage;
    final indexOfFirstCoupon = indexOfLastCoupon - couponsPerPage;
    // Ensure indices are within bounds
    final start = indexOfFirstCoupon.clamp(0, filteredCoupons.length);
    final end = indexOfLastCoupon.clamp(0, filteredCoupons.length);
    if (start >= end) return []; // Handle edge case where start >= end
    return filteredCoupons.sublist(start, end);
  }
}

// The StateNotifier that manages the CartState
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier()
      : super(CartState(
            // Initialize with sample data like the React component
            products: [
              Product(
                  id: 1,
                  name:
                      "Kaspersky PLUS 2025- 1 User 1 YEAR -INCLUDING UNLIMITED VPN- Official Distributor Guaranteed- IMMEDIATE DELIVERY",
                  supplier: "Aykon informatics",
                  price: 165.00,
                  image: "/images/kaspersky.png", // Assuming image path
                  quantity: 1),
              Product(
                  id: 2,
                  name: "Anatolia 1000 Piece Puzzle / Planets - Code 1033",
                  supplier: "Remzi Bookstore",
                  price: 165.00,
                  image: "/images/puzzle.png", // Assuming image path
                  quantity: 1)
            ],
            coupons: [
              // Sample coupons
              CouponType(
                  code: "AYKON20",
                  amount: 20,
                  limit: 50,
                  supplier: "Aykon Bilişim"),
              CouponType(
                  code: "REMZI20",
                  amount: 20,
                  limit: 50,
                  supplier: "Remzi Kitabevi"),
              // Add more coupons if needed for pagination testing
            ]));

  void toggleProductSelection(int productId) {
    final currentSelection = state.selectedProducts;
    if (currentSelection.contains(productId)) {
      state = state.copyWith(
          selectedProducts:
              currentSelection.where((id) => id != productId).toList());
    } else {
      state =
          state.copyWith(selectedProducts: [...currentSelection, productId]);
    }
  }

  void changeQuantity(int productId, int change) {
    Product? productToUpdate =
        state.products.firstWhereOrNull((p) => p.id == productId);
    if (productToUpdate == null) return;

    final newQuantity = productToUpdate.quantity + change;

    if (newQuantity <= 0) {
      removeProduct(productId); // Remove if quantity reaches zero or less
    } else {
      state = state.copyWith(
        products: state.products
            .map((p) =>
                p.id == productId ? p.copyWith(quantity: newQuantity) : p)
            .toList(),
      );
    }
  }

  void removeProduct(int productId) {
    final productToRemove =
        state.products.firstWhereOrNull((p) => p.id == productId);
    if (productToRemove != null) {
      state = state.copyWith(
          products: state.products.where((p) => p.id != productId).toList(),
          lastRemovedProduct: productToRemove,
          showUndoMessage: true,
          // Also remove from selection if it was selected
          selectedProducts:
              state.selectedProducts.where((id) => id != productId).toList());
      // Consider adding a timer here to auto-dismiss the undo message
    }
  }

  void removeAllSelectedProducts() {
    if (state.selectedProducts.isEmpty) return;
    // Note: The React code seemed to remove *all* products, not just selected
    // Adjusting to remove only selected ones, which seems more logical.
    // If you want to remove *all*, the logic needs change.

    // For undo, storing all removed might be complex.
    // Let's implement remove without undo for this specific action for simplicity.
    // Or store a list of removed products for a more complex undo.
    state = state.copyWith(
      products: state.products
          .where((p) => !state.selectedProducts.contains(p.id))
          .toList(),
      selectedProducts: [], // Clear selection
      // showUndoMessage: true, // Optionally trigger undo for multiple items
      // lastRemovedProduct: null // Handling undo for multiple is tricky
    );
  }

  void removeAllProducts() {
    // Closer to the React button's apparent behavior
    if (state.products.isEmpty) return;
    // Storing *all* products for undo is memory intensive.
    // Let's implement remove without storing *all* for undo.
    // Maybe store just the *first* product as the React code did (though seems odd).
    final firstProduct =
        state.products.isNotEmpty ? state.products.first : null;
    state = state.copyWith(
      products: [],
      selectedProducts: [],
      lastRemovedProduct: firstProduct, // Store only the first for simple undo?
      showUndoMessage:
          firstProduct != null, // Show undo only if cart wasn't already empty
    );
  }

  void undoRemove() {
    if (state.lastRemovedProduct != null) {
      // Check if product already exists (e.g., user added it back manually)
      if (!state.products.any((p) => p.id == state.lastRemovedProduct!.id)) {
        state = state.copyWith(
          products: [...state.products, state.lastRemovedProduct!],
          showUndoMessage: false,
          clearLastRemoved: true, // Use the flag to nullify
        );
      } else {
        // Product somehow already back, just hide message
        state = state.copyWith(showUndoMessage: false, clearLastRemoved: true);
      }
    }
  }

  void dismissUndoMessage() {
    state = state.copyWith(showUndoMessage: false, clearLastRemoved: true);
  }

  void showCouponOverlay(bool show) {
    state = state.copyWith(showCouponOverlay: show);
  }

  void showCompleteShoppingMessage(bool show) {
    state = state.copyWith(showCompleteShoppingMessage: show);
  }

  void setCouponSearchTerm(String term) {
    // Reset page to 1 when search term changes
    state = state.copyWith(couponSearchTerm: term, couponCurrentPage: 1);
  }

  void changeCouponPage(int page) {
    // Ensure page is within valid bounds
    final newPage = page.clamp(1, state.totalCouponPages);
    state = state.copyWith(couponCurrentPage: newPage);
  }
}

// The Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
