import 'package:flutter/material.dart';
import 'package:project/components/icons/Vector.dart';
import 'package:project/components/icons/signup.dart';
import 'package:project/components/icons/user_information.dart';
import 'package:project/components/icons/my_reviews.dart'; // Assuming this uses Icons.rate_review
import 'package:project/components/icons/cart.dart';
import 'package:project/components/icons/order.dart'; // Yeni OrderIcon importu
import 'package:project/screens/auth/sign_in_page.dart'; // Assuming this is CartMainIcon
import 'package:project/screens/auth/sign_up_page.dart';
import 'package:project/screens/user_info/user_info_page.dart'; // Import user info page
import 'package:project/screens/my_reviews/my_reviews_page.dart'; // Import reviews page
import 'package:project/screens/orders/my_orders_page.dart'; // Yeni MyOrdersPage importu
//import 'package:project/screens/orders/my_orders_page.dart'; // Import orders page

class SignInOverlay extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onClose;
  // Removed LayerLink as we use fixed positioning now

  const SignInOverlay({super.key, required this.isOpen, required this.onClose});

  @override
  State<SignInOverlay> createState() => _SignInOverlayState();
}

class _SignInOverlayState extends State<SignInOverlay> {
  // State to manage hover effect for menu items
  String? _hoveredItem;

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) return const SizedBox.shrink();

    // Screen size for positioning backdrop
    final Size screenSize = MediaQuery.of(context).size;

    // Renk tanımlamaları
    const Color hoverBorderColor = Color(0xFF9747FF);
    const Color hoverTextColor = Color(0xFF9747FF);
    final Color hoverBackgroundColor = Colors.grey.shade100;
    final Color defaultTextColor = Colors.black87;
    final Color menuBackgroundColor = Colors.white.withOpacity(
      0.75,
    ); // Opaklık güncellendi

    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap:
              widget.onClose, // Close when tapping the transparent background
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            color:
                Colors
                    .transparent, // Make sure background container is transparent
            child: Stack(
              children: [
                // Overlay Content positioned absolutely
                Positioned(
                  top: 160.0, // Fixed position from React code
                  left: 1000.0, // Fixed position from React code
                  child: GestureDetector(
                    onTap:
                        () {}, // Prevent taps inside the menu from closing it
                    child: Container(
                      width: 350.0, // Fixed width
                      height: 460.0, // Fixed height
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Triangle Indicator
                          Positioned(
                            top: -8, // Adjusted slightly for visual positioning
                            left: 350 / 2 - 10, // Centered horizontally
                            child: Transform.rotate(
                              angle:
                                  -0.785, // 45 degrees approx for upward triangle
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: menuBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(
                                        0,
                                        -2,
                                      ), // Shadow upwards
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Main Menu Card
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    menuBackgroundColor, // Opaklık güncellendi
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0), // p-4
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceAround, // space-y-4 approx
                                  children: [
                                    _buildMenuItem(
                                      icon: VectorIcon(width: 72, height: 45),
                                      iconContainerWidth:
                                          90, // Adjusted for centering
                                      title: 'Sign In',
                                      route: SignInPage.routeName,
                                      hoverBorderColor: hoverBorderColor,
                                      hoverTextColor: hoverTextColor,
                                      hoverBackgroundColor:
                                          hoverBackgroundColor,
                                      defaultTextColor: defaultTextColor,
                                    ),
                                    _buildMenuItem(
                                      icon: SignupIcon(width: 90, height: 70),
                                      iconContainerWidth: 90,
                                      title: 'Sign Up',
                                      route: SignUpPage.routeName,
                                      hoverBorderColor: hoverBorderColor,
                                      hoverTextColor: hoverTextColor,
                                      hoverBackgroundColor:
                                          hoverBackgroundColor,
                                      defaultTextColor: defaultTextColor,
                                    ),
                                    _buildMenuItem(
                                      icon: UserInformationIcon(
                                        width: 65,
                                        height: 52,
                                      ),
                                      iconContainerWidth: 90,
                                      title: 'User Information',
                                      route: UserInfoPage.routeName,
                                      hoverBorderColor: hoverBorderColor,
                                      hoverTextColor: hoverTextColor,
                                      hoverBackgroundColor:
                                          hoverBackgroundColor,
                                      defaultTextColor: defaultTextColor,
                                    ),
                                    _buildMenuItem(
                                      icon: MyReviewsIcon(
                                        width: 70,
                                        height: 45,
                                      ),
                                      iconContainerWidth: 90,
                                      title: 'My Reviews',
                                      route: MyReviewsPage.routeName,
                                      hoverBorderColor: hoverBorderColor,
                                      hoverTextColor: hoverTextColor,
                                      hoverBackgroundColor:
                                          hoverBackgroundColor,
                                      defaultTextColor: defaultTextColor,
                                    ),
                                    _buildMenuItem(
                                      icon: OrderIcon(
                                        width: 60, // İkona uygun boyutu ayarla
                                        height: 60,
                                      ),
                                      iconContainerWidth: 90,
                                      title: 'My Orders',
                                      route:
                                          MyOrdersPage.routeName, // Yeni rota
                                      hoverBorderColor: hoverBorderColor,
                                      hoverTextColor: hoverTextColor,
                                      hoverBackgroundColor:
                                          hoverBackgroundColor,
                                      defaultTextColor: defaultTextColor,
                                    ),
                                  ],
                                ),
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
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required Widget icon,
    required double iconContainerWidth,
    required String title,
    required String route,
    required Color hoverBorderColor,
    required Color hoverTextColor,
    required Color hoverBackgroundColor,
    required Color defaultTextColor,
  }) {
    bool isHovered = _hoveredItem == title;
    final String? currentPath =
        ModalRoute.of(context)?.settings.name; // Get current route
    bool isActive = currentPath == route; // Check if the item's route is active

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredItem = title),
      onExit: (_) => setState(() => _hoveredItem = null),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          widget.onClose();
          // Navigate only if the route is different from the current one
          if (!isActive) {
            Navigator.pushNamed(context, route);
          }
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.all(12.0), // p-3
          decoration: BoxDecoration(
            color: isHovered ? hoverBackgroundColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            border:
                isHovered
                    ? Border.all(color: hoverBorderColor, width: 2)
                    : null,
          ),
          child: Row(
            children: [
              Container(
                width: iconContainerWidth,
                alignment: Alignment.center,
                child: icon,
              ),
              const SizedBox(width: 16), // gap-4 approx
              Text(
                title,
                style: TextStyle(
                  fontSize: 18, // text-lg
                  fontWeight: FontWeight.w500, // font-medium
                  color: isHovered ? hoverTextColor : defaultTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
