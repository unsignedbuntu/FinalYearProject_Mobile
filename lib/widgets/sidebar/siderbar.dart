import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Define colors for clarity
const Color sidebarBg = Color(0xFFF8F8F8);
const Color itemBg = Colors.white;
const Color hoverColor = Color(
  0xFFFFE8D6,
); // Simulate hover with splash/highlight
const Color activeColor = Color(0xFF00EEFF);
const Color dividerColor =
    Colors.red; // Or Color(0xFFEF4444) for Tailwind's red-500
const Color ktunGptBg = Color.fromRGBO(225, 255, 0, 0.5);
const Color ktunGptText = Color(0xFF4000FF);
const Color defaultTextColor = Colors.black;
const String ralewayFont = 'Raleway';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current route name for active state highlighting
    // This requires you to use named routes
    final String? currentPath = ModalRoute.of(context)?.settings.name;

    // --- Helper Function for Clickable Sidebar Items ---
    Widget buildClickableItem({
      required String iconPath, // Path to your SVG asset
      required String text,
      required String routeName, // The named route to navigate to
      required String? currentPath,
      double iconWidth = 37.0,
      double iconHeight = 37.0,
      Color iconColor = defaultTextColor, // Default icon color
    }) {
      final bool isActive = currentPath == routeName;

      return Material(
        color:
            isActive ? activeColor : itemBg, // Background based on active state
        child: InkWell(
          onTap: () {
            // Navigate only if not already on the page
            if (!isActive) {
              Navigator.pushNamed(context, routeName);
            }
          },
          splashColor: hoverColor.withOpacity(0.5),
          highlightColor: hoverColor.withOpacity(0.3),
          child: Container(
            // Mimic Tailwind's -mx-4 pl-2 => Padding horizontal adjusted
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 8.0,
            ), // p-2 equivalent
            child: Row(
              children: [
                // Icon container (w-[40px] flex justify-start)
                SizedBox(
                  width: 40.0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset(
                      iconPath,
                      width: iconWidth,
                      height: iconHeight,
                      colorFilter: ColorFilter.mode(
                        iconColor,
                        BlendMode.srcIn,
                      ), // Apply color if needed
                      // ignore: deprecated_member_use
                      color:
                          iconColor == defaultTextColor
                              ? null
                              : iconColor, // Older way, might be needed for some SVGs
                    ),
                  ),
                ),
                const SizedBox(width: 8.0), // gap-2 equivalent
                // Text (font-raleway text-[20px] text-black whitespace-nowrap)
                Expanded(
                  // Allow text to take remaining space but prevent overflow issues if needed
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontFamily: ralewayFont,
                      fontSize: 20.0,
                      color: defaultTextColor,
                    ),
                    overflow:
                        TextOverflow.ellipsis, // Handle potential overflow
                    maxLines: 1, // Ensure single line like whitespace-nowrap
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // --- Helper Function for Sections ---
    Widget buildSection({
      required String title,
      required List<Widget> items,
      double containerHeight = 190.0, // Approximate default
    }) {
      return Container(
        // w-[250px] bg-white m-[0_7px_36px_3px] p-4
        // Note: Margins are handled by the parent Column's spacing
        width: 250,
        // height: containerHeight, // Fixed height can cause overflow, consider removing or using IntrinsicHeight
        padding: const EdgeInsets.all(16.0), // p-4
        decoration: BoxDecoration(
          color: itemBg,
          borderRadius: BorderRadius.circular(
            8.0,
          ), // Add some rounding if desired
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize:
              MainAxisSize.min, // Make column take minimum space needed
          children: [
            // Title (w-[115px] h-[28px] font-raleway text-[24px] text-black mb-4)
            Text(
              title,
              style: const TextStyle(
                fontFamily: ralewayFont,
                fontSize: 24.0,
                color: defaultTextColor,
                fontWeight: FontWeight.bold, // Make title bolder
              ),
            ),
            const SizedBox(height: 16.0), // mb-4 (applied after title)
            // Divider (w-[250px] h-[1px] bg-red-500 mb-1 ml-[-16px])
            // Using Divider widget which spans width automatically
            const Divider(
              color: dividerColor,
              height: 1.0, // Controls space around, thickness is thickness
              thickness: 1.0,
            ),
            const SizedBox(height: 4.0), // mb-1 (applied after divider)
            // Items
            ...items,
          ],
        ),
      );
    }

    // --- Main Sidebar Build ---
    return Positioned(
      // style={{ position: 'absolute', left: '47px', top: '55px' }}
      left: 47.0,
      top: 55.0,
      child: Material(
        // Need Material for InkWell effects if sidebarBg isn't standard
        child: Container(
          // className="w-[300px] h-[880px] bg-[#f8f8f8] p-[15px_16px_47px_24px] m-[32px_34px_0_23px]"
          // Note: Margin is complex in Positioned, parent might handle it better. Padding is applied inside.
          width: 300.0,
          height:
              880.0, // Be cautious with fixed heights, might overflow on small screens
          color: sidebarBg,
          // Apply the complex padding
          padding: const EdgeInsets.only(
            top: 15.0,
            right: 16.0,
            bottom: 47.0,
            left: 24.0,
          ),
          child: SingleChildScrollView(
            // Add scroll for safety if height is fixed
            child: Column(
              children: [
                // My Orders Section
                buildSection(
                  title: "My Orders",
                  containerHeight: 190,
                  items: [
                    buildClickableItem(
                      iconPath:
                          'assets/icons/cart.svg', // Replace with actual path
                      text: "My cart",
                      routeName:
                          '/cart', // Named route for cart - kept the same
                      currentPath: currentPath,
                      iconWidth: 48,
                      iconHeight: 34,
                    ),
                    const SizedBox(
                      height: 4,
                    ), // Adjust spacing if needed (like -mt-3)
                    buildClickableItem(
                      iconPath:
                          'assets/icons/my_reviews.svg', // Replace with actual path
                      text: "My reviews",
                      routeName: '/my-reviews', // Your named route
                      currentPath: currentPath,
                      iconWidth: 50,
                      iconHeight: 38,
                    ),
                  ],
                ),
                const SizedBox(height: 36.0), // mb-[36px]
                // Special for you Section
                buildSection(
                  title: "Special for you",
                  containerHeight: 180,
                  items: [
                    buildClickableItem(
                      iconPath:
                          'assets/icons/coupon.svg', // Replace with actual path
                      text: "My discount coupons",
                      routeName: '/discount-coupons', // Your named route
                      currentPath: currentPath,
                    ),
                    const SizedBox(height: 4),
                    buildClickableItem(
                      iconPath:
                          'assets/icons/stores.svg', // Replace with actual path
                      text: "My followed stores",
                      routeName: '/my-followed-stores', // Your named route
                      currentPath: currentPath,
                    ),
                  ],
                ),
                const SizedBox(height: 36.0), // mb-[36px]
                // My Account Section
                buildSection(
                  title: "My Account",
                  containerHeight: 240,
                  items: [
                    buildClickableItem(
                      iconPath:
                          'assets/icons/user_inf_sidebar.svg', // Replace path
                      text: "My user information",
                      routeName: '/user-info', // Your named route
                      currentPath: currentPath,
                    ),
                    const SizedBox(height: 4),
                    buildClickableItem(
                      iconPath: 'assets/icons/address.svg', // Replace path
                      text: "My address information",
                      routeName: '/address-info', // Your named route
                      currentPath: currentPath,
                      iconColor:
                          defaultTextColor, // Explicitly pass default or custom color if needed
                    ),
                    const SizedBox(height: 4),
                    buildClickableItem(
                      iconPath:
                          'assets/icons/favorite_sidebar.svg', // Replace path
                      text: "My favorites",
                      routeName: '/favorites', // Your named route
                      currentPath: currentPath,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 36.0,
                ), // Spacing before KTUNGpt, adjust as needed
                // KTUNGpt Section
                Container(
                  // w-[260px] h-[150px] mx-auto mt-[20px] p-[5px_2px_35px_6px] rounded-lg
                  width: 260.0,
                  padding: const EdgeInsets.only(
                    top: 5.0,
                    left: 6.0,
                    right: 2.0,
                    bottom: 35.0,
                  ),
                  decoration: BoxDecoration(
                    color: ktunGptBg,
                    borderRadius: BorderRadius.circular(8.0), // rounded-lg
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon and Title Row
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align items to the top
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ktun_gpt.svg', // Replace with actual path
                            width: 50.0,
                            height: 50.0,
                            // ignore: deprecated_member_use
                            color:
                                ktunGptText, // Apply color directly if SVG structure allows
                            colorFilter: const ColorFilter.mode(
                              ktunGptText,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8.0), // gap-2
                          // Need Expanded for title if it can be long
                          const Expanded(
                            child: Text(
                              "Ask to KTUNGpt",
                              style: TextStyle(
                                fontFamily: ralewayFont,
                                fontSize: 26.0,
                                color: ktunGptText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0), // mt-6 (adjust value)
                      // Description Text
                      const Text(
                        "I'm always Here! I answer your questions immediately!",
                        style: TextStyle(
                          fontFamily: ralewayFont,
                          fontSize: 16.0,
                          color:
                              defaultTextColor, // Assuming black text? Adjust if needed
                          height: 1.2, // leading-tight approximation
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
