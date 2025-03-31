import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF313131),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          // Top row with logo and newsletter
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo and About section
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Atalay\'s Store Management',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your one-stop shop for all your electronic needs. Quality products, competitive prices, and excellent customer service.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Newsletter signup
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subscribe to our Newsletter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Get the latest updates on new products and special offers.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Your email address',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8CFF75),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            'Subscribe',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Links section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLinkSection(
                  title: 'Shop',
                  links: [
                    'Electronics',
                    'Computers',
                    'Smartphones',
                    'Accessories',
                    'Wearables',
                  ],
                ),
                const SizedBox(width: 24),
                _buildLinkSection(
                  title: 'Information',
                  links: [
                    'About Us',
                    'Contact Us',
                    'FAQ',
                    'Terms & Conditions',
                    'Privacy Policy',
                  ],
                ),
                const SizedBox(width: 24),
                _buildLinkSection(
                  title: 'Customer Service',
                  links: [
                    'My Account',
                    'Order History',
                    'Shipping & Delivery',
                    'Returns',
                    'Help Center',
                  ],
                ),
                const SizedBox(width: 24),
                _buildLinkSection(
                  title: 'Contact',
                  links: [
                    'Email: info@store.com',
                    'Phone: +90 123 456 7890',
                    'Address: Konya, Turkey',
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Bottom bar with copyright and social
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© ${DateTime.now().year} Atalay\'s Store. All rights reserved.',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Row(
                children: [
                  _buildSocialIcon(Icons.facebook, () {}),
                  _buildSocialIcon(Icons.alternate_email, () {}),
                  _buildSocialIcon(Icons.photo_camera, () {}),
                  _buildSocialIcon(Icons.smart_display, () {}),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinkSection({
    required String title,
    required List<String> links,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                link,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.white),
      ),
    );
  }
}
