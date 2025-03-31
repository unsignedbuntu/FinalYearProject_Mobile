import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/models/cart_models.dart'; // Adjust import

// Define fonts and colors
const String ralewayFont = 'Raleway';
const String redHatDisplayFont = 'RedHatDisplay';
const Color paginationTextColor = Color(0xFF5C5C5C);

class CouponOverlay extends StatelessWidget {
  final List<CouponType> coupons;
  final String searchTerm;
  final int currentPage;
  final int totalPages;
  final VoidCallback onClose;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int> onPageChanged; // Change page number
  final ValueChanged<CouponType> onUseCoupon;

  const CouponOverlay({
    super.key,
    required this.coupons,
    required this.searchTerm,
    required this.currentPage,
    required this.totalPages,
    required this.onClose,
    required this.onSearchChanged,
    required this.onPageChanged,
    required this.onUseCoupon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Dimmer
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              color: Colors.black.withOpacity(0.3), // bg-black/30
              // Consider adding BackdropFilter for blur if desired
            ),
          ),
        ),

        // Coupon Content (Positioned top-right like React)
        Positioned(
          top: 16.0, // mt-4 approx
          right: 16.0, // mr-4 approx
          child: Material(
            // Needed for elevation/shadow and InkWell effects
            elevation: 4.0, // shadow-lg
            borderRadius: BorderRadius.circular(8.0), // rounded-lg
            child: Container(
              width: 450.0,
              height: 900.0, // Fixed height
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0), // p-6
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "My Coupons",
                          style:
                              TextStyle(fontFamily: ralewayFont, fontSize: 24),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.grey), // Close icon
                          onPressed: onClose,
                          tooltip: "Close",
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0), // mb-6

                    // Search Input
                    TextField(
                      onChanged: onSearchChanged,
                      // controller: TextEditingController(text: searchTerm), // Use controller if needed
                      decoration: InputDecoration(
                        hintText: "Search by supplier",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        hintStyle:
                            const TextStyle(fontFamily: redHatDisplayFont),
                      ),
                      style: const TextStyle(fontFamily: redHatDisplayFont),
                    ),
                    const SizedBox(height: 24.0), // mb-6

                    // Coupon List Title
                    const Text(
                      "Defined discount codes",
                      style: TextStyle(fontFamily: ralewayFont, fontSize: 18),
                    ),
                    const SizedBox(height: 16.0), // mb-4

                    // Coupon List (Scrollable)
                    Expanded(
                      child: coupons.isEmpty
                          ? const Center(child: Text("No coupons found."))
                          : ListView.separated(
                              itemCount: coupons.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16.0), // space-y-4
                              itemBuilder: (context, index) {
                                final coupon = coupons[index];
                                return _buildCouponItem(context, coupon);
                              },
                            ),
                    ),

                    // Pagination
                    if (totalPages > 1) // Only show if multiple pages
                      _buildPaginationControls(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCouponItem(BuildContext context, CouponType coupon) {
    // Using Stack to overlay content on the Ticket SVG background
    return SizedBox(
      width: 342, // Match SVG width if fixed size is needed
      height: 104, // Match SVG height
      child: Stack(
        children: [
          // Background Ticket SVG
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/icons/ticket.svg', // Your ticket background SVG
              fit: BoxFit.fill, // Ensure it fills the container
            ),
          ),
          // Coupon Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10), // Adjust padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${coupon.amount.toStringAsFixed(0)} TL discount", // Assuming whole TL amount
                        style: const TextStyle(
                          fontSize: 20, // Reduced size slightly
                          fontWeight: FontWeight.bold,
                          fontFamily: redHatDisplayFont,
                        ),
                      ),
                      ElevatedButton(
                        // Use ElevatedButton or TextButton
                        onPressed: () => onUseCoupon(coupon),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          textStyle: const TextStyle(
                              fontFamily: redHatDisplayFont, fontSize: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 1,
                        ),
                        child: const Text("Use"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Minimum limit: ${coupon.limit.toStringAsFixed(0)} TL",
                    style: const TextStyle(
                        fontSize: 12, color: paginationTextColor),
                  ),
                  const Spacer(), // Push bottom content down
                  // Dashed Line (Can be complex, using simple divider for now)
                  const Divider(
                      color: Colors.black,
                      height: 1,
                      thickness: 0.5), // Placeholder
                  const SizedBox(height: 4),
                  Text(
                    "Valid for all products from supplier: ${coupon.supplier}", // Combined text
                    style: const TextStyle(
                        fontSize: 12, color: paginationTextColor),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0), // mt-6
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed:
                currentPage == 1 ? null : () => onPageChanged(currentPage - 1),
            child: const Text("Previous",
                style: TextStyle(fontSize: 14, color: paginationTextColor)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text("Page $currentPage of $totalPages",
                style: const TextStyle(fontSize: 14)),
          ),
          TextButton(
            onPressed: currentPage == totalPages
                ? null
                : () => onPageChanged(currentPage + 1),
            child: const Text("Next",
                style: TextStyle(fontSize: 14, color: paginationTextColor)),
          ),
        ],
      ),
    );
  }
}
