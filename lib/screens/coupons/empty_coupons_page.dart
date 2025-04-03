import 'package:flutter/material.dart';
import 'package:project/widgets/sidebar/siderbar.dart';
import 'package:project/components/icons/coupon.dart';

class EmptyDiscountCouponsPage extends StatelessWidget {
  const EmptyDiscountCouponsPage({Key? key}) : super(key: key);

  // Define a static route name for navigation
  static const String routeName = '/discount-coupons/empty';

  @override
  Widget build(BuildContext context) {
    final double sidebarWidth = 300 + 47 + 24; // Approx width from Sidebar
    final double contentLeftMargin = sidebarWidth + 40; // Margin from Sidebar
    const Color orangeColor = Color(0xFFFF9D00);

    return Scaffold(
      backgroundColor: Colors.white, // Assuming white background
      body: Stack(
        children: [
          const Sidebar(),
          Positioned(
            left: contentLeftMargin,
            top: 160, // pt-[160px]
            right: 40, // Add some right margin
            child: Center(
              // Center the content container
              child: Container(
                width: 835,
                height: 250,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Stack(
                  clipBehavior:
                      Clip.none, // Allow overflow for positioned elements if needed
                  children: [
                    // Coupon Icon
                    Positioned(
                      left: 5,
                      top: 24,
                      child: CouponIcon(
                        width: 64,
                        height: 64,
                        color: orangeColor,
                      ),
                    ),
                    // Main Title
                    Positioned(
                      top: 7,
                      left: 76,
                      child: Text(
                        "You don't have a coupon",
                        style: TextStyle(
                          fontFamily: 'Inter', // Ensure Inter font is available
                          fontSize: 64,
                          fontWeight: FontWeight.normal,
                          color: orangeColor,
                        ),
                      ),
                    ),
                    // Subtitle
                    Positioned(
                      top: 163,
                      left: 147,
                      child: Text(
                        "No coupon found for your account",
                        style: TextStyle(
                          fontFamily: 'Inter', // Ensure Inter font is available
                          fontSize: 36,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87, // Default text color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
