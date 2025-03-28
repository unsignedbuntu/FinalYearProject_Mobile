import 'package:flutter/material.dart';

class SignInOverlay extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;

  const SignInOverlay({super.key, required this.isOpen, required this.onClose});

  @override
  Widget build(BuildContext context) {
    if (!isOpen) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onClose,
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Dialog position
            Positioned(
              top: 60,
              right: 20,
              child: GestureDetector(
                onTap: () {},
                child: Material(
                  color: Colors.transparent,
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMenuItem(
                          context: context,
                          title: 'Sign In',
                          icon: Icons.login,
                          onTap: () {
                            onClose();
                            Navigator.pushNamed(context, '/signin');
                          },
                        ),

                        _buildMenuItem(
                          context: context,
                          title: 'Sign Up',
                          icon: Icons.person_add,
                          onTap: () {
                            onClose();
                            Navigator.pushNamed(context, '/sign-up');
                          },
                        ),

                        _buildMenuItem(
                          context: context,
                          title: 'User Information',
                          icon: Icons.person,
                          onTap: () {
                            onClose();
                            Navigator.pushNamed(context, '/user-info');
                          },
                        ),

                        _buildMenuItem(
                          context: context,
                          title: 'My Reviews',
                          icon: Icons.star,
                          onTap: () {
                            onClose();
                            Navigator.pushNamed(context, '/my-reviews');
                          },
                        ),

                        _buildMenuItem(
                          context: context,
                          title: 'My Orders',
                          icon: Icons.shopping_bag,
                          onTap: () {
                            onClose();
                            Navigator.pushNamed(context, '/my-orders');
                          },
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          border:
              !isLast
                  ? Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  )
                  : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF9747FF), size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
