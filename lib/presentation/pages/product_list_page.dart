import 'package:flutter/material.dart';
import '../../components/icons/index.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const SearchIcon(),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const FavoriteIcon(),
            onPressed: () {
              // TODO: Navigate to favorites
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 10, // Mock product count
        itemBuilder: (context, index) {
          return _buildProductCard(context, index);
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(Icons.image, size: 40, color: Colors.grey),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  onTap: () {
                    // Toggle favorite
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: const FavoriteIcon(color: Colors.grey),
                ),
              ),
            ],
          ),
          // Product details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${(59.99 + index * 10).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                    const SizedBox(width: 2),
                    Text(
                      '${(3 + index % 2).toStringAsFixed(1)} (${10 + index})',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
