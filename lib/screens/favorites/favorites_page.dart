import 'package:flutter/material.dart';
import 'package:project/widgets/sidebar/siderbar.dart';
import 'package:project/screens/favorites/empty_favorites.dart';
import 'package:project/components/messages/favorites_header.dart';
import 'package:project/components/icons/arrowdown.dart';
import 'package:project/components/messages/cart_success_message.dart';
import 'package:project/models/product.dart'; // Ana Product modelini import edelim
import 'package:project/components/icons/menu.dart';
import 'package:project/components/icons/cart_favorites.dart';
import 'package:go_router/go_router.dart'; // GoRouter importu

// Favorites sayfası için Product sınıfını genişletelim
class FavoriteProduct extends Product {
  final bool inStock;
  final DateTime addedDate; // favorilere eklenme tarihi

  FavoriteProduct({
    required super.id,
    required super.name,
    super.description,
    required super.price,
    super.imageUrl,
    required super.isActive,
    required super.createdAt,
    super.updatedAt,
    super.storeId,
    super.categoryId,
    required this.inStock,
    required this.addedDate,
  });

  // Product'tan FavoriteProduct oluşturan factory constructor
  factory FavoriteProduct.fromProduct(
    Product product, {
    required bool inStock,
    DateTime? addedDate,
  }) {
    return FavoriteProduct(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isActive: product.isActive,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      storeId: product.storeId,
      categoryId: product.categoryId,
      inStock: inStock,
      addedDate: addedDate ?? DateTime.now(),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  static const String routeName = '/favorites';

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool _isSortOpen = false;
  String _sortType = 'default';
  bool _showInStock = true;
  bool _showMoveToList = false;
  bool _showListSelection = false;
  bool _showCartSuccess = false;

  // Örnek veri
  List<FavoriteProduct> _favoriteProducts = [
    FavoriteProduct(
      id: 1,
      name: "Nike Red Shoes",
      price: 299.99,
      imageUrl: "/slider/1000_F_46594969_DDZUkjGFtkv0jDMG7676blspQlgOkf1n.jpg",
      isActive: true,
      createdAt: DateTime(2024, 1, 1),
      inStock: true,
      addedDate: DateTime(2024, 1, 1),
    ),
    FavoriteProduct(
      id: 2,
      name: "Space View",
      price: 199.99,
      imageUrl: "/slider/1000_F_139838537_ahJnL2GCKQviBW9JWjpUq4q8GlgRcwU3.jpg",
      isActive: true,
      createdAt: DateTime(2024, 1, 2),
      inStock: true,
      addedDate: DateTime(2024, 1, 2),
    ),
    FavoriteProduct(
      id: 3,
      name: "Adidas Superstar",
      price: 399.99,
      imageUrl: "", // Empty URL for placeholder
      isActive: true,
      createdAt: DateTime(2024, 1, 3),
      inStock: true,
      addedDate: DateTime(2024, 1, 3),
    ),
    FavoriteProduct(
      id: 4,
      name: "Adidas Superstar",
      price: 399.99,
      imageUrl: "", // Empty URL for placeholder
      isActive: true,
      createdAt: DateTime(2024, 1, 4),
      inStock: true,
      addedDate: DateTime(2024, 1, 4),
    ),
    FavoriteProduct(
      id: 5,
      name: "Adidas Superstar",
      price: 399.99,
      imageUrl: "", // Empty URL for placeholder
      isActive: true,
      createdAt: DateTime(2024, 1, 5),
      inStock: true,
      addedDate: DateTime(2024, 1, 5),
    ),
    FavoriteProduct(
      id: 6,
      name: "Adidas Superstar",
      price: 399.99,
      imageUrl: "", // Empty URL for placeholder
      isActive: true,
      createdAt: DateTime(2024, 1, 5),
      inStock: true,
      addedDate: DateTime(2024, 1, 5),
    ),
    FavoriteProduct(
      id: 7,
      name: "Adidas Superstar",
      price: 399.99,
      imageUrl: "", // Empty URL for placeholder
      isActive: true,
      createdAt: DateTime(2024, 1, 5),
      inStock: true,
      addedDate: DateTime(2024, 1, 5),
    ),
  ];

  // Sıralama fonksiyonu
  void _handleSort(String type) {
    List<FavoriteProduct> sorted = List.from(_favoriteProducts);

    switch (type) {
      case 'price-high':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'price-low':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'oldest':
        sorted.sort((a, b) => a.addedDate.compareTo(b.addedDate));
        break;
      case 'newest':
        sorted.sort((a, b) => b.addedDate.compareTo(a.addedDate));
        break;
      case 'name-asc':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name-desc':
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
    }

    setState(() {
      _favoriteProducts = sorted;
      _sortType = type;
    });
  }

  // Sepete ekleme başarılı mesajı
  void _handleCartSuccess() {
    setState(() {
      _showCartSuccess = true;
    });

    // 2 saniye sonra ListSelectionOverlay'i göster
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showCartSuccess = false;
        // _showListSelection = true; // You might need this later
      });
    });
  }

  // Ürünü listeden kaldır
  void _handleMoveToList(int productId, int listId) {
    setState(() {
      // Ürünü eski listeden kaldır
      _favoriteProducts.removeWhere((p) => p.id == productId);
    });
  }

  // Ürünü görüntüle
  void _handleViewProduct(String id) {
    context.push('/product/$id'); // GoRouter ile değiştirildi
  }

  // Ürünü kaldır
  void _handleRemoveProduct(String id) {
    setState(() {
      _favoriteProducts.removeWhere((p) => p.id.toString() == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Ürünler yoksa EmptyFavorites göster
    if (_favoriteProducts.isEmpty) {
      return Scaffold(
        body: Stack(
          children: [const Sidebar(), Center(child: EmptyFavorites())],
        ),
      );
    }

    // Ürünler varsa ana sayfayı göster
    return Scaffold(
      body: Stack(
        children: [
          const Sidebar(),
          Positioned(
            left: 480,
            top: 160,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // Başlık ve Sıralama Bölümü (Header now Flexible)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Wrap FractionallySizedBox in Flexible to constrain width properly
                        Flexible(
                          child: FractionallySizedBox(
                            widthFactor:
                                0.7, // Adjust this factor (e.g., 0.6 for 60%)
                            alignment: Alignment.centerLeft,
                            child: FavoritesHeader(
                              itemCount: _favoriteProducts.length,
                              onClearAll: () {
                                setState(() {
                                  _favoriteProducts.clear();
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ), // Keep space between header and Sort section
                        // Sort section (remains the same)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Sort",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 36,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              width: 200,
                              height: 75,
                              child: PopupMenuButton<String>(
                                offset: const Offset(0, 75),
                                onSelected: (value) {
                                  _handleSort(value);
                                  setState(() {
                                    _isSortOpen = false;
                                  });
                                },
                                onCanceled: () {
                                  setState(() {
                                    _isSortOpen = false;
                                  });
                                },
                                itemBuilder:
                                    (context) => [
                                      PopupMenuItem(
                                        value: 'default',
                                        child: _buildSortMenuItem(
                                          'default',
                                          'Default',
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'price-high',
                                        child: _buildSortMenuItem(
                                          'price-high',
                                          'Price (High-Low)',
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'price-low',
                                        child: _buildSortMenuItem(
                                          'price-low',
                                          'Price (Low-High)',
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'newest',
                                        child: _buildSortMenuItem(
                                          'newest',
                                          'Newest First',
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'oldest',
                                        child: _buildSortMenuItem(
                                          'oldest',
                                          'Oldest First',
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'name-asc',
                                        child: _buildSortMenuItem(
                                          'name-asc',
                                          'Name (A-Z)',
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'name-desc',
                                        child: _buildSortMenuItem(
                                          'name-desc',
                                          'Name (Z-A)',
                                        ),
                                      ),
                                    ],
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _getSortTypeName(),
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 32,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFFFF8800),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const ArrowdownIcon(
                                        width: 13,
                                        height: 8,
                                        color: Color(0xFFFF8800),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Ana İçerik Alanı
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 16.0,
                    ),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filtre Butonları ve Edit Butonu (Yeniden Konumlandırıldı)
                        Row(
                          children: [
                            // In stock button
                            SizedBox(
                              width: 140 * 1.6,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _showInStock = true;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size(140 * 1.6, 50),
                                  side: BorderSide(
                                    color:
                                        _showInStock
                                            ? const Color(0xFFFF8800)
                                            : Colors.grey.shade300,
                                  ),
                                  foregroundColor:
                                      _showInStock
                                          ? const Color(0xFFFF8800)
                                          : Colors.grey.shade600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "In stock",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Out of stock button
                            SizedBox(
                              width: 160 * 1.6,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _showInStock = false;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size(160 * 1.6, 50),
                                  side: BorderSide(
                                    color:
                                        !_showInStock
                                            ? const Color(0xFFFF8800)
                                            : Colors.grey.shade300,
                                  ),
                                  foregroundColor:
                                      !_showInStock
                                          ? const Color(0xFFFF8800)
                                          : Colors.grey.shade600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Out of stock",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ), // Adjust space before Edit button
                            // Edit Button (Positioned closer to middle)
                            ElevatedButton(
                              onPressed: () {
                                context.push('/favorites/edit');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00EEFF),
                                foregroundColor: Colors.black,
                                minimumSize: const Size(200, 75),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Edit",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 32,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Ürün Gridi (crossAxisCount: 5)
                        const SizedBox(height: 25),
                        _buildProductGrid(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50), // Bottom padding
                ],
              ),
            ),
          ),

          // Overlay Components
          if (_showCartSuccess)
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(
                child: CartSuccessMessage(
                  message: "Product has been added to your cart!",
                  onClose: () {
                    setState(() {
                      _showCartSuccess = false;
                    });
                  },
                  onViewCart: () {
                    context.go('/cart');
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Sıralama tipinin adını getir
  String _getSortTypeName() {
    switch (_sortType) {
      case 'price-high':
        return 'Price ↓';
      case 'price-low':
        return 'Price ↑';
      case 'oldest':
        return 'Oldest';
      case 'newest':
        return 'Newest';
      case 'name-asc':
        return 'Name A-Z';
      case 'name-desc':
        return 'Name Z-A';
      default:
        return 'Default';
    }
  }

  // Sıralama seçeneği oluştur (PopupMenuButton için)
  Widget _buildSortMenuItem(String type, String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: _sortType == type ? Colors.grey.shade200 : Colors.transparent,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: _sortType == type ? FontWeight.bold : FontWeight.normal,
          color: _sortType == type ? const Color(0xFFFF8800) : Colors.black87,
        ),
      ),
    );
  }

  // Ürün grid'i oluştur (crossAxisCount: 5)
  Widget _buildProductGrid() {
    final filteredProducts =
        _favoriteProducts
            .where((p) => _showInStock ? p.inStock : !p.inStock)
            .toList();

    if (filteredProducts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Text(
            _showInStock
                ? 'No favorite products currently in stock.'
                : 'No favorite products currently out of stock.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // Changed to 5
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  // Ürün kartı widget'ı
  Widget _buildProductCard(FavoriteProduct product) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ürün Resmi ve Menü
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    image:
                        product.imageUrl != null &&
                                product.imageUrl!.isNotEmpty &&
                                !product.imageUrl!.startsWith('/')
                            ? DecorationImage(
                              image: NetworkImage(product.imageUrl!),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {
                                print("Image Load Error: $exception");
                              },
                            )
                            : null,
                  ),
                  width: double.infinity,
                  child:
                      (product.imageUrl == null ||
                              product.imageUrl!.isEmpty ||
                              product.imageUrl!.startsWith('/'))
                          ? Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey.shade500,
                            ),
                          )
                          : null,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Menu tapped for ${product.name}'),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: MenuIcon(
                        width: 16,
                        height: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Ürün Bilgileri
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF223263),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${product.price.toStringAsFixed(2)} TL",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF40BFFF),
                        ),
                      ),
                      InkWell(
                        onTap: _handleCartSuccess,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: CartFavoritesIcon(
                            width: 20,
                            height: 20,
                            color: const Color(0xFF40BFFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
