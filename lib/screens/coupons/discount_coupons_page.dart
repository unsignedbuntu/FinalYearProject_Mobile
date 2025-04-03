import 'package:flutter/material.dart';
import 'package:project/widgets/sidebar/siderbar.dart';
import 'package:project/components/icons/information.dart';
import 'package:project/components/icons/search.dart';
import 'package:project/components/coupon_card.dart'; // Import the actual CouponCard

// Coupon Model
class Coupon {
  final int id;
  final int amount;
  final int minimumLimit;
  final String validUntil;
  final String supplier;

  Coupon({
    required this.id,
    required this.amount,
    required this.minimumLimit,
    required this.validUntil,
    required this.supplier,
  });
}

// Sample Data (Static for now)
final List<Coupon> _allCoupons = [
  Coupon(
    id: 1,
    amount: 20,
    minimumLimit: 200,
    validUntil: '10 April 2025',
    supplier: 'Trendyol',
  ),
  Coupon(
    id: 2,
    amount: 500,
    minimumLimit: 2700,
    validUntil: '12 April 2025',
    supplier: 'Hepsiburada',
  ),
  Coupon(
    id: 3,
    amount: 250,
    minimumLimit: 1200,
    validUntil: '12 April 2025',
    supplier: 'Amazon',
  ),
  Coupon(
    id: 4,
    amount: 400,
    minimumLimit: 2300,
    validUntil: '12 April 2025',
    supplier: 'N11',
  ),
  Coupon(
    id: 5,
    amount: 100,
    minimumLimit: 500,
    validUntil: '15 May 2025',
    supplier: 'Trendyol',
  ),
  Coupon(
    id: 6,
    amount: 75,
    minimumLimit: 300,
    validUntil: '20 June 2025',
    supplier: 'Amazon',
  ),
  Coupon(
    id: 7,
    amount: 150,
    minimumLimit: 1000,
    validUntil: '30 July 2025',
    supplier: 'Getir',
  ),
];

const int _itemsPerPage = 4;

class DiscountCouponsPage extends StatefulWidget {
  const DiscountCouponsPage({Key? key}) : super(key: key);

  static const String routeName = '/discount-coupons'; // Define route name

  @override
  _DiscountCouponsPageState createState() => _DiscountCouponsPageState();
}

