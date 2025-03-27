import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user data
    final userData = {
      'name': 'John Doe',
      'email': 'johndoe@example.com',
      'phone': '+90 555 123 4567',
      'image': 'https://via.placeholder.com/150',
      'orders': 5,
      'wishlist': 12,
      'reviews': 3,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildUserHeader(context, userData),
            const SizedBox(height: 24),
            _buildStatsRow(userData),
            const SizedBox(height: 24),
            _buildMenuSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, Map<String, dynamic> user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey.shade200,
          child: const Icon(Icons.person, size: 50, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Text(
          user['name'] as String,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          user['email'] as String,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          user['phone'] as String,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            // TODO: Navigate to edit profile
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          ),
          child: const Text('Edit Profile'),
        ),
      ],
    );
  }

  Widget _buildStatsRow(Map<String, dynamic> user) {
    return Builder(
      builder:
          (context) => Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  context: context,
                  icon: Icons.shopping_bag_outlined,
                  value: user['orders'] as int,
                  label: 'Orders',
                ),
                _buildStatItem(
                  context: context,
                  icon: Icons.favorite_border,
                  value: user['wishlist'] as int,
                  label: 'Wishlist',
                ),
                _buildStatItem(
                  context: context,
                  icon: Icons.star_border,
                  value: user['reviews'] as int,
                  label: 'Reviews',
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required int value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        const SizedBox(height: 8),
        Text(
          '$value',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.shopping_bag_outlined,
        'title': 'My Orders',
        'subtitle': 'View your order history',
      },
      {
        'icon': Icons.location_on_outlined,
        'title': 'Shipping Addresses',
        'subtitle': 'Manage your shipping addresses',
      },
      {
        'icon': Icons.payment_outlined,
        'title': 'Payment Methods',
        'subtitle': 'Manage your payment methods',
      },
      {
        'icon': Icons.favorite_border,
        'title': 'My Wishlist',
        'subtitle': 'View your favorite products',
      },
      {
        'icon': Icons.star_border,
        'title': 'My Reviews',
        'subtitle': 'View your product reviews',
      },
      {
        'icon': Icons.help_outline,
        'title': 'Help & Support',
        'subtitle': 'Get help and contact us',
      },
      {
        'icon': Icons.logout,
        'title': 'Logout',
        'subtitle': 'Sign out from your account',
        'isLogout': true,
      },
    ];

    return Column(
      children: [
        for (final item in menuItems)
          _buildMenuItem(
            context,
            icon: item['icon'] as IconData,
            title: item['title'] as String,
            subtitle: item['subtitle'] as String,
            isLogout: item['isLogout'] as bool? ?? false,
          ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isLogout ? Colors.red : null,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Navigate to the respective page
        },
      ),
    );
  }
}
