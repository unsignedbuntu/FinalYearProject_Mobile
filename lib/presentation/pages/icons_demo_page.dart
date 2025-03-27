import 'package:flutter/material.dart';
import '../../components/icons/index.dart';

class IconsDemoPage extends StatelessWidget {
  const IconsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icons Demo'),
        actions: [IconButton(icon: const FavoriteIcon(), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Examples
            _buildSectionTitle('Icon Examples'),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildIconWithLabel(const StoresIcon(), 'Stores'),
                _buildIconWithLabel(const SearchIcon(), 'Search'),
                _buildIconWithLabel(const CartIcon(), 'Cart'),
                _buildIconWithLabel(const FavoriteIcon(), 'Favorite'),
                _buildIconWithLabel(const SignupIcon(), 'Signup'),
                _buildIconWithLabel(const UserInformationIcon(), 'User Info'),
              ],
            ),
            const SizedBox(height: 24),

            // Additional Icons
            _buildSectionTitle('Additional Icons'),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildIconWithLabel(
                  const TicIcon(
                    backgroundColor: Colors.blue,
                    strokeColor: Colors.white,
                  ),
                  'Tic Icon',
                ),
                _buildIconWithLabel(const TicHoverIcon(), 'Tic Hover'),
                _buildIconWithLabel(const TickGreenIcon(), 'Tick Green'),
                _buildIconWithLabel(
                  const MyReviewsIcon(color: Colors.deepOrange),
                  'My Reviews',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // More Icons
            _buildSectionTitle('More Icons'),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const TicketHourIcon(width: 24, height: 40),
                  const SizedBox(width: 16),
                  const TicketLineIcon(width: 100, height: 2),
                  const SizedBox(width: 16),
                  const UsernameIcon(width: 40, height: 40),
                  const SizedBox(width: 16),
                  const VectorIcon(width: 60, height: 40),
                  const SizedBox(width: 16),
                  const UserInfSidebarIcon(width: 40, height: 40),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildIconWithLabel(Widget icon, String label) {
    return Column(
      children: [
        icon,
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