class _DiscountCouponsPageState extends State<DiscountCouponsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Coupon> _filteredCoupons = _allCoupons;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCoupons);
    _filterCoupons(); // Initial filter
  }

  void _filterCoupons() {
    final searchTerm = _searchController.text.toLowerCase();
    setState(() {
      _filteredCoupons =
          _allCoupons
              .where(
                (coupon) => coupon.supplier.toLowerCase().contains(searchTerm),
              )
              .toList();
      _currentPage = 1; // Reset to first page on search
    });
  }

  List<Coupon> _getCurrentPageCoupons() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    if (endIndex > _filteredCoupons.length) {
      endIndex = _filteredCoupons.length;
    }
    if (startIndex >= _filteredCoupons.length) {
      return [];
    }
    return _filteredCoupons.sublist(startIndex, endIndex);
  }

  int _getTotalPages() {
    final total = (_filteredCoupons.length / _itemsPerPage).ceil();
    return total > 0 ? total : 1;
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCoupons);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double sidebarWidth = 300 + 47 + 24;
    final double contentLeftMargin = sidebarWidth + 40;
    final totalPages = _getTotalPages();
    final currentCouponsOnPage = _getCurrentPageCoupons();

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background
      body: Stack(
        children: [
          const Sidebar(),
          Positioned(
            left: contentLeftMargin,
            top: 160, // pt-[160px]
            right: 40, // Add some margin
            bottom: 40, // Add some margin
            child: Container(
              width: 1020, // w-[1020px]
              // height: 750, // Let height be dynamic or use constraints
              padding: const EdgeInsets.all(32.0), // p-8 approximation
              decoration: BoxDecoration(
                color: Colors.white, // bg-[#FFFFFF]
                borderRadius: BorderRadius.circular(8.0), // rounded-lg
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior:
                    Clip.none, // Allow elements outside bounds like title
                children: [
                  // All Coupons Title (Positioned outside the top edge)
                  Positioned(
                    top:
                        -88, // Adjusted for font size and container padding (-44 - p-8 top)
                    left: 0, // Aligned closer to the left edge (was 135 - 32)
                    child: Text(
                      "All coupons",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 64,
                        color: Color(0xFFFF9D00),
                      ),
                    ),
                  ),

                  // Information Text with Icon (Positioned outside top edge)
                  Positioned(
                    top: -88, // approx -51 - p-8 top
                    left: 550, // Moved further right (was 617 - 32)
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ), // Adjust icon vertical alignment
                          child: InformationIcon(
                            color: Color(0xFF5365BF),
                            width: 50,
                            height: 50,
                          ),
                        ),
                        const SizedBox(width: 20), // ml-[70px] approx
                        SizedBox(
                          width: 380, // Constrain text width
                          child: Text(
                            "You can use your coupons in your cart",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 48,
                              color: Color(0xFF5365BF),
                              height: 1.2, // leading-[56px]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main content column inside the white container
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // My Coupons with Count
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                        ), // Adjust spacing
                        child: Row(
                          children: [
                            Text(
                              "My coupons",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 40,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${_filteredCoupons.length})',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 40,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30), // Spacing
                      // Discover Text
                      Text(
                        "All coupons you can discover",
                        style: TextStyle(fontFamily: 'Inter', fontSize: 40),
                      ),
                      const SizedBox(height: 30), // Spacing
                      // Search Input
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search for the coupon provider",
                          hintStyle: TextStyle(
                            fontFamily: 'Red_Hat_Display',
                            fontSize: 24,
                            color: Color(0xFF22262A).withOpacity(0.3),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                          ), // Adjust vertical padding
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 8.0,
                            ),
                            child: SearchIcon(
                              color: Color(0xFF22262A).withOpacity(0.3),
                              width: 28,
                              height: 28,
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'Red_Hat_Display',
                          fontSize: 24,
                          color: Color(0xFF22262A),
                        ),
                      ),
                      const SizedBox(height: 30), // Spacing
                      // Coupons Grid or Message
                      Expanded(
                        child:
                            currentCouponsOnPage.isNotEmpty
                                ? GridView.builder(
                                  itemCount: currentCouponsOnPage.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            3, // Force 3 items per row
                                        mainAxisExtent:
                                            180, // Keep fixed height from user change
                                        crossAxisSpacing:
                                            16.0, // Reduced spacing slightly
                                        mainAxisSpacing:
                                            16.0, // Reduced spacing slightly
                                      ),
                                  itemBuilder: (context, index) {
                                    final coupon = currentCouponsOnPage[index];
                                    // Use the actual CouponCard widget
                                    return CouponCard(
                                      key: ValueKey(
                                        coupon.id,
                                      ), // Add key for better performance
                                      amount: coupon.amount,
                                      minimumLimit: coupon.minimumLimit,
                                      validUntil: coupon.validUntil,
                                      supplier: coupon.supplier,
                                    );
                                  },
                                )
                                : Center(
                                  child: Text(
                                    "No coupons found for the specified provider",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 24,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                      ),
                      const SizedBox(height: 60), // Space before pagination
                    ],
                  ),

                  // Pagination (Positioned at the bottom center)
                  if (totalPages > 1)
                    Positioned(
                      bottom: 10, // bottom-8 approx
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(totalPages, (index) {
                          final page = index + 1;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ), // gap-2
                            child: InkWell(
                              onTap: () => setState(() => _currentPage = page),
                              child: CircleAvatar(
                                radius: 16, // w-8 h-8 -> radius 16
                                backgroundColor:
                                    _currentPage == page
                                        ? Color(0xFFFF9D00)
                                        : Colors.grey.shade300,
                                child: Text(
                                  '$page',
                                  style: TextStyle(
                                    color:
                                        _currentPage == page
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
