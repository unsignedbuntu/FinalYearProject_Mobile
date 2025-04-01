import 'package:flutter/material.dart';
import 'package:project/widgets/sidebar/siderbar.dart';
import 'package:project/screens/favorites/empty_favorites.dart';
import 'package:project/components/messages/favorites_header.dart';
import 'package:project/components/icons/arrowdown.dart';
import 'package:project/components/messages/cart_success_message.dart';
import 'package:project/components/messages/favorite_lists.dart';
import 'package:project/models/product.dart'; // Ana Product modelini import edelim
import 'package:project/components/icons/menu.dart';
import 'package:project/components/icons/cart_favorites.dart';

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
        _showListSelection = true;
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
    Navigator.pushNamed(context, '/product/$id');
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

                  // Başlık ve Sıralama Bölümü
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FavoritesHeader(
                          itemCount: _favoriteProducts.length,
                          onClearAll: () {
                            setState(() {
                              _favoriteProducts.clear();
                            });
                          },
                        ),
                      ),

                      // Sıralama Bölümü
                      Padding(
                        padding: const EdgeInsets.only(right: 470),
                        child: Row(
                          children: [
                            const Text(
                              "Sort",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 36,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(width: 32),

                            // Sıralama Butonu
                            PopupMenuButton<String>(
                              offset: const Offset(
                                0,
                                15,
                              ), // Butonun hemen altında açılması için
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
                                width: 200,
                                height: 75,
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
                                    Text(
                                      _getSortTypeName(),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 32,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFFFF8800),
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
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Ana İçerik Alanı
                  Container(
                    width: 1000,
                    height: 750,
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filtre Butonları
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _showInStock = true;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(140, 50),
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
                            const SizedBox(width: 16),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _showInStock = false;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(160, 50),
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
                            const SizedBox(width: 110),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/favorites/edit');
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

                        // Ürün Gridi
                        const SizedBox(height: 25),
                        Expanded(child: _buildProductGrid()),
                      ],
                    ),
                  ),

                  // Favori listeleri
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FavoriteLists(
                      items:
                          _favoriteProducts
                              .map(
                                (p) => FavoriteItem(
                                  id: p.id.toString(),
                                  name: p.name,
                                  imageUrl: p.imageUrl ?? '',
                                  price: p.price,
                                ),
                              )
                              .toList(),
                      onRemove: _handleRemoveProduct,
                      onViewProduct: _handleViewProduct,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Overlay Bileşenleri
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
                    Navigator.pushNamed(context, '/cart');
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: _sortType == type ? const Color(0xFFF5F5F5) : Colors.transparent,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: _sortType == type ? FontWeight.bold : FontWeight.normal,
          color: _sortType == type ? const Color(0xFFFF8800) : Colors.black,
        ),
      ),
    );
  }

  // Ürün grid'i oluştur
  Widget _buildProductGrid() {
    // Sadece stokta olanları veya olmayanları filtrele
    final filteredProducts =
        _favoriteProducts
            .where((p) => _showInStock ? p.inStock : !p.inStock)
            .toList();

    // 2x4 grid
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1, // Kare ürünler
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ürün Resmi ve Menü
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  width: double.infinity,
                  child:
                      product.imageUrl == null ||
                              product.imageUrl!.startsWith('/')
                          ? Center(
                            child: Text('Image: ${product.imageUrl ?? "None"}'),
                          )
                          : Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 32,
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
                      // Menu göster
                    },
                    child: MenuIcon(width: 20, height: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          // Ürün Bilgileri
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF223263),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      child: CartFavoritesIcon(
                        width: 20,
                        height: 20,
                        color: const Color(0xFF40BFFF),
                      ),
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
