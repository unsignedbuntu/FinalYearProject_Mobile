import 'package:flutter/material.dart';

class SignInOverlay extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;

  const SignInOverlay({super.key, required this.isOpen, required this.onClose});

  @override
  Widget build(BuildContext context) {
    if (!isOpen) return const SizedBox.shrink();

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Transparent overlay for closing
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),

          // Triangle indicator
          Positioned(
            top: 20,
            right: 185,
            child: Transform.rotate(
              angle: 0.785398, // 45 degrees in radians
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Menu container
          Positioned(
            top: 30,
            right: 20,
            child: Container(
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sign In
                    _buildMenuItem(
                      icon: Icons.login,
                      title: 'Sign In',
                      onTap: () {
                        onClose();
                        Navigator.pushNamed(context, '/signin');
                      },
                    ),

                    const SizedBox(height: 16),

                    // Sign Up
                    _buildMenuItem(
                      icon: Icons.person_add,
                      title: 'Sign Up',
                      onTap: () {
                        onClose();
                        Navigator.pushNamed(context, '/sign-up');
                      },
                    ),

                    const SizedBox(height: 16),

                    // User Information
                    _buildMenuItem(
                      icon: Icons.person,
                      title: 'User Information',
                      onTap: () {
                        onClose();
                        Navigator.pushNamed(context, '/user-info');
                      },
                    ),

                    const SizedBox(height: 16),

                    // My Reviews
                    _buildMenuItem(
                      icon: Icons.star,
                      title: 'My Reviews',
                      onTap: () {
                        onClose();
                        Navigator.pushNamed(context, '/my-reviews');
                      },
                    ),

                    const SizedBox(height: 16),

                    // My Orders
                    _buildMenuItem(
                      icon: Icons.shopping_bag,
                      title: 'My Orders',
                      onTap: () {
                        onClose();
                        Navigator.pushNamed(context, '/my-orders');
                      },
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      hoverColor: Colors.grey[100],
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF9747FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: const Color(0xFF9747FF), size: 24),
            ),
            const SizedBox(width: 16),
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
