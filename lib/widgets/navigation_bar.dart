import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      margin: const EdgeInsets.only(top: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildNavigationItem(
              title: 'Stores',
              onTap: () {
                // TODO: Show mega menu or navigate to stores page
              },
            ),

            const SizedBox(width: 25),

            _buildNavigationItem(
              title: 'Loyalty Program',
              onTap: () {
                Navigator.pushNamed(context, '/loyalty-program');
              },
            ),

            const SizedBox(width: 25),

            _buildNavigationItem(
              title: 'KtunGPT',
              onTap: () {
                Navigator.pushNamed(context, '/ktungpt');
              },
            ),

            const SizedBox(width: 25),

            _buildNavigationItem(
              title: 'Support',
              onTap: () {
                Navigator.pushNamed(context, '/support');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 47,
        width:
            title == 'Loyalty Program'
                ? 220
                : title == 'KtunGPT'
                ? 180
                : 160,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 0, 0.35),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Satisfy',
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
            ),

            // Check Icon
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.black.withOpacity(0.7),
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
