import 'package:flutter/material.dart';
import 'package:project/components/icons/cart.dart';
import 'package:project/components/icons/my_reviews.dart';
import 'package:project/components/icons/coupon.dart';
import 'package:project/components/icons/stores.dart';
import 'package:project/components/icons/user_inf_sidebar.dart';
import 'package:project/components/icons/address.dart';
import 'package:project/components/icons/favorite_sidebar.dart';
import 'package:project/components/icons/ktun_gpt.dart';

// Define colors for clarity
const Color sidebarBg = Color(0xFFF8F8F8);
const Color itemBg = Colors.white;
const Color hoverColor = Color(0xFFFFE8D6); // Web'deki hover rengi
const Color activeColor = Color(0xFF00EEFF);
const Color dividerColor = Colors.red;
const Color ktunGptBg = Color.fromRGBO(225, 255, 0, 0.5);
const Color ktunGptText = Color(0xFF4000FF);
const Color defaultTextColor = Colors.black;
const String ralewayFont = 'Raleway';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentPath = ModalRoute.of(context)?.settings.name;

    Widget buildClickableItem({
      required Widget icon,
      required String text,
      required String routeName,
      required String? currentPath,
    }) {
      final bool isActive = currentPath == routeName;

      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Material(
          color: isActive ? activeColor : itemBg,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: () {
              if (!isActive) {
                Navigator.pushNamed(context, routeName);
              }
            },
            hoverColor: hoverColor,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 2.0,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 40.0,
                    child: Align(alignment: Alignment.centerLeft, child: icon),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontFamily: ralewayFont,
                        fontSize: 20.0,
                        color: defaultTextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget buildSection({required String title, required List<Widget> items}) {
      return Container(
        width: 250,
        margin: const EdgeInsets.only(bottom: 36.0, left: 3.0, right: 7.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: itemBg,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: ralewayFont,
                fontSize: 24.0,
                color: defaultTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Divider offsetting outside the container
                Positioned(
                  left: -16.0,
                  right: 0,
                  child: Container(
                    height: 1.0,
                    width: 250.0,
                    color: dividerColor,
                  ),
                ),
                // Content that will have negative margin for hover effect
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      items
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(
                                top: 4.0,
                                bottom: 4.0,
                              ),
                              child: item,
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Positioned(
      left: 47.0,
      top: 55.0,
      child: Container(
        width: 300.0,
        height: 880.0,
        color: sidebarBg,
        padding: const EdgeInsets.only(
          top: 15.0,
          right: 16.0,
          bottom: 47.0,
          left: 24.0,
        ),
        margin: const EdgeInsets.fromLTRB(23, 32, 34, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSection(
                title: "My Orders",
                items: [
                  buildClickableItem(
                    icon: const CartMainIcon(width: 48, height: 34),
                    text: "My cart",
                    routeName: '/cart',
                    currentPath: currentPath,
                  ),
                  buildClickableItem(
                    icon: const MyReviewsIcon(width: 50, height: 38),
                    text: "My reviews",
                    routeName: '/my-reviews',
                    currentPath: currentPath,
                  ),
                ],
              ),
              buildSection(
                title: "Special for you",
                items: [
                  buildClickableItem(
                    icon: const CouponIcon(width: 37, height: 37),
                    text: "My discount coupons",
                    routeName: '/discount-coupons',
                    currentPath: currentPath,
                  ),
                  buildClickableItem(
                    icon: const StoresIcon(width: 37, height: 37),
                    text: "My followed stores",
                    routeName: '/my-followed-stores',
                    currentPath: currentPath,
                  ),
                ],
              ),
              buildSection(
                title: "My Account",
                items: [
                  buildClickableItem(
                    icon: const UserInfSidebarIcon(width: 37, height: 37),
                    text: "My user information",
                    routeName: '/user-info',
                    currentPath: currentPath,
                  ),
                  buildClickableItem(
                    icon: const AddressIcon(width: 37, height: 37),
                    text: "My address information",
                    routeName: '/address-info',
                    currentPath: currentPath,
                  ),
                  buildClickableItem(
                    icon: const FavoriteSidebarIcon(width: 37, height: 37),
                    text: "My favorites",
                    routeName: '/favorites',
                    currentPath: currentPath,
                  ),
                ],
              ),
              Container(
                width: 260.0,
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.fromLTRB(6, 5, 2, 35),
                decoration: BoxDecoration(
                  color: ktunGptBg,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KtunGptIcon(
                          width: 50.0,
                          height: 50.0,
                          color: ktunGptText,
                        ),
                        const SizedBox(width: 8.0),
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
                    const SizedBox(height: 24.0),
                    const Text(
                      "I'm always Here! I answer your questions immediately!",
                      style: TextStyle(
                        fontFamily: ralewayFont,
                        fontSize: 16.0,
                        color: defaultTextColor,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
