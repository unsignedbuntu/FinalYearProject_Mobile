import 'package:flutter/material.dart';
import '../../components/icons/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const Placeholder(), // Temporary placeholder for ProductListPage
    const Placeholder(), // Temporary placeholder for CartPage
    const Placeholder(), // Temporary placeholder for ProfilePage
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KTUN E-Commerce'),
        actions: [
          IconButton(
            icon: const SearchIcon(),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner slider
            _buildBannerSlider(),

            // Categories
            _buildSectionHeader('Categories'),
            _buildCategoriesList(),

            // Featured products
            _buildSectionHeader('Featured Products'),
            _buildProductGrid(context),

            // Special offers
            _buildSectionHeader('Special Offers'),
            _buildSpecialOffers(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    // TODO: Implement a proper carousel slider
    return Container(
      height: 180,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.blue.shade100,
      child: const Center(
        child: Text(
          'Banner Slider Placeholder',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              // TODO: Navigate to see all
            },
            child: const Text('See All'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    final List<Widget> categories = [
      Column(
        children: [
          InkWell(
            onTap: () {
              // TODO: Navigate to electronics category
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.devices, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Electronics', style: TextStyle(fontSize: 12)),
        ],
      ),
      Column(
        children: [
          InkWell(
            onTap: () {
              // TODO: Navigate to fashion category
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.checkroom, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Fashion', style: TextStyle(fontSize: 12)),
        ],
      ),
      Column(
        children: [
          InkWell(
            onTap: () {
              // TODO: Navigate to beauty category
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.face, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Beauty', style: TextStyle(fontSize: 12)),
        ],
      ),
      Column(
        children: [
          InkWell(
            onTap: () {
              // TODO: Navigate to home category
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Home', style: TextStyle(fontSize: 12)),
        ],
      ),
      Column(
        children: [
          InkWell(
            onTap: () {
              // TODO: Navigate to sports category
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.sports_soccer, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Sports', style: TextStyle(fontSize: 12)),
        ],
      ),
      Column(
        children: [
          InkWell(
            onTap: () {
              // TODO: Navigate to books category
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.menu_book, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Books', style: TextStyle(fontSize: 12)),
        ],
      ),
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: categories[index],
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    // Mock product data
    final products = List.generate(
      4,
      (index) => {
        'id': 'product-$index',
        'name': 'Product ${index + 1}',
        'price': 99.99 + (index * 10),
        'imageUrl': 'https://via.placeholder.com/150',
        'isFavorite': index % 2 == 0,
      },
    );

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            // TODO: Navigate to product details
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image with favorite button
                Stack(
                  children: [
                    Container(
                      color: Colors.grey.shade200,
                      width: double.infinity,
                      height: 130,
                      child: Image.network(
                        product['imageUrl'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: () {
                          // TODO: Toggle favorite
                        },
                        borderRadius: BorderRadius.circular(20),
                        child:
                            product['isFavorite'] as bool
                                ? const FavoriteIcon(color: Colors.red)
                                : const FavoriteIcon(color: Colors.grey),
                      ),
                    ),
                  ],
                ),

                // Product info
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${(product['price'] as double).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Add to cart button
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: TextButton.icon(
                        onPressed: () {
                          // TODO: Add to cart functionality
                        },
                        icon: Icon(
                          Icons.add_shopping_cart,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                        label: Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpecialOffers() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors:
                    index % 2 == 0
                        ? [Colors.blue.shade700, Colors.blue.shade300]
                        : [Colors.purple.shade700, Colors.purple.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Special Offer',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get ${20 + (index * 5)}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'On ${index == 0
                          ? 'Electronics'
                          : index == 1
                          ? 'Clothing'
                          : 'Home Appliances'}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to offer details
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor:
                        index % 2 == 0
                            ? Colors.blue.shade700
                            : Colors.purple.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('Shop Now'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Placeholder classes to satisfy the imports until we create them
class Placeholder extends StatelessWidget {
  const Placeholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Placeholder Page - To be implemented')),
    );
  }
}
