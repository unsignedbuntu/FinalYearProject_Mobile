import 'package:flutter/material.dart';
import 'package:project/components/icons/user_icon.dart';
import 'package:project/components/icons/favorite_sidebar.dart';
import 'package:project/components/icons/cart_hover.dart';
import 'package:project/components/icons/arrow_right.dart';
import 'package:project/components/icons/group_team_hover.dart';
import 'package:project/widgets/sign_in_overlay.dart';
import 'package:project/widgets/favorite_button.dart';
import 'package:project/widgets/cart_button.dart';
import 'package:project/widgets/sign_in_button.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool _isSignInOpen = false;
  bool _isHoveringSignIn = false;
  bool _isHoveringFavorites = false;
  bool _isHoveringCart = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Logo
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Search Bar
                  Expanded(
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for product, category or brand',
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[700],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Store name
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Atalay's store management platform",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Action Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Sign In Button
                    SignInButton(
                      onTap: () {
                        setState(() {
                          _isSignInOpen = !_isSignInOpen;
                        });
                      },
                    ),

                    const SizedBox(width: 16),

                    // Favorites Button
                    FavoriteButton(
                      onTap: () {
                        Navigator.pushNamed(context, '/favorites');
                      },
                    ),

                    const SizedBox(width: 16),

                    // Cart Button
                    CartButton(
                      onTap: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Sign In Overlay
        if (_isSignInOpen)
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                SignInOverlay(
                  isOpen: _isSignInOpen,
                  onClose: () {
                    setState(() {
                      _isSignInOpen = false;
                    });
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
