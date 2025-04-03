import 'package:flutter/material.dart';
import 'package:project/models/cart_models.dart'; // Adjust import
import 'package:project/components/icons/ticket.dart'; // Ticket SVG import

// Define fonts and colors
const String ralewayFont = 'Raleway';
const String redHatDisplayFont = 'RedHatDisplay';
const Color paginationTextColor = Color(0xFF5C5C5C);
const Color couponColorGradient1 = Color(0xFFECF0F1);
const Color couponColorGradient2 = Color(0xFFF2F2F2);
const Color supplierColor = Color(0xFF00FFB7);

class CouponOverlay extends StatefulWidget {
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
  State<CouponOverlay> createState() => _CouponOverlayState();
}

class _CouponOverlayState extends State<CouponOverlay> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // Initialize controller with search term
    _searchController = TextEditingController(text: widget.searchTerm);

    // Add listener to detect changes including deletions
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // Make sure we don't call this during dispose
    if (mounted) {
      widget.onSearchChanged(_searchController.text);
    }
  }

  @override
  void didUpdateWidget(CouponOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update controller if searchTerm changed from parent
    if (oldWidget.searchTerm != widget.searchTerm &&
        _searchController.text != widget.searchTerm) {
      _searchController.text = widget.searchTerm;
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Background Dimmer
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        ),

        // Coupon Content - Centered on smaller screens, positioned on larger screens
        Positioned(
          top: screenSize.width < 768 ? 50 : 16.0,
          right: screenSize.width < 768 ? 20 : 16.0,
          left: screenSize.width < 768 ? 20 : null,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: screenSize.width < 768 ? screenSize.width - 40 : 450.0,
              height: screenSize.height * 0.8, // 80% of screen height
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "My Coupons",
                          style: TextStyle(
                            fontFamily: ralewayFont,
                            fontSize: 24,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: widget.onClose,
                          tooltip: "Close",
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),

                    // Search Input - Improved with clear button
                    TextField(
                      controller: _searchController,
                      // No onChanged here, we're using controller listener instead
                      decoration: InputDecoration(
                        hintText: "Search by supplier",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    // No need to call onSearchChanged, the listener will handle it
                                  },
                                )
                                : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        hintStyle: const TextStyle(
                          fontFamily: redHatDisplayFont,
                        ),
                      ),
                      style: const TextStyle(fontFamily: redHatDisplayFont),
                      textInputAction: TextInputAction.search,
                    ),
                    const SizedBox(height: 24.0),

                    // Coupon List Title
                    const Text(
                      "Defined discount codes",
                      style: TextStyle(fontFamily: ralewayFont, fontSize: 18),
                    ),
                    const SizedBox(height: 16.0),

                    // Coupon List (Scrollable)
                    Expanded(
                      child:
                          widget.coupons.isEmpty
                              ? const Center(child: Text("No coupons found."))
                              : ListView.separated(
                                itemCount: widget.coupons.length,
                                separatorBuilder:
                                    (context, index) =>
                                        const SizedBox(height: 16.0),
                                itemBuilder: (context, index) {
                                  final coupon = widget.coupons[index];
                                  return _buildCouponItem(context, coupon);
                                },
                              ),
                    ),

                    // Pagination
                    if (widget.totalPages > 1) _buildPaginationControls(),
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
    return Container(
      width: double.infinity,
      height: 104,
      child: Stack(
        children: [
          // Using the Ticket SVG component as background
          Positioned.fill(child: TicketIcon(width: 342, height: 104)),

          // Coupon Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_offer, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "${coupon.amount.toStringAsFixed(0)} TL discount",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: redHatDisplayFont,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => widget.onUseCoupon(coupon),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        textStyle: const TextStyle(
                          fontFamily: redHatDisplayFont,
                          fontSize: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                    fontSize: 12,
                    color: paginationTextColor,
                  ),
                ),

                // Dashed line
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  child: CustomPaint(
                    size: const Size(double.infinity, 1),
                    painter: DashedLinePainter(),
                  ),
                ),

                Row(
                  children: [
                    const Text(
                      "Valid for all products from supplier: ",
                      style: TextStyle(
                        fontSize: 12,
                        color: paginationTextColor,
                      ),
                    ),
                    Text(
                      coupon.supplier,
                      style: const TextStyle(
                        fontSize: 12,
                        color: supplierColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed:
                widget.currentPage == 1
                    ? null
                    : () => widget.onPageChanged(widget.currentPage - 1),
            child: const Text(
              "Previous",
              style: TextStyle(fontSize: 14, color: paginationTextColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "Page ${widget.currentPage} of ${widget.totalPages}",
              style: const TextStyle(fontSize: 14),
            ),
          ),
          TextButton(
            onPressed:
                widget.currentPage == widget.totalPages
                    ? null
                    : () => widget.onPageChanged(widget.currentPage + 1),
            child: const Text(
              "Next",
              style: TextStyle(fontSize: 14, color: paginationTextColor),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for drawing dashed lines
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 3;

    double startX = 0;
    final double endX = size.width;

    while (startX < endX) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
